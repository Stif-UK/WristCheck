import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';

class CloudMigrationUtil {

  static void migrateExistingWatches() {
    final box = Boxes.getWatches();
    bool modified = false;

    for (var watch in box.values) {
      bool updated = false;

      // 1. Assign UUID if missing or empty
      if (watch.id == null || watch.id!.isEmpty) {
        watch.id = const Uuid().v4();
        updated = true;
      }

      // 2. Assign updatedAt timestamp if missing
      if (watch.updatedAt == null) {
        watch.updatedAt = DateTime.now();
        updated = true;
      }

      // 3. Ensure other sync flags have defaults
      watch.isDeleted ??= false;
      watch.frontImageSynced ??= (watch.frontImagePath == null || watch.frontImagePath!.isEmpty);
      watch.backImageSynced ??= (watch.backImagePath == null || watch.backImagePath!.isEmpty);
      watch.lumeImageSynced ??= (watch.lumeImagePath == null || watch.lumeImagePath!.isEmpty);

      if (updated) {
        watch.save(); // Persist changes back to Hive
        modified = true;
      }
    }

    if (modified) {
      debugPrint('Successfully migrated existing local watches with new UUIDs and sync metadata.');
    }
  }

}
