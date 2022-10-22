import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

///This class provides helper methods that can be called at app startup to determine whether or not to
///display information to the user, such as notification that the app has updated
class StartupChecksUtil{


  ///runStartupChecks() is the only method which should be called externally.
  ///This will determine what, if any, dialogue should be returned and displayed
  ///on top of the passed context
  static runStartupChecks(BuildContext context) async {
    bool _showWhatsNew = await returnWhatsNew();
    bool _notificationSet = (WristCheckPreferences.getDailyNotificationStatus() == null);
    bool _hasSeenDailyRemindersPrompt = WristCheckPreferences.getHasSeenDailyRemindersPrompt() ?? false;

    //Checks should be run in priority order with only one dialog triggered
    //1. Check if we should show a 'what's new' dialog
      if(_showWhatsNew){
        WristCheckDialogs.getWhatsNewDialog(context);
        StartupChecksUtil.updateLatestVersion();
      }

      //2. If we're not showing what's new, do we have a daily notification set?
    //if not trigger a dialog to help users find it
      if(!_showWhatsNew && !_notificationSet && !_hasSeenDailyRemindersPrompt){
        WristCheckDialogs.getSetupNotificationsDialog(context);
        WristCheckPreferences.setHasSeenDailyRemindersPrompt(true);

        //yes / no / remind me later
      }



  }



  static Future<bool> returnWhatsNew() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version.toString();
    String? latestAppVersion = WristCheckPreferences.getLatestVersion();
    return latestAppVersion == null? true : _isVersionGreaterThan(currentVersion, latestAppVersion);

  }

  static bool _isVersionGreaterThan(String currentVersion, String latestAppVersion){
    List<String> lastV = latestAppVersion.split(".");
    List<String> newV = currentVersion.split(".");
    bool a = false;
    for (var i = 0 ; i <= 2; i++){
      a = int.parse(newV[i]) > int.parse(lastV[i]);
      if(int.parse(newV[i]) != int.parse(lastV[i])) break;
    }
    return a;
  }

  static updateLatestVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version.toString();
    WristCheckPreferences.setLatestVersion(currentVersion);

  }
}