import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';

class CloudMigrationUtil {

  static void migrateExistingWatches({bool forceDirty = false}) {
    final box = Boxes.getWatches();
    bool anyModified = false;

    for (var watch in box.values) {
      bool watchModified = false;

      // 1. Assign UUID if missing or empty
      if (watch.id == null || watch.id!.isEmpty) {
        watch.id = const Uuid().v4();
        watch.isDirty = true;
        watchModified = true;
      }

      // 2. Assign updatedAt timestamp if missing
      if (watch.updatedAt == null) {
        watch.updatedAt = DateTime.now().toUtc();
        watch.isDirty = true;
        watchModified = true;
      }

      // 3. Ensure sync flags are initialized without forcing already-synced watches dirty on every launch
      if (watch.isDeleted == null) {
        watch.isDeleted = false;
        watchModified = true;
      }
      if (watch.isDirty == null) {
        watch.isDirty = true;
        watchModified = true;
      }
      if (watch.frontImageSynced == null) {
        watch.frontImageSynced = (watch.frontImagePath == null || watch.frontImagePath!.isEmpty);
        watchModified = true;
      }
      if (watch.backImageSynced == null) {
        watch.backImageSynced = (watch.backImagePath == null || watch.backImagePath!.isEmpty);
        watchModified = true;
      }
      if (watch.lumeImageSynced == null) {
        watch.lumeImageSynced = (watch.lumeImagePath == null || watch.lumeImagePath!.isEmpty);
        watchModified = true;
      }

      if (forceDirty) {
        watch.isDirty = true;
        watch.frontImageSynced = (watch.frontImagePath == null || watch.frontImagePath!.isEmpty);
        watch.backImageSynced = (watch.backImagePath == null || watch.backImagePath!.isEmpty);
        watch.lumeImageSynced = (watch.lumeImagePath == null || watch.lumeImagePath!.isEmpty);
        watchModified = true;
      }

      if (watchModified) {
        watch.save(); // Persist changes back to Hive
        anyModified = true;
      }
    }

    if (anyModified) {
      debugPrint('Successfully migrated local watches for cloud sync.');
    }
  }

}
