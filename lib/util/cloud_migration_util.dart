import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';

class CloudMigrationUtil {

  static void migrateExistingWatches() {
    final box = Boxes.getWatches();
    bool modified = false;

    for (var watch in box.values) {
      // 1. Assign UUID if missing or empty
      if (watch.id == null || watch.id!.isEmpty) {
        watch.id = const Uuid().v4();
      }

      // 2. Assign updatedAt timestamp if missing
      if (watch.updatedAt == null) {
        watch.updatedAt = DateTime.now();
      }

      // 3. Ensure sync flags and force isDirty = true so restored/migrated watches push to cloud
      watch.isDeleted ??= false;
      watch.isDirty = true;
      watch.frontImageSynced ??= (watch.frontImagePath == null || watch.frontImagePath!.isEmpty);
      watch.backImageSynced ??= (watch.backImagePath == null || watch.backImagePath!.isEmpty);
      watch.lumeImageSynced ??= (watch.lumeImagePath == null || watch.lumeImagePath!.isEmpty);

      watch.save(); // Persist changes back to Hive
      modified = true;
    }

    if (modified) {
      debugPrint('Successfully migrated and marked existing local watches as dirty for sync.');
    }
  }

}
