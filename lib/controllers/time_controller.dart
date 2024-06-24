import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'dart:async';

class TimeController extends GetxController{
  final currentDate = "".obs;
  final currentTime = "".obs;
  final currentDateTime = DateTime.now().obs;

  onInit(){
    updateTime();
  }

  updateTime() {
    Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      var date = DateTime.now();
      currentDateTime(date);
      currentTime(WristCheckFormatter.getTime(date));
      currentDate(WristCheckFormatter.getFormattedDateWithDay(date));
    });

  }
}