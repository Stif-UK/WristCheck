import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/sync_controller.dart';
import 'package:wristcheck/model/watches.dart';

class SyncService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _watchesTable = 'watches';
  static const String _storageBucket = 'watch_images';
  static bool _isSyncing = false;
  static DateTime? lastLocalWriteTime;

  static void _safeSetStatus(SyncStatusState state, {String? error}) {
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.setStatus(state, error: error);
    }
  }

  /// Performs a full bidirectional sync (Push local changes, Pull remote changes, Sync images)
  static Future<void> syncData() async {
    if (_isSyncing) {
      debugPrint('SyncService: Sync already in progress. Skipping overlapping call.');
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
      final box = Boxes.getWatches();
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.totalWatches.value = max(1, box.length);
        SyncController.to.syncedWatches.value = 0;
      }

      debugPrint('SyncService: Starting background synchronization for user ${user.id}...');
      await _pushLocalChanges(user.id);
      await _pullRemoteChanges(user.id);
      await _syncImages(user.id);

      if (Get.isRegistered<SyncController>()) {
        SyncController.to.syncedWatches.value = SyncController.to.totalWatches.value;
      }
      lastLocalWriteTime = DateTime.now();
      _safeSetStatus(SyncStatusState.upToDate);
      debugPrint('SyncService: Synchronization completed successfully at $lastLocalWriteTime.');
    } catch (e, stackTrace) {
      _safeSetStatus(SyncStatusState.syncFailure, error: e.toString());
      debugPrint('SyncService: Error during synchronization: $e');
      debugPrint(stackTrace.toString());
    } finally {
      _isSyncing = false;
    }
  }

  /// 1. Push local changes (and soft deletes) to Supabase in a single batch
  static Future<void> _pushLocalChanges(String userId) async {
    final box = Boxes.getWatches();
    debugPrint('SyncService: Pushing ${box.length} local watches to Supabase for user $userId...');
    if (box.isEmpty) return;

    final List<Map<String, dynamic>> batchPayload = [];
    int done = 0;
    int total = max(1, box.length);

    for (var watch in box.values) {
      watch.ensureInitialized();
      final data = watch.toJson();
      data['user_id'] = userId;
      batchPayload.add(data);
      done++;
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.syncedWatches.value = ((done / total) * (total / 2)).floor();
      }
    }

    // Perform a single batch upsert request to Supabase
    await _supabase.from(_watchesTable).upsert(batchPayload);
    debugPrint('SyncService: Successfully pushed batch of ${batchPayload.length} local watches.');
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
    
    // Dynamically update totalWatches to reflect actual remote count if local was empty
    final actualTotal = max(1, max(box.length, remoteData.length));
    if (Get.isRegistered<SyncController>()) {
      SyncController.to.totalWatches.value = actualTotal;
    }

    int done = 0;
    int totalRemote = max(1, remoteData.length);

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
            localWatch.frontImageSynced = remoteWatch.frontImageSynced;
            localWatch.backImageSynced = remoteWatch.backImageSynced;
            localWatch.lumeImageSynced = remoteWatch.lumeImageSynced;
            await localWatch.save();
            debugPrint('SyncService: Updated local watch from newer remote version: ${localWatch.manufacturer} ${localWatch.model}');
          }
        }
      }
      done++;
      if (Get.isRegistered<SyncController>()) {
        SyncController.to.syncedWatches.value = min(actualTotal, ((actualTotal / 2)).floor() + ((done / totalRemote) * (actualTotal / 2)).floor());
      }
    }
    debugPrint('SyncService: Pulled and synced remote changes from Supabase.');
  }

  /// 3. Upload local images and download missing remote images via Supabase Storage
  static Future<void> _syncImages(String userId) async {
    final box = Boxes.getWatches();
    final directory = await getApplicationDocumentsDirectory();

    for (var watch in box.values) {
      if (watch.id != null) {
        // --- Front Image ---
        if (watch.frontImagePath != null && watch.frontImagePath!.isNotEmpty) {
          final localFile = File("${directory.path}${watch.frontImagePath}");
          final storagePath = '$userId/${watch.id}/front.jpg';

          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download(storagePath);
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
              watch.frontImageSynced = true;
              await watch.save();
            } catch (_) {}
          } else if (watch.frontImageSynced != true) {
            try {
              await _supabase.storage.from(_storageBucket).upload(
                    storagePath,
                    localFile,
                    fileOptions: const FileOptions(upsert: true),
                  );
              watch.frontImageSynced = true;
              await watch.save();
            } catch (e) {
              debugPrint('SyncService: Error uploading front image: $e');
            }
          }
        }

        // --- Back Image ---
        if (watch.backImagePath != null && watch.backImagePath!.isNotEmpty) {
          final localFile = File("${directory.path}${watch.backImagePath}");
          final storagePath = '$userId/${watch.id}/back.jpg';

          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download(storagePath);
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
              watch.backImageSynced = true;
              await watch.save();
            } catch (_) {}
          } else if (watch.backImageSynced != true) {
            try {
              await _supabase.storage.from(_storageBucket).upload(
                    storagePath,
                    localFile,
                    fileOptions: const FileOptions(upsert: true),
                  );
              watch.backImageSynced = true;
              await watch.save();
            } catch (e) {
              debugPrint('SyncService: Error uploading back image: $e');
            }
          }
        }

        // --- Lume Image ---
        if (watch.lumeImagePath != null && watch.lumeImagePath!.isNotEmpty) {
          final localFile = File("${directory.path}${watch.lumeImagePath}");
          final storagePath = '$userId/${watch.id}/lume.jpg';

          if (!localFile.existsSync()) {
            try {
              final Uint8List bytes = await _supabase.storage.from(_storageBucket).download(storagePath);
              await localFile.parent.create(recursive: true);
              await localFile.writeAsBytes(bytes);
              watch.lumeImageSynced = true;
              await watch.save();
            } catch (_) {}
          } else if (watch.lumeImageSynced != true) {
            try {
              await _supabase.storage.from(_storageBucket).upload(
                    storagePath,
                    localFile,
                    fileOptions: const FileOptions(upsert: true),
                  );
              watch.lumeImageSynced = true;
              await watch.save();
            } catch (e) {
              debugPrint('SyncService: Error uploading lume image: $e');
            }
          }
        }
      }
    }
  }
}
