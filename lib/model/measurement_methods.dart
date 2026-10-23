import 'dart:async';
import 'package:hive_ce/hive.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/sync/sync_service.dart';

/*
This class provides static methods to interact with the Measurements database
 */
class MeasurementMethods{

  static Future<int> addMeasurement(int watchKey, bool baseLine, DateTime atomicTime, DateTime watchTime, double? rate) async {
    final parentWatch = Boxes.getWatches().get(watchKey);
    final measurement = Measurement()
      ..watchKey = watchKey
      ..baseLine = baseLine
      ..atomicTime = atomicTime
      ..watchTime = watchTime
      ..rawAccuracy = rate;

    measurement.ensureInitialized(parentWatch?.id ?? '');

    final box = Boxes.getMeasurements();
    final result = await box.add(measurement);
    unawaited(SyncService.syncData());
    return result;
  }

  static Measurement? getLastBaseLineForWatch(Watches watch){
    final List<Measurement> records = Boxes.getMeasurementsForWatch(watch).toList().where((record) => record.isDeleted != true).toList();
    final List<Measurement> baselines = records.where((record) => record.baseLine == true).toList();
    if(baselines.isEmpty) return null;
    baselines.sort((a,b)=> b.atomicTime.compareTo(a.atomicTime));
    return baselines.first;
  }

  static Measurement? getMeasurementByIndex(int key){
    final Box<Measurement> box = Boxes.getMeasurements();
    return box.get(key);
  }

  static Measurement? getLatestMeasurementForWatch(Watches watch){
    final List<Measurement> records = Boxes.getMeasurementsForWatch(watch).toList().where((record) => record.isDeleted != true).toList();
    if(records.isEmpty) return null;
    records.sort((a,b)=> b.atomicTime.compareTo(a.atomicTime));
    return records.first;
  }

  static Future<void> addRateToRecord(int key, double rate) async {
    final Box<Measurement> box = Boxes.getMeasurements();
    Measurement? record = box.get(key);
    if(record != null) {
      final parentWatch = Boxes.getWatches().get(record.watchKey);
      record.ensureInitialized(parentWatch?.id ?? record.watchId ?? '');
      record.rawAccuracy = rate;
      record.isDirty = true;
      record.updatedAt = DateTime.now();
      await record.save();
      unawaited(SyncService.syncData());
    }
  }

  static Future<bool> deleteRecord(int key) async {
    final Box<Measurement> box = Boxes.getMeasurements();
    Measurement? record = box.get(key);
    if(record != null) {
      final parentWatch = Boxes.getWatches().get(record.watchKey);
      record.ensureInitialized(parentWatch?.id ?? record.watchId ?? '');
      record.isDeleted = true;
      record.isDirty = true;
      record.updatedAt = DateTime.now();
      await record.save();
      await SyncService.syncData();
      await record.delete();
      return true;
    }
    return false;
  }

  static clearMeasurementData(){
    final Box<Measurement> box = Boxes.getMeasurements();
    box.clear();
  }

}
