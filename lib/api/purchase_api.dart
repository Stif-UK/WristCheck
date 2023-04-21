import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/api/keys.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/errors/error_handling.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class PurchaseApi{
  static final _apiKey = WristCheckKeys.getRevenueCatKey();
  final wristCheckController = Get.put(WristCheckController());

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
    //App will fail to load if no API key is present in the keys file!!
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOffers() async{
    try{
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null? [] : [current];
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      showSuccessDialog();
      return true;
    } catch (e) {
      if(e is PlatformException) {
        WristCheckErrorHandling.handlePurchaseError(e);
      }
      return false;
    }
  }

  static Future<String> getAppPurchaseDate(bool first) async {
    String returnString = "Not Found";
    if (WristCheckPreferences.getAppPurchasedStatus() ?? false) {
      try {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        returnString = first? customerInfo.allPurchaseDates.values.last.toString(): customerInfo.allPurchaseDates.values.first.toString() ;
      } on PlatformException catch (e) {
        WristCheckErrorHandling.surfacePlatformError(e);
      }
    }
    return returnString;
  }

  static Future<bool> restorePurchases() async {
    bool? restoreSuccess = false;
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      restoreSuccess = customerInfo.entitlements.all["WristCheck Pro"]?.isActive ;
    } on PlatformException catch (e) {
      WristCheckErrorHandling.handlePurchaseError(e);
    }
    return restoreSuccess ?? false;
  }

  //checkEntitlements should only be called for a user that holds a pro app - its purpose is to validate that the pro sub is still valid
  static checkEntitlements() async {
    bool? entitlementValid = true;

    try {
      print("Getting customer info");
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      print("Checking entitlement is valid");
      entitlementValid = customerInfo.entitlements.all["WristCheck Pro"]?.isActive ;
      print("Status: $entitlementValid");
      WristCheckPreferences.setLastEntitlementCheckDate(DateTime.now());
    } on PlatformException catch (e) {
      //WristCheckErrorHandling.handlePurchaseError(e);
    }
    //If the entitlement check shows the entitlement is not valid, remove pro status
    if(!(entitlementValid ?? true)){
      final wristCheckController = Get.put(WristCheckController());
      wristCheckController.revertPurchaseStatus();

    }
  }

  static getAppUserID() async{
    String returnString = "N/A";
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if(customerInfo != null){
        returnString = customerInfo.originalAppUserId;
      }

    } on PlatformException catch (e) {
      //WristCheckErrorHandling.handlePurchaseError(e);
    }
    return returnString;
  }

  static showSuccessDialog(){
    Get.defaultDialog(
        title: "Payment Successful",
        middleText: "Thank you for supporting WristCheck!\n"
            "Your contribution helps me to keep the app going and is really appreciated.\n\n"
            "Got any feedback or ideas for improvement? Please leave an app review or drop me an email!"

    );
  }
}