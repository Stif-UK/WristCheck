import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WristCheckSnackBars{

  static addWearSnackbar(Watches watch, DateTime date){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.addWearSnackbarTitle,
        AppLocalizations.of(Get.context!)!.addWearSnackbarText(WristCheckFormatter.getFormattedDate(date), watch),
        icon: const Icon(Icons.watch),
      snackPosition: SnackPosition.TOP,
    );
  }

  static removeWearSnackbar(Watches watch, DateTime date){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.dateDeletedSnackbarTitle,
        AppLocalizations.of(Get.context!)!.dateDeletedSnackbarText(WristCheckFormatter.getFormattedDate(date), watch),
      icon: const Icon(Icons.watch),
      snackPosition: SnackPosition.TOP,
    );
  }

  static collectionDeletedSnackbar(){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.collectionDeletedSnackbarTitle,
      AppLocalizations.of(Get.context!)!.collectionDeletedSnackbarText,
      icon: const Icon(Icons.delete),
      snackPosition: SnackPosition.TOP,
    );
  }

  static deleteWatch(String info){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.deleteWatchPermanentlySnackbarTitle,
      AppLocalizations.of(Get.context!)!.deleteWatchPermanentlySnackbarText(info),
      icon: const Icon(Icons.archive_rounded),
      snackPosition: SnackPosition.TOP,
    );
  }

  static restoreWatch(String watch, String status){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.restoreWatchSnackbarTitle,
      AppLocalizations.of(Get.context!)!.restoreWatchSnackbarText(watch, status),
      icon: const Icon(Icons.restore_from_trash),
      snackPosition: SnackPosition.TOP,
    );
  }

  static dailyNotification(String selectedTime){
    Get.snackbar(
      AppLocalizations.of(Get.context!)!.reminderSetSnackbarTitle,
      AppLocalizations.of(Get.context!)!.reminderSetSnackbarText(selectedTime),
    icon: const Icon(Icons.add_alert_outlined),
    snackPosition: SnackPosition.TOP,
    shouldIconPulse: true);
  }




}