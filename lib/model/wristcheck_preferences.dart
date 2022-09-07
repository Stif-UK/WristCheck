import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class WristCheckPreferences {
  static late SharedPreferences _preferences;

  static const _keyLatestVersion = 'latestAppVersion';
  static const _keyOpenCount = 'openCount';

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


}