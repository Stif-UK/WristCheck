import 'package:get/get.dart';

class WristCheckDialogs {

  static getServiceIntervalTooltipDialog(){
    Get.defaultDialog(
      title: "Service Interval",
      barrierDismissible: true,
      middleText: "By setting a service interval a 'service due date' will be calculated and displayed on the Service screen of the app (as long as either a purchase date or last service date is set).\n  \n "
          "The value of this field can be left at zero to disable for this watch.",
    );
  }

  static getServicePageTooltipDialog(){
    Get.defaultDialog(
      title: "Service Schedule",
      barrierDismissible: true,
      middleText: "This tab shows the next service dates of watches in your collection, based on either their purchase date or last serviced date, along with the given service interval. \n \n"
          "If a service is due within the next 3 months the leading icon is highlighted in red",
    );
  }



}