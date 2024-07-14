import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';


class TimeController extends GetxController{
  final isTimerActive = true.obs;
  final lastBeep = 56.obs;
  final currentDate = "".obs;
  final currentTime = "".obs;
  final currentDateTime = DateTime.now().obs;
  final enableBeep = WristCheckPreferences.getEnableBeep().obs;
  final militaryTime = WristCheckPreferences.getMilitaryTime().obs;


  @override
  void dispose() {
    isTimerActive(false);
    super.dispose();
  }

  updateIsTimerActive(bool isActive){
    isTimerActive(isActive);
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


}