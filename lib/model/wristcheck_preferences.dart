import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/model/enums/notification_time_options.dart';

class WristCheckPreferences {
  static late SharedPreferences _preferences;

  static const _keyAppPurchased = 'appPurchased';
  static const _keyLatestVersion = 'latestAppVersion';
  static const _keyOpenCount = 'openCount';
  static const _keyWearCount = 'wearCount';
  static const _keyReferenceDate = 'referenceDate';
  static const _keyDailyRemindersPrompt = 'dailyRemindersPrompt';
  //notification preference values
  static const _keyDailyNotificationStatus = 'dailyNotificationStatus';
  static const _keyNotificationTimeOption = 'notificationTimeOption';
  static const _keyNotificationTime = 'notificationTime';



  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Getter and setter for latest app version String
  static Future setLatestVersion(String latestVersion) async =>
      await _preferences.setString(_keyLatestVersion, latestVersion);

  static String? getLatestVersion() => _preferences.getString(_keyLatestVersion);

  //Getter and setter for app open count int
  static int? getOpenCount() => _preferences.getInt(_keyOpenCount);

  static Future setOpenCount(int openCount) async =>
      await _preferences.setInt(_keyOpenCount, openCount);

  //Getter and setter for track wear count
  static int? getWearCount() => _preferences.getInt(_keyWearCount);

  static Future setWearCount(int wearCount) async =>
      await _preferences.setInt(_keyWearCount, wearCount);

  //Getter and setter for daily notification status
  static bool? getDailyNotificationStatus () => _preferences.getBool(_keyDailyNotificationStatus);

  static Future setDailyNotificationStatus(bool notificationStatus) async =>
      await _preferences.setBool(_keyDailyNotificationStatus, notificationStatus);

  //Getter and setter for notification time options
  static NotificationTimeOptions? getNotificationTimeOption() {
    String? value = _preferences.getString(_keyNotificationTimeOption);
    NotificationTimeOptions returnValue;
    switch (value){
      case "NotificationTimeOptions.morning":{
        returnValue = NotificationTimeOptions.morning;
      }
      break;
      case "NotificationTimeOptions.afternoon":{
        returnValue = NotificationTimeOptions.afternoon;
      }
      break;
      case "NotificationTimeOptions.evening":{
        returnValue = NotificationTimeOptions.evening;
      }
      break;
      case "NotificationTimeOptions.custom":{
        returnValue = NotificationTimeOptions.custom;
      }
      break;
      default:{
        returnValue = NotificationTimeOptions.morning;
      }
    }
    return returnValue;
  }

  static Future setNotificationTimeOption(NotificationTimeOptions notifyTime) async {
    await _preferences.setString(_keyNotificationTimeOption, notifyTime.toString());
  }

  //Getter and setter for notification time
  static String? getDailyNotificationTime () => _preferences.getString(_keyNotificationTime);

  static Future setDailyNotificationTime(String notificationTime) async =>
      await _preferences.setString(_keyNotificationTime, notificationTime);

  //Getter and setter for purchased bool
  static bool? getAppPurchasedStatus() => _preferences.getBool(_keyAppPurchased);

  static Future setAppPurchasedStatus(bool appPurchased) async =>
      await _preferences.setBool(_keyAppPurchased, appPurchased);

  //Getter and setter for reference date
  static DateTime? getReferenceDate(){
    var timestamp = _preferences.getInt(_keyReferenceDate);
    return timestamp == null? null : DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static Future setReferenceDate(DateTime refDate) async {
    int timeStamp = refDate.millisecondsSinceEpoch;
    await _preferences.setInt(_keyReferenceDate, timeStamp);
  }

  //Getter and setter for daily reminders prompt
  static bool? getHasSeenDailyRemindersPrompt() => _preferences.getBool(_keyDailyRemindersPrompt);

  static Future setHasSeenDailyRemindersPrompt(bool hasSeenRemindersPrompt) async =>
      await _preferences.setBool(_keyDailyRemindersPrompt, hasSeenRemindersPrompt);



}