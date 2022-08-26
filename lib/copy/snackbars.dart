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

  static removeWearSnackbar(Watches watch, DateTime date){
    Get.snackbar(
      "Date Deleted",
      "${WristCheckFormatter.getFormattedDate(date)} was removed from the record for ${watch.manufacturer} ${watch.model}",
      icon: const Icon(Icons.watch),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static collectionDeletedSnackbar(){
    Get.snackbar(
      "Watches Cleared",
      "Your watch collection is now empty",
      icon: const Icon(Icons.delete),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static deleteWatch(String info){
    Get.snackbar(
      "Watch Deleted",
      "$info has been permanently deleted",
      icon: const Icon(Icons.archive_rounded),
      snackPosition: SnackPosition.BOTTOM,
    );
  }




}