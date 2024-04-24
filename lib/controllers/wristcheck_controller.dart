import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/errors/error_handling.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/watchbox_view.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristCheckController extends GetxController {

  //Manage app purchase status
  final isAppPro = WristCheckPreferences.getAppPurchasedStatus()!.obs;
  //Manage Watchbox view order
  final watchboxOrder = WristCheckPreferences.getWatchOrder().obs;
  //Manage Watchbox View Type
  final watchBoxView = WristCheckPreferences.getWatchBoxView().obs;
  //Manage locale
  final locale = WristCheckFormatter.getLocaleEnum(WristCheckPreferences.getLocale()!).obs;

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

}
