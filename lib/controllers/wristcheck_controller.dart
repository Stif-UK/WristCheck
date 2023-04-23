import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/errors/error_handling.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class WristCheckController extends GetxController {

  //Manage app purchase status
  final isAppPro = WristCheckPreferences.getAppPurchasedStatus()!.obs;

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

}
