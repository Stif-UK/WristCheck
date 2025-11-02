import 'package:get/get.dart';
import 'package:wristcheck/model/enums/rate_unit.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class AccuracyController extends GetxController{
  final watchDateTime = DateTime.now().obs;
  final baseLine = false.obs;
  final militaryTime = WristCheckPreferences.getMilitaryTime().obs;
  final data = <Measurement>[].obs;
  final lastBaseline = Rxn<Measurement>();
  final scale = RateUnit.day.obs;
  final syncTimestamp = Rxn<DateTime>();
  final dataLastFirst = true.obs;

  updateWatchDateTime(DateTime time){
    watchDateTime(time);
  }

  toggleBaseline(){
    baseLine(!baseLine.value);
  }

  updateBaseline(bool newValue){
    baseLine(newValue);
  }

  addAMinute(){
    DateTime newTime = watchDateTime.value.add(Duration(minutes: 1));
    watchDateTime(newTime);
  }

  subtractAMinute(){
    DateTime newTime = watchDateTime.value.subtract(Duration(minutes: 1));
    watchDateTime(newTime);
  }

  updateMilitaryTime(bool mt) async {
    await WristCheckPreferences.setMilitaryTime(mt);
    militaryTime(mt);
  }

  updateData(List<Measurement> newData){
    if(dataLastFirst.value) newData = newData.reversed.toList();
    data(newData);
  }

  updateLastBaseline(Measurement? record){
    lastBaseline(record);
  }

  updateScale(RateUnit unit){
    scale(unit);
  }

  updateSyncTimestamp(DateTime? synced){
    syncTimestamp(synced);
  }

  toggleDataOrder(){
    dataLastFirst(!dataLastFirst.value);
  }
}