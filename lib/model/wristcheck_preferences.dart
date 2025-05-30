import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/enums/notification_time_options.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';

class WristCheckPreferences {
  static late SharedPreferences _preferences;

  static const _keyAppPurchased = 'appPurchased';
  static const _keyLatestVersion = 'latestAppVersion';
  static const _keyOpenCount = 'openCount';
  static const _keyWearCount = 'wearCount';
  static const _keyReferenceDate = 'referenceDate';
  static const _keyDailyRemindersPrompt = 'dailyRemindersPrompt';
  static const _keyLastSalePromptDismissed = 'lastSalePromptDismissed';
  static const _keyHomePageIndex = 'homePageIndex';
  //charts
  static const _keyWearChartOptions = 'wearChartOptions';
  static const _keyWearChartOrder = 'wearChartOrder';
  static const _keyDefaultChartType = 'defaultChartType';
  static const _keyDefaultMonthChartType = 'defaultMonthChartType'; //TODO: Remove in future release - last used in v1.10.3
  static const _keyDefaultMonthChartTypeV2 = 'defaultMonthChartTypev2';
  static const _keyDefaultDayChartType = 'defaultDayChartType'; //TODO: Remove in future release - last used in v1.10.3
  static const _keyDefaultDayChartTypeV2 = 'defaultDayChartTypeV2';
  static const _keyShowCPWvalue = 'costPerWearValue';

  //notification preference values
  static const _keyDailyNotificationStatus = 'dailyNotificationStatus';
  static const _keySecondNotificationStatus = 'secondNotificationStatus';
  static const _keyNotificationTimeOption = 'notificationTimeOption';
  static const _keyNotificationTime = 'notificationTime';
  static const _keySecondNotificationTime = 'secondNotificationTime';
  //Entitlement check
  static const _keyLastEntitlementCheck = 'lastEntitlementCheck';
  //watchbox order & view
  static const _keyWatchboxOrder = 'watchBoxOrder';
  static const _keyWatchBoxView = 'watchBoxView';
  //Locale
  static const _keyLocale = 'locale';
  //First Use Demo & other first uses
  static const _keyFirstDemo = 'firstUseDemo';
  static const _keyHasSeenWatchCharts = 'seenWatchCharts';
  //Dismissable pop-ups
  static const _keyShowSoldDialog = 'showSoldDialog';
  static const _keyShowPreOrderDialog = 'showPreOrderDialog';

  //TimeSettingFeatures
  static const _keyEnableBeep = 'enableBeep';
  static const _keyMilitaryTime = 'militaryTime';

  //Calendar - first day of week
  static const _keyFirstDayOfWeek = 'firstDayOfWeek';

  //Light & Dark theme
  static const _keyThemePreference = 'themePreference';

  //WR Units
  static const _keyWRUnitsPreference = 'WRUnits';




  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Getter and setter for show sold dialog
  static Future setShowSoldDialog(bool showDialog) async =>
    await _preferences.setBool(_keyShowSoldDialog, showDialog);

  static bool getShowSoldDialog() => _preferences.getBool(_keyShowSoldDialog) ?? true;

  //Getter and setter for show pre-order dialog
  static Future setShowPreOrderDialog(bool showDialog) async =>
      await _preferences.setBool(_keyShowPreOrderDialog, showDialog);

  static bool getShowPreOrderDialog() => _preferences.getBool(_keyShowPreOrderDialog) ?? true;

  //Getter and setter for first use demo
  static Future setHasSeenDemo(bool hasSeenDemo) async =>
      await _preferences.setBool(_keyFirstDemo, hasSeenDemo);

  static bool? getHasSeenDemo() => _preferences.getBool(_keyFirstDemo);

  //Getter and setter for first view of watch charts
  static bool? getHasSeenWatchCharts() => _preferences.getBool(_keyHasSeenWatchCharts);

  static Future setHasSeenWatchCharts(bool hasSeenWatchCharts) async =>
      await _preferences.setBool(_keyHasSeenWatchCharts, hasSeenWatchCharts);

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

  //Getter and setter for second daily notification status
  static bool? getSecondNotificationStatus () => _preferences.getBool(_keySecondNotificationStatus);

  static Future setSecondNotificationStatus(bool notificationStatus) async =>
      await _preferences.setBool(_keySecondNotificationStatus, notificationStatus);

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

  //Getter and setter for second notification time
  static String? getSecondNotificationTime () => _preferences.getString(_keySecondNotificationTime);

  static Future setSecondNotificationTime(String notificationTime) async =>
      await _preferences.setString(_keySecondNotificationTime, notificationTime);

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

  //Getter and setter for wear chart options
  static WearChartOptions getWearChartOptions() {
    String? value = _preferences.getString(_keyWearChartOptions);
    WearChartOptions returnValue;
    switch (value){
      case "WearChartOptions.all":{
        returnValue = WearChartOptions.all;
      }
      break;
      case "WearChartOptions.thisYear":{
        returnValue = WearChartOptions.thisYear;
      }
      break;
      case "WearChartOptions.lastYear":{
        returnValue = WearChartOptions.lastYear;
      }
      break;
      case "WearChartOptions.thisMonth":{
        returnValue = WearChartOptions.thisMonth;
      }
      break;
      case "WearChartOptions.lastMonth":{
        returnValue = WearChartOptions.lastMonth;
      }
      break;
      case "WearChartOptions.last30days":{
        returnValue = WearChartOptions.last30days;
      }
      break;
      case "WearChartOptions.last90days":{
        returnValue = WearChartOptions.last90days;
      }
      break;
      case "WearChartOptions.lastPurchase":{
        returnValue = WearChartOptions.lastPurchase;
      }
      break;
      case "WearChartOptions.manual":{
        returnValue = WearChartOptions.manual;
      }
      break;
      default:{
        returnValue = WearChartOptions.all;
      }
    }
    return returnValue;
  }

  static Future setWearChartOptions(WearChartOptions wearChartOption) async {
    await _preferences.setString(_keyWearChartOptions, wearChartOption.toString());
  }

  //Getter and setter for wear chart options
  static ChartOrdering? getWearChartOrder() {
    String? value = _preferences.getString(_keyWearChartOrder);
    ChartOrdering returnValue;
    switch (value){
      case "ChartOrdering.watchbox":{
        returnValue = ChartOrdering.watchbox;
      }
      break;
      case "ChartOrdering.ascending":{
        returnValue = ChartOrdering.ascending;
      }
      break;
      case "ChartOrdering.descending":{
        returnValue = ChartOrdering.descending;
      }
      break;
      default:{
        returnValue = ChartOrdering.watchbox;
      }
    }
    return returnValue;
  }

  static Future setWearChartOrder(ChartOrdering chartOrder) async {
    await _preferences.setString(_keyWearChartOrder, chartOrder.toString());
  }

  //Getter and setter for default chart type
  //A value of true represents a user preferring bar charts over pie charts
  static DefaultChartType? getDefaultChartType()  {
    if(_preferences.getBool(_keyDefaultChartType) == null){
      return DefaultChartType.bar;
    } else{
      bool _prefersBarCharts =  _preferences.getBool(_keyDefaultChartType)!;
      return _prefersBarCharts? DefaultChartType.bar : DefaultChartType.pie;
    }
  }

  static Future setDefaultChartType(DefaultChartType preferredType) async {
    bool _prefersBarCharts;
    preferredType == DefaultChartType.bar ? _prefersBarCharts = true : _prefersBarCharts = false;
    await _preferences.setBool(_keyDefaultChartType, _prefersBarCharts);
  }

  //Month charts: DEPRECATED //TODO: Remove in future release - last valid version v1.10.3 & replaced by v2
  static DefaultChartType? getDefaultMonthChartType()  {
    if(_preferences.getBool(_keyDefaultMonthChartType) == null){
      return DefaultChartType.bar;
    } else{
      bool _prefersBarCharts =  _preferences.getBool(_keyDefaultMonthChartType)!;
      return _prefersBarCharts? DefaultChartType.bar : DefaultChartType.pie;
    }
  }

  static Future setDefaultMonthChartType(DefaultChartType preferredType) async {
    bool _prefersBarCharts;
    preferredType == DefaultChartType.bar ? _prefersBarCharts = true : _prefersBarCharts = false;
    await _preferences.setBool(_keyDefaultMonthChartType, _prefersBarCharts);
  }

  //Month charts v2
  static WatchMonthChartEnum getDefaultMonthChartTypeV2()  {
    if(_preferences.getString(_keyDefaultMonthChartTypeV2) == null){
      return WatchMonthChartEnum.grouped;
    } else{
      String value = _preferences.getString(_keyDefaultMonthChartType)!;
      WatchMonthChartEnum returnValue;

      switch(value){
        case "WatchMonthChartEnum.bar":{
            returnValue = WatchMonthChartEnum.bar;
            break;
          }
          case "WatchMonthChartEnum.grouped":{
              returnValue = WatchMonthChartEnum.grouped;
              break;
            }
        case "WatchMonthChartEnum.pie":{
          returnValue = WatchMonthChartEnum.pie;
          break;
        }
        case "WatchMonthChartEnum.line":{
          returnValue = WatchMonthChartEnum.line;
          break;
        }
        default:
          returnValue = WatchMonthChartEnum.bar;
      }


      return returnValue;
    }
  }

  static Future setDefaultMonthChartTypeV2(WatchMonthChartEnum preferredType) async {
    await _preferences.setString(_keyDefaultMonthChartType, preferredType.name);
  }

  //Day charts - DEPRECATED TODO: Remove in next release, last relevant in v1.10.3
  static DefaultChartType? getDefaultDayChartType()  {
    if(_preferences.getBool(_keyDefaultDayChartType) == null){
      return DefaultChartType.bar;
    } else{
      bool _prefersBarCharts =  _preferences.getBool(_keyDefaultDayChartType)!;
      return _prefersBarCharts? DefaultChartType.bar : DefaultChartType.pie;
    }
  }

  static Future setDefaultDayChartType(DefaultChartType preferredType) async {
    bool _prefersBarCharts;
    preferredType == DefaultChartType.bar ? _prefersBarCharts = true : _prefersBarCharts = false;
    await _preferences.setBool(_keyDefaultDayChartType, _prefersBarCharts);
  }

  //Day Charts v2

  static WatchDayChartEnum getDefaultDayChartTypeV2()  {
    if(_preferences.getString(_keyDefaultDayChartTypeV2) == null){
      return WatchDayChartEnum.bar;
    } else{
      String value = _preferences.getString(_keyDefaultDayChartTypeV2)!;
      WatchDayChartEnum returnValue;

      switch(value){
        case "WatchDayChartEnum.bar":
          returnValue = WatchDayChartEnum.bar;
          break;
        case "WatchDayChartEnum.pie":
          returnValue = WatchDayChartEnum.pie;
          break;
        case "WatchDayChartEnum.line":
          returnValue = WatchDayChartEnum.line;
          break;
        case "WatchDayChartEnum.grouped":
          returnValue = WatchDayChartEnum.grouped;
          break;
        default:
          returnValue = WatchDayChartEnum.bar;
      }


      return returnValue;
    }
  }

  static Future setDefaultDayChartTypeV2(WatchDayChartEnum preferredType) async {
    await _preferences.setString(_keyDefaultDayChartTypeV2, preferredType.name);
  }


  //Getter and Setter for last entitlement check date
  static DateTime? getLastEntitlementCheckDate() {
    String? returnString = _preferences.getString(_keyLastEntitlementCheck);
    return returnString == null? null : DateTime.parse(returnString);
  }

  static Future setLastEntitlementCheckDate(DateTime lastEntitlementCheck) async{
    await _preferences.setString(_keyLastEntitlementCheck, lastEntitlementCheck.toString());
  }

  //Getter and Setter for watchbox order
  //Getter and setter for wear chart options
  static WatchOrder? getWatchOrder() {
    String? value = _preferences.getString(_keyWatchboxOrder);
    WatchOrder returnValue;
    switch (value){
      case "WatchOrder.watchbox":{
        returnValue = WatchOrder.watchbox;
      }
      break;
      case "WatchOrder.reverse":{
        returnValue = WatchOrder.reverse;
      }
      break;
      case "WatchOrder.alpha_asc":{
        returnValue = WatchOrder.alpha_asc;
      }
      break;
      case "WatchOrder.alpha_desc":{
        returnValue = WatchOrder.alpha_desc;
      }
      break;
      case "WatchOrder.lastworn":{
        returnValue = WatchOrder.lastworn;
      }
      break;
      case "WatchOrder.mostworn":{
        returnValue = WatchOrder.mostworn;
      }
      break;
      default:{
        returnValue = WatchOrder.watchbox;
      }
    }
    return returnValue;
  }

  static Future setWatchBoxOrder(WatchOrder watchOrder) async {
    await _preferences.setString(_keyWatchboxOrder, watchOrder.toString());
  }

  //Getter and Setter for watchbox view option
  static WatchBoxView getWatchBoxView() {
    String? value = _preferences.getString(_keyWatchBoxView);
    WatchBoxView returnValue;
    switch (value){
      case "WatchBoxView.list":{
        returnValue = WatchBoxView.list;
      }
      break;
      case "WatchBoxView.grid":{
        returnValue = WatchBoxView.grid;
      }
      break;
      default:{
        returnValue = WatchBoxView.list;
      }
    }
    return returnValue;
  }

  static Future setWatchBoxView(WatchBoxView watchBoxView) async {
    await _preferences.setString(_keyWatchBoxView, watchBoxView.toString());
  }

  //Getter and Setter for locale preference
  static Future setLocale(String locale) async =>
      await _preferences.setString(_keyLocale, locale);

  static String? getLocale() => _preferences.getString(_keyLocale);

  //Getter and Setter for last sale prompt acknowledged
  static DateTime? getLastSalePrompt() {
    String? returnString = _preferences.getString(_keyLastSalePromptDismissed);
    return returnString == null? null : DateTime.parse(returnString);
  }

  static Future setLastSalePrompt(DateTime lastSalePrompt) async{
    await _preferences.setString(_keyLastSalePromptDismissed, lastSalePrompt.toString());
  }

  //Getter and Setter for time beep preference
  static Future setEnableBeep(bool beep) async =>
      await _preferences.setBool(_keyEnableBeep, beep);

  static bool getEnableBeep() => _preferences.getBool(_keyEnableBeep) ?? false;

  //Getter and Setter for 24 hour time preference
  static Future setMilitaryTime(bool milTime) async =>
      await _preferences.setBool(_keyEnableBeep, milTime);

  static bool getMilitaryTime() => _preferences.getBool(_keyMilitaryTime) ?? true;

  //Getter and Setter for home page index
  static int getHomePageIndex() => _preferences.getInt(_keyHomePageIndex) ?? 0;

  static Future setHomePageIndex(int index) async {
    //ensure value is in the range 0-3 to prevent out of bounds issue
    if(index <0 || index > 3){
      index = 0;
    }
    return await _preferences.setInt(_keyHomePageIndex, index);
  }

  //Getter and Setter for first day of week
  static int getFirstDayOfWeek() => _preferences.getInt(_keyFirstDayOfWeek) ?? 7;

  static Future setFirstDayofWeek(int day) async {
    //ensure the value is between 1 & 7
    if(day < 1 || day > 7){
      day = 7;
    }
    return await _preferences.setInt(_keyFirstDayOfWeek, day);
  }

  //Getter and setter for light/dark theme preference
  static ThemeMode getThemePreference() {
    String? value = _preferences.getString(_keyThemePreference);
    ThemeMode returnValue;
    switch (value){
      case "ThemeMode.light":{
        returnValue = ThemeMode.light;
      }
      break;
      case "ThemeMode.dark":{
        returnValue = ThemeMode.dark;
      }
      break;
      case "ThemeMode.system":{
        returnValue = ThemeMode.system;
      }
      break;
      default:{
        returnValue = ThemeMode.system;
      }
    }
    return returnValue;
  }

  static Future setThemePreference(ThemeMode preferredTheme) async {
    await _preferences.setString(_keyThemePreference, preferredTheme.toString());
  }

  static WRUnitsEnum getWaterResistancePreference(){
    String? value = _preferences.getString(_keyWRUnitsPreference);
    WRUnitsEnum returnValue;
    switch (value){
      case "WRUnitsEnum.metres":{
        returnValue = WRUnitsEnum.metres;
      }
      break;
      case "WRUnitsEnum.feet":{
        returnValue = WRUnitsEnum.feet;
      }
      break;
      default:{
        returnValue = WRUnitsEnum.metres;
      }
    }
    return returnValue;
  }

  static Future setWaterResistancePreference(WRUnitsEnum preferredUnits) async {
    await _preferences.setString(_keyWRUnitsPreference, preferredUnits.toString());
  }

  //Getter and Setter for cost per wear chart value preference
  static Future setCostPerWearValuePref(bool cpwValue) async =>
      await _preferences.setBool(_keyShowCPWvalue, cpwValue);

  static bool getCostPerWearValuePref() => _preferences.getBool(_keyShowCPWvalue) ?? true;

}