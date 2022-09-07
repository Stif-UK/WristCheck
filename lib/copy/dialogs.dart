import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/copy/whats_new_copy.dart';
import 'package:flutter/material.dart';

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

  static getDuplicateWearDialog(Watches currentWatch, DateTime date)   {
    Get.defaultDialog(
      title: "Duplicate Date Warning",
      barrierDismissible: false,
      middleText: "It looks like you've already worn this watch today! \n \n"
          "if you want to track an additional wear, select 'Add Again' to track. \n \n"
          "otherwise cancel to go back",

      onConfirm: (){
        Get.back();
        WatchMethods.attemptToRecordWear(currentWatch, date, true);
      },
      textCancel: "Cancel",
      textConfirm: "Add Again"
    );
  }

  static getCollectionStatsDialog(){
    Get.defaultDialog(
      title: "Collection Stats",
      barrierDismissible: true,
      middleText: "All values are based on data held within your watch collection.\n\nWhere calculations are made based on dates (such as 'oldest watch') the data is only as accurate as the data provided to the application.\n"
          "\nYou can edit data associated with individual watches by navigating to them via the main watch box screens."
    );
  }

  static getViewWatchDialog(){
    Get.defaultDialog(
        title: "Watch Info",
        barrierDismissible: true,
        middleText: "This page allows viewing and editing of watch information. \n\n"
            "Select 'Wear Today' to record that the watch has been worn today - the calendar icon allows editing of the wear history"
            "\n\nSet a purchase date and service interval to create a service schedule for this watch."
            "\n\nChange the status to move the watch between your Wish List, Collection and Sold lists, or chose Archive to remove the watch from the main views (Archived watches can still be found under app settings)"
    );
  }

  static getArchivedHelpDialog(){
    Get.defaultDialog(
        title: "Watch Archive",
        barrierDismissible: true,
        middleText: "When a watch status is marked as 'Archived' it is removed from the main collection and stored here."
            "\n\nWatches in the archive can be permanently deleted with a swipe to the left."
    );
  }

  static getWhatsNewDialog(BuildContext context){
    Get.defaultDialog(
      title: "What's New?",
      content: SizedBox(
          width: (MediaQuery.of(context).size.width)*0.7,
          height:(MediaQuery.of(context).size.width)*0.5,
          child: Markdown(data: WhatsNewCopy.getLatestVersionCopy(),))
    );
  }

  static getFutureDateDialog(){
    Get.defaultDialog(
      title: "Error",
      middleText: "Wear dates must be in the past, please select a different date."
    );
  }

  static getHiddenStats(int openCount){
    Get.defaultDialog(
        title: "Hidden Stats",
        middleText: "You have opened this application $openCount times"
    );
  }

}