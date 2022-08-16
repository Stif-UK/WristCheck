import 'package:get/get.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';

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

  static getDuplicateWearDialog(Watches currentWatch, DateTime date){
    Get.defaultDialog(
      title: "Duplicate Date Warning",
      barrierDismissible: false,
      middleText: "It looks like you've already worn this watch today! \n \n"
          "if you want to track an additional wear, select 'Add Again' to track. \n \n"
          "otherwise cancel to go back",

      onConfirm: (){
        //WatchMethods.attemptToRecordWear(currentWatch, date, true);
        Get.back();
        WatchMethods.attemptToRecordWear(currentWatch, date, true);
      },
      textCancel: "Cancel",
      textConfirm: "Add Again"
    );
  }

}