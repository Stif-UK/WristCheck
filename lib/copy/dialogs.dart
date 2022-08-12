import 'package:get/get.dart';

class WristCheckDialogs {

  static getServiceIntervalTooltipDialog(){
    Get.defaultDialog(
      title: "Service Interval",
      barrierDismissible: true,
      middleText: "By setting a service interval a 'service due date' will be calculated and displayed on the Service screen of the app (as long as a purchase date or last service date is set).\n  \n "
          "The value of this field can be left at zero to disable for this watch.",

    );

}

}