import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class AccuracyController extends GetxController{
  final watchDateTime = DateTime.now().obs;
  final baseLine = true.obs;
  final militaryTime = WristCheckPreferences.getMilitaryTime().obs;


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
}