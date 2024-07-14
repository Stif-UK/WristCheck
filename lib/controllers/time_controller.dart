import 'package:get/get.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class TimeController extends GetxController{
  final isTimerActive = true.obs;
  final lastBeep = 56.obs;
  final currentDate = "".obs;
  final currentTime = "".obs;
  final currentDateTime = DateTime.now().obs;
  final enableBeep = WristCheckPreferences.getEnableBeep().obs;
  final militaryTime = WristCheckPreferences.getMilitaryTime().obs;
  final lastSyncTime = "".obs;
  final timeSynced = false.obs;
  final syncFailed = false.obs;
  final deviation = Duration(milliseconds: 0).obs;


  @override
  void dispose() {
    isTimerActive(false);
    super.dispose();
  }

  updateSyncFailed(bool sync){
    syncFailed(sync);
  }

  updateDeviation(Duration diff){
    deviation(diff);
  }

  updateTimeSynced(bool synced){
    timeSynced(synced);
  }

  updateLastSyncTime(DateTime time){
    lastSyncTime(WristCheckFormatter.getFormattedDateAndTime(time));
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