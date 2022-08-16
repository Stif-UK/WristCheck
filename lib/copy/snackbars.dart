import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WristCheckSnackBars{

  static addWearSnackbar(Watches watch, DateTime date){
    Get.snackbar(
      "Wear Recorded",
      "${watch.manufacturer} ${watch.model} was worn on ${WristCheckFormatter.getFormattedDate(date)}",
      icon: const Icon(Icons.watch),
      snackPosition: SnackPosition.BOTTOM,
    );
  }


}