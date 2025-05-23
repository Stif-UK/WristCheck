import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/errors/error_handling.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_filter_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_filter_enum.dart';
import 'package:wristcheck/model/enums/watch_year_chart_enum.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristCheckController extends GetxController {

  //Manage app purchase status
  final isAppPro =  WristCheckPreferences.getAppPurchasedStatus()!.obs;
  //Manage Watchbox view order
  final watchboxOrder = WristCheckPreferences.getWatchOrder().obs;
  //Manage Watchbox View Type
  final watchBoxView = WristCheckPreferences.getWatchBoxView().obs;
  //Manage locale
  final locale = WristCheckFormatter.getLocaleEnum(WristCheckPreferences.getLocale()!).obs;
  //homepage
  final homePageIndex = WristCheckPreferences.getHomePageIndex().obs;

  updateHomePageIndex(int index){
    homePageIndex(index);
  }

  //Calling updateAppPurchaseStatus triggers a call to the Purchases package which will update the app status
  //based on whether the user holds the WristCheck Pro entitlement.
  updateAppPurchaseStatus() async {
    bool? isPro = false;
    try {
      print("Trying to check purchase status");
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      isPro = customerInfo.entitlements.all["WristCheck Pro"]?.isActive;
      print("Entitlement checked value: $isPro");
    } on PlatformException catch (e) {
      WristCheckErrorHandling.surfacePlatformError(e);
    }
    isAppPro(isPro);
    await WristCheckPreferences.setAppPurchasedStatus(isPro!);
  }

  revertPurchaseStatus() async {
    isAppPro(false);
    await WristCheckPreferences.setAppPurchasedStatus(false);
  }

  //Set the watch order
  updateWatchOrder(WatchOrder boxOrder) async {
    await WristCheckPreferences.setWatchBoxOrder(boxOrder);
    watchboxOrder(boxOrder);
    update(); //Not sure if this line makes a difference...
  }

  //Set the watch view
  updateWatchBoxView() async {
    WatchBoxView newValue;
    watchBoxView.value == WatchBoxView.list?
    newValue = WatchBoxView.grid: newValue = WatchBoxView.list;
    await WristCheckPreferences.setWatchBoxView(newValue);
    watchBoxView(newValue);
    update(); //Not sure if this line makes a difference...
  }

  //Set the locale
  updateLocale(LocationEnum location) async {
    await WristCheckPreferences.setLocale(WristCheckFormatter.getLocaleString(location));
    locale(location);
  }

  //Status of navigation drawer
  final isDrawerOpen = false.obs;

  updateIsDrawerOpen(bool isOpen) {
    isDrawerOpen(isOpen);
  }

  //Track the currently selected calendar date
  final selectedDate = Rxn<DateTime>();

  updateSelectedDate(DateTime? date){
    //allow a null value to be passed
    if(date == null){
      selectedDate(selectedDate.value = null);
    }
    selectedDate(date);
  }

  //Track the current watch selection - this should be instantiated when used, and nulled when not in use.
  final selectedWatch = Rxn<Watches>();

  updateSelectedWatch(Watches? watch){
    //allow a null value to be passed
    if(watch == null){
      selectedWatch(selectedWatch.value = null);
    }
    selectedWatch(watch);
  }

  //Track if a null watch error should show
  final nullWatchMemo = false.obs;

  updateNullWatchMemo(bool nullWatch){
    nullWatchMemo(nullWatch);
  }

  //Determine if the calendar or service schedule should be displayed
  final calendarOrService = true.obs;

  updateCalendarOrService(bool cal){
    calendarOrService(cal);
  }

  //Track last opened servicing/warranty tab
  final lastServicingTabIndex = 0.obs;

  updateLastServicingTabIndex(int index){
    lastServicingTabIndex(index);
  }

  //Track Month Chart preference & filters
  final monthChartPreference = WristCheckPreferences.getDefaultMonthChartTypeV2().obs;
  final monthChartFilter = WatchMonthChartFilterEnum.all.obs;

  updateMonthChartPreference(WatchMonthChartEnum type) async {
    await WristCheckPreferences.setDefaultMonthChartTypeV2(type);
    monthChartPreference(type);
  }

  updateMonthChartFilter(WatchMonthChartFilterEnum newFilter){
    monthChartFilter(newFilter);
  }

  //Track Day Chart preference & filters
  final dayChartPreference = WristCheckPreferences.getDefaultDayChartTypeV2().obs;
  final dayChartFilter = WatchDayChartFilterEnum.all.obs;

  updateDayChartPreference(WatchDayChartEnum type) async {
    await WristCheckPreferences.setDefaultDayChartTypeV2(type);
    dayChartPreference(type);
  }

  updateDayChartFilter(WatchDayChartFilterEnum newFilter){
    dayChartFilter(newFilter);
  }

  //Track Year Chart preference
  final yearChartPreference = WatchYearChartEnum.bar.obs;

  updateYearChartPreference(WatchYearChartEnum type) {
    yearChartPreference(type);
  }

  //Fields for watch calendar view
  final dateAscenting = true.obs;
  final showDateList = false.obs;

  updateDateAscending(bool asc){
    dateAscenting(asc);
  }

  updateShowCalendar(bool showCal){
    showDateList(showCal);
  }

  //Fields to manage datelist length
final dateListLength = 0.obs;

  updateDateListLength(int length){
    dateListLength(length);
  }

  //First Day of the week preference
final firstDayOfWeek = WristCheckPreferences.getFirstDayOfWeek().obs;

  updateFirstDayOfWeek(int day) async {
    if(day > 0 && day < 8){
      await WristCheckPreferences.setFirstDayofWeek(day);
      firstDayOfWeek(day);
    }
  }

  //Light/Dark theme preference
final lightThemeChoice = WristCheckPreferences.getThemePreference().obs;

  updateLightThemeChoice(ThemeMode theme) async {
    await WristCheckPreferences.setThemePreference(theme);
    lightThemeChoice(theme);
  }

  //WR Unit choice
final waterResistanceUnit = WristCheckPreferences.getWaterResistancePreference().obs;

  updateWaterResistanceUnit(WRUnitsEnum units) async {
    await WristCheckPreferences.setWaterResistancePreference(units);
    waterResistanceUnit(units);
  }

}
