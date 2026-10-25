import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wristcheck/boxes.dart';

class AccuracyMigrationUtil {
  static void migrateExistingMeasurements() {
    final measurementBox = Boxes.getMeasurements();
    final watchBox = Boxes.getWatches();
    bool modified = false;

    for (var measurement in measurementBox.values) {
      if (measurement.id == null || measurement.id!.isEmpty) {
        measurement.id = const Uuid().v4();
      }

      if (measurement.watchId == null || measurement.watchId!.isEmpty) {
        final parentWatch = watchBox.get(measurement.watchKey);
        if (parentWatch != null && parentWatch.id != null) {
          measurement.watchId = parentWatch.id;
        }
      }

      if (measurement.updatedAt == null) {
        measurement.updatedAt = DateTime.now();
      }

      measurement.isDeleted ??= false;
      measurement.isDirty = true; // Force dirty so restored/migrated records push to cloud

      measurement.save();
      modified = true;
    }

    if (modified) {
      debugPrint('Successfully migrated and marked existing local measurements as dirty for sync.');
    }
  }
}
