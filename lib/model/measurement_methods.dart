import 'package:hive/hive.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';

/*
This class provides static methods to interact with the Measurements database
 */
class MeasurementMethods{

  static Future addMeasurement(int watchKey, bool baseLine, DateTime atomicTime, DateTime watchTime){

    final measurement = Measurement()
      ..watchKey = watchKey
      ..baseLine = baseLine
      ..atomicTime = atomicTime
      ..watchTime = watchTime;

    print("Measurement: ${measurement.watchKey}: ${measurement.baseLine}: ${measurement.atomicTime}: ${measurement.watchTime}; ");
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

  static clearMeasurementData(){
    final Box<Measurement> box = Boxes.getMeasurements();
    box.clear();
  }

}