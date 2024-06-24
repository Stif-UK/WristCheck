import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'dart:async';

class TimeController extends GetxController{
  final lastBeep = 56.obs;
  final currentDate = "".obs;
  final currentTime = "".obs;
  final currentDateTime = DateTime.now().obs;
  final enableBeep = false.obs;
  final militaryTime = true.obs;

  onInit(){
    updateTime();
  }

  updateBeepSetting(beep){
    enableBeep(beep);
  }

  updateLastBeep(sec){
    lastBeep(sec);
  }

  updateMilitaryTime(mt){
    militaryTime(mt);
  }

  updateTime() {
    int lastbeep;
    Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      var date = DateTime.now();
      switch(date.second){
        case 57:
          triggerBeep(57);
          break;
        case 58:
          triggerBeep(58);
          break;
        case 59:
          triggerBeep(59);
          break;
      }
      currentDateTime(date);
      currentTime(WristCheckFormatter.getTime(date, militaryTime.value));
      currentDate(WristCheckFormatter.getFormattedDateWithDay(date));
    });

  }

  triggerBeep(int current){
    if(current != lastBeep.value)
      {
        print("beep!");
      };
    updateLastBeep(current);
  }
}