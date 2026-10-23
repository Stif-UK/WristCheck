import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';

class AccuracyMigrationUtil {
  static void migrateExistingMeasurements() {
    final measurementBox = Boxes.getMeasurements();
    final watchBox = Boxes.getWatches();
    bool modified = false;

    for (var measurement in measurementBox.values) {
      bool updated = false;

      if (measurement.id == null || measurement.id!.isEmpty) {
        measurement.id = const Uuid().v4();
        updated = true;
      }

      if (measurement.watchId == null || measurement.watchId!.isEmpty) {
        final parentWatch = watchBox.get(measurement.watchKey);
        if (parentWatch != null && parentWatch.id != null) {
          measurement.watchId = parentWatch.id;
          updated = true;
        }
      }

      if (measurement.updatedAt == null) {
        measurement.updatedAt = DateTime.now();
        updated = true;
      }

      measurement.isDeleted ??= false;
      measurement.isDirty ??= true;

      if (updated) {
        measurement.save();
        modified = true;
      }
    }

    if (modified) {
      debugPrint('Successfully migrated existing local measurements with UUIDs and watchId links.');
    }
  }
}
