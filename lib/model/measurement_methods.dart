import 'package:hive/hive.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';

/*
This class provides static methods to interact with the Measurements database
 */
class MeasurementMethods{

  static Future<int> addMeasurement(int watchKey, bool baseLine, DateTime atomicTime, DateTime watchTime, double? rate){

    final measurement = Measurement()
      ..watchKey = watchKey
      ..baseLine = baseLine
      ..atomicTime = atomicTime
      ..watchTime = watchTime
      ..rawAccuracy = rate;

    final box = Boxes.getMeasurements();
    return box.add(measurement);
  }

  static Measurement? getLastBaseLineForWatch(Watches watch){
    final List<Measurement> records = Boxes.getMeasurementsForWatch(watch).toList();
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
    final List<Measurement> records = Boxes.getMeasurementsForWatch(watch).toList();
    if(records.isEmpty) return null;
    records.sort((a,b)=> b.atomicTime.compareTo(a.atomicTime));
    return records.first;
  }

  static addRateToRecord(int key, double rate){
    final Box<Measurement> box = Boxes.getMeasurements();
    Measurement? record = box.get(key);
    if(record != null) {
      record.rawAccuracy = rate;
      record.save();
    }
  }

  static Future<bool> deleteRecord(int key) async {
    final Box<Measurement> box = Boxes.getMeasurements();
    if(box.containsKey(key)) {
      box.get(key)!.delete();
      return true;
    }
    return false;
  }

  static clearMeasurementData(){
    final Box<Measurement> box = Boxes.getMeasurements();
    box.clear();
  }

}