import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';

class SyncService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _watchesTable = 'watches';
  static const String _storageBucket = 'watch_images';

  /// Performs a full bidirectional sync (Push local changes, Pull remote changes, Sync images)
  static Future<void> syncData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('SyncService: No authenticated user. Skipping sync.');
      return;
    }

    try {
      debugPrint('SyncService: Starting synchronization for user ${user.id}...');
      await _pushLocalChanges(user.id);
      await _pullRemoteChanges(user.id);
      await _syncImages(user.id);
      debugPrint('SyncService: Synchronization completed successfully.');
    } catch (e, stackTrace) {
      debugPrint('SyncService: Error during synchronization: $e');
      debugPrint(stackTrace.toString());
    }
  }

  /// 1. Push local changes (and soft deletes) to Supabase
  static Future<void> _pushLocalChanges(String userId) async {
    final box = Boxes.getWatches();
    for (var watch in box.values) {
      watch.ensureInitialized();

      final data = watch.toJson();
      data['user_id'] = userId; // Injected dynamically at sync time

      await _supabase.from(_watchesTable).upsert(data);
    }
    debugPrint('SyncService: Pushed ${box.length} local watches to Supabase.');
  }

  /// 2. Pull remote changes from Supabase and apply Last-Write-Wins conflict resolution
  static Future<void> _pullRemoteChanges(String userId) async {
    final response = await _supabase
        .from(_watchesTable)
        .select()
        .eq('user_id', userId);

    final List<dynamic> remoteData = response as List<dynamic>;
    final box = Boxes.getWatches();

    for (var item in remoteData) {
      final remoteMap = item as Map<String, dynamic>;
      final remoteWatch = Watches.fromJson(remoteMap);
      final remoteId = remoteWatch.id;

      if (remoteId == null) continue;

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
        }
      } else {
        // Conflict Resolution: Last-Write-Wins based on updatedAt
        final localTime = localWatch.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final remoteTime = remoteWatch.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

        if (remoteWatch.isDeleted == true) {
          // If remote is marked deleted, delete locally
          await localWatch.delete();
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
        }
      }
    }
    debugPrint('SyncService: Pulled and synced remote changes from Supabase.');
  }

  /// 3. Upload/Download images to Supabase Storage
  static Future<void> _syncImages(String userId) async {
    final box = Boxes.getWatches();
    final directory = await getApplicationDocumentsDirectory();

    for (var watch in box.values) {
      if (watch.id == null) continue;

      // Sync Front Image
      if (watch.frontImagePath != null && watch.frontImagePath!.isNotEmpty && watch.frontImageSynced != true) {
        final localFile = File("${directory.path}${watch.frontImagePath}");
        if (await localFile.exists()) {
          final storagePath = '$userId/${watch.id}/front.jpg';
          await _supabase.storage.from(_storageBucket).upload(
                storagePath,
                localFile,
                fileOptions: const FileOptions(upsert: true),
              );
          watch.frontImageSynced = true;
          await watch.save();
        }
      }

      // Sync Back Image
      if (watch.backImagePath != null && watch.backImagePath!.isNotEmpty && watch.backImageSynced != true) {
        final localFile = File("${directory.path}${watch.backImagePath}");
        if (await localFile.exists()) {
          final storagePath = '$userId/${watch.id}/back.jpg';
          await _supabase.storage.from(_storageBucket).upload(
                storagePath,
                localFile,
                fileOptions: const FileOptions(upsert: true),
              );
          watch.backImageSynced = true;
          await watch.save();
        }
      }

      // Sync Lume Image
      if (watch.lumeImagePath != null && watch.lumeImagePath!.isNotEmpty && watch.lumeImageSynced != true) {
        final localFile = File("${directory.path}${watch.lumeImagePath}");
        if (await localFile.exists()) {
          final storagePath = '$userId/${watch.id}/lume.jpg';
          await _supabase.storage.from(_storageBucket).upload(
                storagePath,
                localFile,
                fileOptions: const FileOptions(upsert: true),
              );
          watch.lumeImageSynced = true;
          await watch.save();
        }
      }
    }
  }
}
