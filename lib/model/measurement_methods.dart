import 'package:hive/hive.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/measurement.dart';

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

  static clearMeasurementData(){
    final Box<Measurement> box = Boxes.getMeasurements();
    box.clear();
  }

}