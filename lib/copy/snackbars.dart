import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:intl/intl.dart';

class WristCheckSnackBars{

  static addWearSnackbar(Watches watch, DateTime date){
    Get.snackbar(
      "Wear Recorded",
      "${watch.manufacturer} ${watch.model} was worn on ${DateFormat.yMMMd(date.toString())}",
      icon: const Icon(Icons.watch),
      snackPosition: SnackPosition.BOTTOM,
    );
  }


}