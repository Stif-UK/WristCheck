import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'dart:async';

class TimeController extends GetxController{
  final lastBeep = 56.obs;
  final currentDate = "".obs;
  final currentTime = "".obs;
  final currentDateTime = DateTime.now().obs;
  final enableBeep = WristCheckPreferences.getEnableBeep().obs;
  final militaryTime = WristCheckPreferences.getMilitaryTime().obs;

  onInit(){
    updateTime();
  }

  updateBeepSetting(beep) async {
    await WristCheckPreferences.setEnableBeep(beep);
    enableBeep(beep);

  }

  updateLastBeep(sec){
    lastBeep(sec);
  }

  updateMilitaryTime(mt) async {
    await WristCheckPreferences.setMilitaryTime(mt);
    militaryTime(mt);
  }

  updateTime() {
    int lastbeep;
    Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      var date = DateTime.now();
      triggerBeep(date.second);
      currentDateTime(date);
      currentTime(WristCheckFormatter.getTime(date, militaryTime.value));
      currentDate(WristCheckFormatter.getFormattedDateWithDay(date));
    });

  }

  triggerBeep(int current){
    var triggerList = [57, 58, 59, 00];
    if(triggerList.contains(current)) {
      if (current != lastBeep.value && enableBeep.value) {
        current == 00? print("BEEP!!"): print("beep!");
      };
      updateLastBeep(current);
    }
  }
}