import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'dart:async';

class TimeController extends GetxController{
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

  updateMilitaryTime(mt){
    militaryTime(mt);
  }

  updateTime() {
    Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      var date = DateTime.now();
      currentDateTime(date);
      currentTime(WristCheckFormatter.getTime(date, militaryTime.value));
      currentDate(WristCheckFormatter.getFormattedDateWithDay(date));
    });

  }
}