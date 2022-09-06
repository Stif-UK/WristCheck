import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class WristCheckPreferences {
  static late SharedPreferences _preferences;

  static const _keyLatestVersion = 'latestAppVersion';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLatestVersion(String latestVersion) async =>
      await _preferences.setString(_keyLatestVersion, latestVersion);

  static String? getLatestVersion() => _preferences.getString(_keyLatestVersion);

}