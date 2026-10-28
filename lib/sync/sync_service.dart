import 'dart:io';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/sync_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/user/conflict_resolution_dialog.dart';
import 'package:wristcheck/util/images_util.dart';

class SyncService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _watchesTable = 'watches';
  static const String _measurementsTable = 'measurements';
  static const String _storageBucket = 'watch_images';
  static bool _isSyncing = false;
  static bool _syncRequestedAgain = false;
  static DateTime? lastLocalWriteTime;

  static void _safeSetStatus(SyncStatusState state, {String? error}) {
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.setStatus(state, error: error);
    }
  }

  /// Entry point for syncing that first warns if cloud data exists, giving option to prioritize cloud or merge
  static Future<void> checkForConflictsAndSync() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _safeSetStatus(SyncStatusState.waitingForConnection);
      debugPrint('SyncService: No authenticated user. Skipping sync.');
      return;
    }

    final box = Boxes.getWatches();
    if (box.isEmpty) {
      await syncData();
      return;
    }

    try {
      final response = await _supabase
          .from(_watchesTable)
          .select()
          .eq('user_id', user.id);

      final List<dynamic> remoteData = response as List<dynamic>;
      if (remoteData.isEmpty) {
        await syncData();
        return;
      }

      final remoteIds = remoteData.map((e) => e['id'] as String?).toSet();
      bool hasUnsyncedLocal = box.values.any((w) => w.id == null || !remoteIds.contains(w.id));

      if (!hasUnsyncedLocal) {
        await syncData();
        return;
      }

      // 1. Show high-level warning dialog first
      final l = AppLocalizations.of(Get.context!)!;
      await FirebaseAnalytics.instance.logEvent(name: "existing_cloud_data_dialog_shown");
      await Get.defaultDialog(
        title: l.existingCloudDataTitle,
        middleText: l.existingCloudDataMessage,
        barrierDismissible: false,
        textConfirm: l.prioritizeCloudOption,
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () async {
          await FirebaseAnalytics.instance.logEvent(name: "existing_cloud_data_action", parameters: {"action": "prioritize_cloud"});
          Get.back();
          // Clean up local images to free up device space
          await ImagesUtil.deleteAllImages();
          // Clear local boxes and pull cloud data fresh
          await box.clear();
          await Boxes.getMeasurements().clear();
          await syncData();
        },
        textCancel: l.mergeCollectionsOption,
        cancelTextColor: Colors.black,
        onCancel: () async {
          await FirebaseAnalytics.instance.logEvent(name: "existing_cloud_data_action", parameters: {"action": "merge"});
          Get.back();
          await Future.delayed(const Duration(milliseconds: 100));
          // User chose to merge -> Proceed to detect individual duplicate conflicts
          await _detectAndResolveDuplicates(box, remoteData);
        },
      );
    } catch (e) {
      debugPrint('SyncService: Error checking conflicts: $e');
      await syncData();
    }
  }

  static Future<void> _detectAndResolveDuplicates(Box<Watches> box, List<dynamic> remoteData) async {
    final remoteIds = remoteData.map((e) => e['id'] as String?).toSet();
    List<ConflictItem> conflicts = [];

    for (var localWatch in box.values) {
      if (localWatch.id != null && remoteIds.contains(localWatch.id)) continue;

      for (var remoteItem in remoteData) {
        final remoteWatch = Watches.fromJson(remoteItem as Map<String, dynamic>);
        if (localWatch.manufacturer.toLowerCase().trim() == remoteWatch.manufacturer.toLowerCase().trim() &&
            localWatch.model.toLowerCase().trim() == remoteWatch.model.toLowerCase().trim()) {
          conflicts.add(ConflictItem(localWatch: localWatch, remoteWatch: remoteWatch));
          break;
        }
      }
    }

    if (conflicts.isNotEmpty) {
      await Get.dialog(
        ConflictResolutionDialog(
          conflicts: conflicts,
          resolvedCallback: () async {
            for (var item in conflicts) {
              if (item.choice == ConflictChoice.prioritizeCloud) {
                await item.localWatch.delete();
              } else if (item.choice == ConflictChoice.prioritizeLocal) {
                item.localWatch.id = item.remoteWatch.id;
                item.localWatch.isDirty = true;
                await item.localWatch.save();
              } else if (item.choice == ConflictChoice.keepBoth) {
                item.localWatch.id = const Uuid().v4();
                item.localWatch.isDirty = true;
                await item.localWatch.save();
              }
            }
            await syncData();
          },
        ),
        barrierDismissible: false,
      );
    } else {
      await syncData();
    }
  }

  /// Performs a full bidirectional sync with automatic re-sync queuing if triggered during an active sync
  static Future<void> syncData() async {
    if (_isSyncing) {
      debugPrint('SyncService: Sync already in progress. Queuing re-sync request.');
      _syncRequestedAgain = true;
      return;
    }

    final user = _supabase.auth.currentUser;
    if (user == null) {
      _safeSetStatus(SyncStatusState.waitingForConnection);
      debugPrint('SyncService: No authenticated user. Skipping sync.');
      return;
    }

    _isSyncing = true;
    _safeSetStatus(SyncStatusState.inProgress);

    try {
      do {
        _syncRequestedAgain = false;
        try {
          debugPrint('SyncService: Starting synchronization for user ${user.id}...');
          
          // Phase 1: Watches
          if (Get.isRegistered<SyncController>()) {
            SyncController.to.currentPhase.value = 'watches';
          }
          await _pushLocalChanges(user.id);
          await _pullRemoteChanges(user.id);

          // Phase 2: Accuracy Records
          if (Get.isRegistered<SyncController>()) {
            SyncController.to.currentPhase.value = 'accuracy';
          }
          await _pushLocalMeasurements(user.id);
          await _pullRemoteMeasurements(user.id);

          // Phase 3: Images
          if (Get.isRegistered<SyncController>()) {
            SyncController.to.currentPhase.value = 'images';
          }
          await _syncImages(user.id);

          if (Get.isRegistered<SyncController>()) {
            SyncController.to.currentPhase.value = 'done';
          }

          lastLocalWriteTime = DateTime.now();
          _safeSetStatus(SyncStatusState.upToDate);
          debugPrint('SyncService: Synchronization completed successfully at $lastLocalWriteTime.');
        } catch (e, stackTrace) {
          _safeSetStatus(SyncStatusState.syncFailure, error: e.toString());
          debugPrint('SyncService: Error during synchronization: $e');
          debugPrint(stackTrace.toString());
        }
      } while (_syncRequestedAgain);
    } finally {
      _isSyncing = false;
    }
  }

  /// 1. Push local dirty changes to Supabase in a single batch
  static Future<void> _pushLocalChanges(String userId) async {
    final box = Boxes.getWatches();
    final dirtyWatches = box.values
        .where((w) => (w.isDirty == true || w.isDeleted == true))
        .toList();

    debugPrint('SyncService: Found ${dirtyWatches.length} dirty/deleted local watches to push.');
    
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.watchTotal.value = max(1, box.values.length);
      SyncController.to.watchSynced.value = 0;
    }

    if (dirtyWatches.isEmpty) {
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.watchSynced.value = SyncController.to.watchTotal.value;
      }
      return;
    }

    final List<Map<String, dynamic>> batchPayload = [];

    for (var watch in dirtyWatches) {
      watch.ensureInitialized();
      final data = watch.toJson();
      data['user_id'] = userId;
      batchPayload.add(data);
    }

    // Perform a single batch upsert request to Supabase
    await _supabase.from(_watchesTable).upsert(batchPayload);

    // Upload local images for dirty watches
    final directory = await getApplicationDocumentsDirectory();
    for (var watch in dirtyWatches) {
      if (watch.id != null) {
        if (watch.isDeleted == true) {
          try {
            await _supabase.storage.from(_storageBucket).remove([
              '$userId/${watch.id}/front.jpg',
              '$userId/${watch.id}/back.jpg',
              '$userId/${watch.id}/lume.jpg',
            ]);
          } catch (_) {}
          await watch.delete();
        } else {
          // Upload local images to Supabase storage if files exist
          if (watch.frontImagePath != null && watch.frontImagePath!.trim().isNotEmpty) {
            final f = File("${directory.path}${watch.frontImagePath}");
            if (f.existsSync()) {
              try {
                await _supabase.storage.from(_storageBucket).upload(
                      '$userId/${watch.id}/front.jpg',
                      f,
                      fileOptions: const FileOptions(upsert: true),
                    );
              } catch (_) {}
            }
          }
          if (watch.backImagePath != null && watch.backImagePath!.trim().isNotEmpty) {
            final f = File("${directory.path}${watch.backImagePath}");
            if (f.existsSync()) {
              try {
                await _supabase.storage.from(_storageBucket).upload(
                      '$userId/${watch.id}/back.jpg',
                      f,
                      fileOptions: const FileOptions(upsert: true),
                    );
              } catch (_) {}
            }
          }
          if (watch.lumeImagePath != null && watch.lumeImagePath!.trim().isNotEmpty) {
            final f = File("${directory.path}${watch.lumeImagePath}");
            if (f.existsSync()) {
              try {
                await _supabase.storage.from(_storageBucket).upload(
                      '$userId/${watch.id}/lume.jpg',
                      f,
                      fileOptions: const FileOptions(upsert: true),
                    );
              } catch (_) {}
            }
          }

          watch.isDirty = false;
          await watch.save();
        }
      }
    }

    if (Get.isRegistered<SyncController>()) {
      SyncController.to.watchSynced.value = SyncController.to.watchTotal.value;
    }

    debugPrint('SyncService: Successfully pushed batch of ${batchPayload.length} dirty watches.');
  }

  /// 2. Pull remote changes from Supabase and apply Last-Write-Wins conflict resolution
  static Future<void> _pullRemoteChanges(String userId) async {
    debugPrint('SyncService: Pulling remote changes from Supabase for user $userId...');
    final response = await _supabase
        .from(_watchesTable)
        .select()
        .eq('user_id', userId);

    final List<dynamic> remoteData = response as List<dynamic>;
    debugPrint('SyncService: Fetched ${remoteData.length} remote watches from Supabase.');

    final box = Boxes.getWatches();
    
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.watchTotal.value = max(1, max(box.values.length, remoteData.length));
      SyncController.to.watchSynced.value = 0;
    }

    int done = 0;

    for (var item in remoteData) {
      final remoteMap = item as Map<String, dynamic>;
      final remoteWatch = Watches.fromJson(remoteMap);
      final remoteId = remoteWatch.id;

      if (remoteId != null) {
        // Find matching local watch by UUID id
        Watches? localWatch;
        for (var w in box.values) {
          if (w.id == remoteId) {
            localWatch = w;
            break;
          }
        }

        if (localWatch == null) {
          // If remote watch is not deleted and doesn't exist locally, insert it
          if (remoteWatch.isDeleted != true) {
            await box.add(remoteWatch);
            debugPrint('SyncService: Added new remote watch locally: ${remoteWatch.manufacturer} ${remoteWatch.model}');
          }
        } else {
          // Conflict Resolution: Last-Write-Wins based on updatedAt
          final localTime = localWatch.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final remoteTime = remoteWatch.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

          if (remoteWatch.isDeleted == true) {
            // If remote is marked deleted, delete locally
            await localWatch.delete();
            debugPrint('SyncService: Deleted local watch due to remote soft-delete: ${localWatch.manufacturer} ${localWatch.model}');
          } else if (remoteTime.isAfter(localTime)) {
            // Remote is newer, update local record properties
            localWatch.manufacturer = remoteWatch.manufacturer;
            localWatch.model = remoteWatch.model;
            localWatch.serialNumber = remoteWatch.serialNumber;
            localWatch.favourite = remoteWatch.favourite;
            localWatch.status = remoteWatch.status;
            localWatch.purchaseDate = remoteWatch.purchaseDate;
            localWatch.lastServicedDate = remoteWatch.lastServicedDate;
            localWatch.serviceInterval = remoteWatch.serviceInterval;
            localWatch.nextServiceDue = remoteWatch.nextServiceDue;
            localWatch.notes = remoteWatch.notes;
            localWatch.wearList = remoteWatch.wearList;
            localWatch.frontImagePath = remoteWatch.frontImagePath;
            localWatch.referenceNumber = remoteWatch.referenceNumber;
            localWatch.backImagePath = remoteWatch.backImagePath;
            localWatch.movement = remoteWatch.movement;
            localWatch.category = remoteWatch.category;
            localWatch.purchasedFrom = remoteWatch.purchasedFrom;
            localWatch.soldTo = remoteWatch.soldTo;
            localWatch.purchasePrice = remoteWatch.purchasePrice;
            localWatch.soldPrice = remoteWatch.soldPrice;
            localWatch.soldDate = remoteWatch.soldDate;
            localWatch.deliveryDate = remoteWatch.deliveryDate;
            localWatch.warrantyEndDate = remoteWatch.warrantyEndDate;
            localWatch.caseDiameter = remoteWatch.caseDiameter;
            localWatch.lugWidth = remoteWatch.lugWidth;
            localWatch.lug2lug = remoteWatch.lug2lug;
            localWatch.caseThickness = remoteWatch.caseThickness;
            localWatch.waterResistance = remoteWatch.waterResistance;
            localWatch.caseMaterial = remoteWatch.caseMaterial;
            localWatch.winderTPD = remoteWatch.winderTPD;
            localWatch.winderDirection = remoteWatch.winderDirection;
            localWatch.dateComplication = remoteWatch.dateComplication;
            localWatch.lumeImagePath = remoteWatch.lumeImagePath;
            localWatch.year = remoteWatch.year;
            localWatch.weight = remoteWatch.weight;
            localWatch.winderTPDmax = remoteWatch.winderTPDmax;
            localWatch.value = remoteWatch.value;
            localWatch.primaryColour = remoteWatch.primaryColour;
            localWatch.secondaryColour = remoteWatch.secondaryColour;
            localWatch.powerReserve = remoteWatch.powerReserve;
            localWatch.crystal = remoteWatch.crystal;
            localWatch.crown = remoteWatch.crown;
            localWatch.primaryImageIndex = remoteWatch.primaryImageIndex;
            localWatch.updatedAt = remoteWatch.updatedAt;
            localWatch.isDeleted = remoteWatch.isDeleted;
            localWatch.isDirty = false; // Clean after pulling remote winner
            await localWatch.save();
            debugPrint('SyncService: Updated local watch from newer remote version: ${localWatch.manufacturer} ${localWatch.model}');
          }
        }
      }
      done++;
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.watchSynced.value = done;
      }
    }
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.watchSynced.value = SyncController.to.watchTotal.value;
    }
    debugPrint('SyncService: Pulled and synced remote changes from Supabase.');
  }

  /// Push local measurements
  static Future<void> _pushLocalMeasurements(String userId) async {
    final box = Boxes.getMeasurements();
    final watchBox = Boxes.getWatches();
    final dirtyMeasurements = box.values
        .where((m) => (m.isDirty == true || m.isDeleted == true))
        .toList();

    if (Get.isRegistered<SyncController>()) {
      SyncController.to.accuracyTotal.value = max(1, box.values.length);
      SyncController.to.accuracySynced.value = 0;
    }

    if (dirtyMeasurements.isEmpty) {
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.accuracySynced.value = SyncController.to.accuracyTotal.value;
      }
      return;
    }

    final List<Map<String, dynamic>> batchPayload = [];
    for (var m in dirtyMeasurements) {
      if (m.watchId == null || m.watchId!.isEmpty) {
        Watches? parentWatch;
        for (var w in watchBox.values) {
          if (w.key == m.watchKey) {
            parentWatch = w;
            break;
          }
        }
        m.ensureInitialized(parentWatch?.id ?? '');
      }
      batchPayload.add(m.toJson(userId));
    }

    await _supabase.from(_measurementsTable).upsert(batchPayload);

    for (var m in dirtyMeasurements) {
      if (m.isDeleted == true) {
        await m.delete();
      } else {
        m.isDirty = false;
        await m.save();
      }
    }
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.accuracySynced.value = SyncController.to.accuracyTotal.value;
    }
  }

  /// Pull remote measurements
  static Future<void> _pullRemoteMeasurements(String userId) async {
    final response = await _supabase
        .from(_measurementsTable)
        .select()
        .eq('user_id', userId);

    final List<dynamic> remoteData = response as List<dynamic>;
    final box = Boxes.getMeasurements();
    final watchBox = Boxes.getWatches();

    if (Get.isRegistered<SyncController>()) {
      SyncController.to.accuracyTotal.value = max(1, max(box.values.length, remoteData.length));
      SyncController.to.accuracySynced.value = 0;
    }

    int done = 0;
    for (var item in remoteData) {
      final remoteMap = item as Map<String, dynamic>;
      final remoteMeasurement = Measurement.fromJson(remoteMap);
      final remoteId = remoteMeasurement.id;

      if (remoteId != null) {
        Measurement? localMeasurement;
        for (var m in box.values) {
          if (m.id == remoteId) {
            localMeasurement = m;
            break;
          }
        }

        if (localMeasurement == null) {
          if (remoteMeasurement.isDeleted != true) {
            Watches? parentWatch;
            for (var w in watchBox.values) {
              if (w.id == remoteMeasurement.watchId) {
                parentWatch = w;
                break;
              }
            }
            if (parentWatch != null) {
              remoteMeasurement.watchKey = parentWatch.key as int;
              await box.add(remoteMeasurement);
            }
          }
        } else {
          final localTime = localMeasurement.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final remoteTime = remoteMeasurement.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

          if (remoteMeasurement.isDeleted == true) {
            await localMeasurement.delete();
          } else if (remoteTime.isAfter(localTime)) {
            Watches? parentWatch;
            for (var w in watchBox.values) {
              if (w.id == remoteMeasurement.watchId) {
                parentWatch = w;
                break;
              }
            }
            if (parentWatch != null) {
              localMeasurement.watchKey = parentWatch.key as int;
            }
            localMeasurement.watchId = remoteMeasurement.watchId;
            localMeasurement.baseLine = remoteMeasurement.baseLine;
            localMeasurement.atomicTime = remoteMeasurement.atomicTime;
            localMeasurement.watchTime = remoteMeasurement.watchTime;
            localMeasurement.rawAccuracy = remoteMeasurement.rawAccuracy;
            localMeasurement.updatedAt = remoteMeasurement.updatedAt;
            localMeasurement.isDeleted = remoteMeasurement.isDeleted;
            localMeasurement.isDirty = false;
            await localMeasurement.save();
          }
        }
      }
      done++;
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.accuracySynced.value = done;
      }
    }
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.accuracySynced.value = SyncController.to.accuracyTotal.value;
    }
  }

  /// 3. Download missing remote images via Supabase Storage
  static Future<void> _syncImages(String userId) async {
    final box = Boxes.getWatches();
    final directory = await getApplicationDocumentsDirectory();

    int missingImagesCount = 0;
    for (var watch in box.values) {
      if (watch.id != null) {
        if (watch.frontImagePath != null && watch.frontImagePath!.trim().isNotEmpty) {
          final f = File("${directory.path}${watch.frontImagePath}");
          if (!f.existsSync()) missingImagesCount++;
        }
        if (watch.backImagePath != null && watch.backImagePath!.trim().isNotEmpty) {
          final f = File("${directory.path}${watch.backImagePath}");
          if (!f.existsSync()) missingImagesCount++;
        }
        if (watch.lumeImagePath != null && watch.lumeImagePath!.trim().isNotEmpty) {
          final f = File("${directory.path}${watch.lumeImagePath}");
          if (!f.existsSync()) missingImagesCount++;
        }
      }
    }

    if (missingImagesCount == 0) {
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.imageTotal.value = 1;
        SyncController.to.imageSynced.value = 1;
      }
      return;
    }

    if (Get.isRegistered<SyncController>()) {
      SyncController.to.imageTotal.value = missingImagesCount;
      SyncController.to.imageSynced.value = 0;
    }

    int downloaded = 0;
    for (var watch in box.values) {
      if (watch.id != null) {
        // Front
        if (watch.frontImagePath != null && watch.frontImagePath!.trim().isNotEmpty) {
          final localFile = File("${directory.path}${watch.frontImagePath}");
          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download('$userId/${watch.id}/front.jpg');
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
            } catch (_) {
              // Image doesn't exist on server (e.g. legacy backup). Clear path to stop 400 Bad Request warnings.
              watch.frontImagePath = "";
              watch.isDirty = true;
              await watch.save();
            }
            downloaded++;
            if (Get.isRegistered<SyncController>()) {
              SyncController.to.imageSynced.value = downloaded;
            }
          }
        }
        // Back
        if (watch.backImagePath != null && watch.backImagePath!.trim().isNotEmpty) {
          final localFile = File("${directory.path}${watch.backImagePath}");
          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download('$userId/${watch.id}/back.jpg');
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
            } catch (_) {
              watch.backImagePath = "";
              watch.isDirty = true;
              await watch.save();
            }
            downloaded++;
            if (Get.isRegistered<SyncController>()) {
              SyncController.to.imageSynced.value = downloaded;
            }
          }
        }
        // Lume
        if (watch.lumeImagePath != null && watch.lumeImagePath!.trim().isNotEmpty) {
          final localFile = File("${directory.path}${watch.lumeImagePath}");
          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download('$userId/${watch.id}/lume.jpg');
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
            } catch (_) {
              watch.lumeImagePath = "";
              watch.isDirty = true;
              await watch.save();
            }
            downloaded++;
            if (Get.isRegistered<SyncController>()) {
              SyncController.to.imageSynced.value = downloaded;
            }
          }
        }
      }
    }

    if (Get.isRegistered<SyncController>()) {
      SyncController.to.imageSynced.value = SyncController.to.imageTotal.value;
    }
  }
}
