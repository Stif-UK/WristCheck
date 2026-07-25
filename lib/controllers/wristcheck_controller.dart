import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/config.dart';
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
import 'package:wristcheck/ui/widgets/nba_notifications/donation_notification.dart';
import 'package:wristcheck/ui/widgets/nba_notifications/go_pro_notification.dart';
import 'package:wristcheck/ui/widgets/nba_notifications/wrist_recap_notification.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristCheckController extends GetxController {
  final remoteConfig = FirebaseRemoteConfig.instance;

  //Manage app purchase status
  final isAppPro =  WristCheckConfig.acknowledgePurchase? WristCheckPreferences.getAppPurchasedStatus()!.obs : true.obs;
  //Manage Watchbox view order
  final watchboxOrder = WristCheckPreferences.getWatchOrder().obs;
  //Manage Watchbox View Type
  final watchBoxView = WristCheckPreferences.getWatchBoxView().obs;
  //Manage visibility of last worn date and wear count
  final showLastWornDate = WristCheckPreferences.getShowLastWornDatePref().obs;
  final showWearCount = WristCheckPreferences.getShowWearCountPref().obs;
  //Manage locale
  final locale = WristCheckFormatter.getLocaleEnum(WristCheckPreferences.getLocale()!).obs;
  //homepage
  final homePageIndex = WristCheckPreferences.getHomePageIndex().obs;
  //WristRecap notification
  final lastRecapNotificationDismissed = WristCheckPreferences.getLastRecapNotification().obs;
  final showRecapNotification = false.obs;
  //Donation Prompt Notification
  final daysSinceLastDonation = 0.obs;
  final showDonationPrompt = false.obs;
  final donationShowMore = false.obs;
  final lastDonationNotificationDismissed = (WristCheckPreferences.getLastDonationNotificationDismissed()).obs;
  //Go Pro notification
  final showGoProNotification = false.obs;
  final lastGoProNotificationDismissed = (WristCheckPreferences.getLastGoProNotificationDismissed()).obs;
  final goProShowMore = false.obs;
  //Merch Store
  final showMerchStore = false.obs;
  final merchStoreUrl = "".obs;

  //Track the currently active notification to display in the header
  final activeNBA = Rxn<Widget>();

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

  /**
   * checkForNotifications runs each of the checkers for homepage notifications
   * setting the boolean values to true if a notification is available.
   */
  checkForNotifications() async {
    //Only proceed if we haven't already shown a notification today
    DateTime now = DateTime.now();
    DateTime lastShown = WristCheckPreferences.getLastNBADate();

    // Check if it's a new day (ignoring time)
    bool isNewDay = now.year != lastShown.year || now.month != lastShown.month || now.day != lastShown.day;

    if (!isNewDay && activeNBA.value == null) {
      // If it's not a new day and nothing is showing, don't re-trigger
      return;
    }

    // Run underlying checks to populate showRecapNotification, showDonationPrompt, showGoProNotification
    await checkForRecapNotification();
    await checkForDonationNotification();
    await checkForGoProNotification();

    // If nothing is currently active, and we are allowed to show something new today
    if (activeNBA.value == null && isNewDay) {
      if (showRecapNotification.value) {
        activeNBA(WristRecapNotification());
        await WristCheckPreferences.setLastNBADate(now);
      } else if (!isAppPro.value && showGoProNotification.value) {
        activeNBA(GoProNotification());
        await WristCheckPreferences.setLastNBADate(now);
      } else if (isAppPro.value && showDonationPrompt.value) {
        activeNBA(DonationNotification());
        await WristCheckPreferences.setLastNBADate(now);
      }
    }
  }

  checkForDonationNotification() async {
    //If the app is not pro, exit immediately
    if(!isAppPro.value) {
      showDonationPrompt(false);
      return;
    } 
    
    DateTime now = DateTime.now();
    //Check greater than 365 days since last donation
    String purchaseDateStr = await PurchaseApi.getAppPurchaseDate(false);
    if (purchaseDateStr == "Not Found") {
      showDonationPrompt(false);
      return;
    }
    
    DateTime lastPurchaseDate = DateTime.parse(purchaseDateStr);
    int daysSinceLastPurchase = now.difference(lastPurchaseDate).inDays;
    daysSinceLastDonation(daysSinceLastPurchase);
    
    bool purchasedOver365 = daysSinceLastPurchase > 365;
    if(purchasedOver365){
      //If yes, check if the last notification dismissed was over 365 days ago
      DateTime lastNotificationDismissed = WristCheckPreferences.getLastDonationNotificationDismissed() ?? DateTime(2020, 1, 1);
      if(now.difference(lastNotificationDismissed).inDays > 365){
        showDonationPrompt(true);
      } else {
        showDonationPrompt(false);
      }
    } else {
      showDonationPrompt(false);
    }
  }

  dismissDonationNotification(DateTime lastDonationNotification) async {
    showDonationPrompt(false);
    lastDonationNotificationDismissed(lastDonationNotification);
    await WristCheckPreferences.setLastDonationNotificationDismissed(lastDonationNotification);
    Future.microtask(() => activeNBA(SizedBox.shrink()));
  }

  checkForRecapNotification() async {
    var showNotification = false;
    //First check if a notification has been dismissed already this month
    final DateTime now = DateTime.now();
    //normalise each to the start of the month
    final DateTime lastNotificationMonth = DateTime(lastRecapNotificationDismissed.value.year, lastRecapNotificationDismissed.value.month, 1);
    final currentMonthStart = DateTime(now.year, now.month, 1);

    // If the given month is before the current month, it's previous or older
    if (lastNotificationMonth.isBefore(currentMonthStart)){
      //If no notification shown this month, then check if there were any wears in the previous month

      final DateTime lastMonth = DateTime(now.year, now.month-1);
      final watchList = Boxes.getAllNonArchivedWatches();

      outerLoop:
      for (var watch in watchList) {
        for (var wearDate in watch.wearList) {
          if (wearDate.month == lastMonth.month && wearDate.year == lastMonth.year) {
            showNotification = true;
            break outerLoop;
          }
        }
      }
    }
    showRecapNotification(showNotification);
  }

  //Set last recap notification
  dismissRecapNotification(DateTime lastRecap) async {
    showRecapNotification(false);
    lastRecapNotificationDismissed(lastRecap);
    await WristCheckPreferences.setLastRecapNotification(lastRecap);
    Future.microtask(() => activeNBA(SizedBox.shrink()));
  }

  checkForGoProNotification() async {
    //This notification relies on wearCount and openCount - both will be unique to the device
    //unless an OS level data transfer has been used, so may not reflect o.g. totals.
    int openCount = WristCheckPreferences.getOpenCount() ?? 0;
    int wearCount = WristCheckPreferences.getWearCount() ?? 0;
    bool isPro = isAppPro.value;

    if(!isPro && openCount > 0 && wearCount > 3 ){
      DateTime lastPromptDismissed = WristCheckPreferences.getLastGoProNotificationDismissed();
      DateTime now = DateTime.now();
      if(now.difference(lastPromptDismissed).inDays > 90) {
        showGoProNotification(true);
      } else {
        showGoProNotification(false);
      }
    } else {
      showGoProNotification(false);
    }
  }

  //Dismiss notification and capture the date
  dismissGoProNotification(DateTime lastPrompt) async {
    showGoProNotification(false);
    lastGoProNotificationDismissed(lastPrompt);
    await WristCheckPreferences.setLastGoProNotificationDismissed(lastPrompt);
    Future.microtask(() => activeNBA(SizedBox.shrink()));
  }


  //Set the watch view
  updateWatchBoxView(WatchBoxView newValue) async {
    await WristCheckPreferences.setWatchBoxView(newValue);
    watchBoxView(newValue);
  }

  //Update visibility of last worn date
  updateShowLastWornDate(bool showDate) async {
    await WristCheckPreferences.setShowLastWornDatePref(showDate);
    showLastWornDate(showDate);
  }

  //Update visibility of wear count
  updateShowWearCount(bool showWears) async {
    await WristCheckPreferences.setShowWearCountPref(showWears);
    showWearCount(showWears);
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

  toggleDonationShowMore(){
    donationShowMore(!donationShowMore.value);
  }

  toggleGoProShowMore(){
    goProShowMore(!goProShowMore.value);
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

  refreshShowMerchStore() async {
    bool showMerch = await remoteConfig.getBool("show_merch_link");
    String merchUrl = await remoteConfig.getString("merch_url");
    showMerchStore(showMerch);
    merchStoreUrl(merchUrl);
  }

}
