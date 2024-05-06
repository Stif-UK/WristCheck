import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/backup_restore_methods.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/copy/whats_new_copy.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:hive/hive.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/notifications.dart';
import 'package:wristcheck/ui/remove_ads.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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
      middleText: "It looks like you've already worn this watch on the given date! \n \n"
          "if you want to track an additional wear, select 'Add Again' to track. \n \n"
          "otherwise cancel to go back",
        confirmTextColor: Colors.white,
        buttonColor: Colors.lightBlueAccent,
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

  static getBackupHelpDialog(){
    Get.defaultDialog(
        title: "Backup Database Help",
        barrierDismissible: true,
        middleText: "Getting a new phone or just want a backup in case the worst happens?\n You're in the right place!"
            "\n\nCreate a backup of your watchbox or restore an existing copy."
            "\n\nNote: Restoring the database will clear down any existing data and REPLACE it with the backup."
            "\n\nIf any issues arise during the backup / restore process these can often be resolved by killing and restarting the application."

    );
  }

  static getIncorrectFilenameDialog(String filename){
    Get.defaultDialog(
      title: "Incorrect file",
      barrierDismissible: true,
      middleText: "The file $filename does not match the expected file of watchbox.hive\n\n"
          "Please select a watchbox.hive file"
    );
  }

  static getConfirmRestoreDialog(File watchbox){
    Get.defaultDialog(
      title: "Restore from Backup",
      barrierDismissible: false,
      middleText: "Restoring this backup will over-write your current watch-box.\n\n"
          "Do you want to continue?",
        confirmTextColor: Colors.white,
        buttonColor: Colors.lightBlueAccent,
      onCancel: (){},
      onConfirm: (){
        BackupRestoreMethods.restoreWatchBox(watchbox);
        Get.back();
      }
    );
  }

  static getRestoreFailedDialog(String error){
    Get.defaultDialog(
      title: "Restore Failed",
      barrierDismissible: true,
      middleText: "Failed to restore from backup, an error occurred:\n\n"
          "$error\n\n"
          "Please try again - if the issue persists please contact the app developer"
    );
  }

  static getRestoreSuccessDialog(){
    Get.defaultDialog(
      title: "Restore Successful",
      barrierDismissible: true,
      middleText: "Database successfully restored!\n\n"
          "If watches don't show immediately try navigating between the main tabs.",
      confirmTextColor: Colors.white,
      buttonColor: Colors.lightBlueAccent,
      onConfirm: () async {
        var box = Boxes.getWatches();
        await box.close().then((_) => Hive.openBox<Watches>("WatchBox"));
        Get.back();
      }
    );
  }


  static getBackupLocationNullDialog(){
    Get.defaultDialog(
        title: "Backup / Restore",
        barrierDismissible: true,
        middleText: "No Backup location is specified. Please first select where to store the backup file"
    );
  }

  static getBackupFailedDialog(String error){
    Get.defaultDialog(
        title: "Error",
        barrierDismissible: true,
        middleText: "Backup Failed\n\n"
            "$error\n\n"
            "It could be that the selected location is not accessible to the application. Try with a different location.\n\n"
            "If this doesn't work, please provide feedback to the developer via the app store."
    );
  }

  static getOpenWatchBoxFailed(String error){
    Get.defaultDialog(
        title: "Error",
        barrierDismissible: true,
        middleText: "Failed to re-open watchbox\n\n"
            "$error\n\n"
            "Some errors can be resolved by killing and restarting the application.\n\n"
            "If this doesn't work, please provide feedback to the developer via the app store."
    );
  }

  static getBackupSuccessDialog(){
    Get.defaultDialog(
        title: "Backup Complete",
        barrierDismissible: true,
        middleText: "WatchBox Data has been saved."
    );
  }

  static getWhatsNewDialog(BuildContext context){
    Get.defaultDialog(
      title: "What's New?",
      content: SizedBox(
          width: (MediaQuery.of(context).size.width)*0.7,
          height:(MediaQuery.of(context).size.width)*0.65,
          child: Markdown(data: WhatsNewCopy.getLatestVersionCopy(),))
    );
  }

  static getFutureDateDialog(){
    Get.defaultDialog(
      title: "Error",
      middleText: "Wear dates must be in the past, please select a different date."
    );
  }

  static getHiddenStats(int? _openCount, int? _wearCount, DateTime? _refDate){
    Get.defaultDialog(
        title: "Hidden Stats",
        middleText: "You have opened this application $_openCount times\n\n"
            "You have tracked wearing your watches $_wearCount times\n\n"
            "Reference Date is set to: ${_refDate == null? "Not Set" : WristCheckFormatter.getFormattedDate(_refDate)}"
    );
  }

  static getNotificationSettingsHelpDialog(){
    //If the platform is Android help text clarifies the potential for some manufacturers to block background notifications
    Platform.isAndroid? Get.defaultDialog(
      title: "Notification Settings",
      middleText: "When enabled a notification will trigger daily at the selected time.\n\n"
          "Note: Some device manufacturers run customised versions of Android OS which may impact the ability for the app to generate notifications when in the background.\n\n"
          "Unfortunately as a developer there's little that can be done to prevent this. \n\n"
          "This is known to affect Huawei and Xiaomi phones, but may also affect others. "
    ):
        Get.defaultDialog(
            title: "Notification Settings",
            middleText: "When enabled a notification will trigger daily at the selected time."
        );
  }

  static getWearDatesHelpDialog() {
    Get.defaultDialog(
        title: "Wear History",
        middleText: "This calendar shows the dates this watch was worn, as well as other tracked dates for the watch.\n\n"
            "To add or delete wear dates directly, long press on an individual date."

    );
  }

  static getFailedToPickImageDialog(PlatformException e){
    Get.defaultDialog(
      title: "Failed to Pick Image",
      middleText: "The platform encountered an error:\n\n"
          "${e.toString()}"
    );

  }

  static getSetupNotificationsDialog(BuildContext context){
    Get.defaultDialog(
      title: "Setup Daily Reminders",
      middleText: "WristCheck can send you a daily reminder to track what you're wearing\n\n"
          "Would you like to set one up?\n\n"
          "(This can be found at any time in the settings menu)",
      textConfirm: "Yes",
      textCancel: "No Thanks",
      confirmTextColor: Colors.white,
      buttonColor: Colors.lightBlueAccent,
      onConfirm: () => Get.to(Notifications()),
      onCancel: () => Get.back(),

    );

  }

  static getSoldStatusPopup(){
    Get.defaultDialog(
      title: "Sold Watches",
      barrierDismissible: true,
      middleText: "You're marking this watch as sold:\n\nYou can now add a sold date, sale price and information on the buyer under the schedule and value tabs.",
      textCancel: "Don't show this message again",
      textConfirm: "OK",
      onConfirm: (){
        Get.back();
      },
      onCancel: () {
        WristCheckPreferences.setShowSoldDialog(false);
      }

    );
  }

  static getPreOrderStatusPopUp(){
    Get.defaultDialog(
        title: "Pre-Ordered Watches",
        barrierDismissible: true,
        middleText: "You're marking this watch as Pre-Ordered:\n\nYou can now add a due date on the schedule tab.\nThis will enable a countdown to the given date.",
        textCancel: "Don't show this message again",
        textConfirm: "OK",
        onConfirm: (){
          Get.back();
        },
        onCancel: () {
          WristCheckPreferences.setShowPreOrderDialog(false);
        }

    );
  }

  static getNoImagesFoundDialog() {
    Get.defaultDialog(
        title: "No Images Found",
        middleText: "No backup has been generated as no watch images were identified"
    );
  }

  static getFailedToBackupImages(Exception e){
    Get.defaultDialog(
      title: "Failed to Backup Images",
      middleText: "Failed to backup images, the following error was returned:\n"
          "${e.toString()}"
    );
  }

  static getImageBackupSuccessDialog(int count){
    Get.defaultDialog(
        title: "Success!",
        middleText: "$count Images successfully backed up"
    );
  }

  static getWatchboxBackupSuccessDialog(){
    Get.defaultDialog(
        title: "Success!",
        middleText: "Watchbox successfully backed up"
    );
  }

  static getExtractSuccessDialog(){
    Get.defaultDialog(
        title: "Success!",
        middleText: "Extract Successfully Created"
    );
  }

  static getGeneralErrorDialog(Exception e){
    Get.defaultDialog(
      title: "Something went wrong!",
      middleText: "An unexpected error occured with message: $e",
    );
  }

  static getProUpgradeMessage(){
    Get.defaultDialog(
      title: "Pro Feature",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("This is a WristCheck Pro feature.\n\nTo learn more and upgrade, click below.",
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(child: Text("Tell me more"),
            onPressed: () {
              Get.back();
              Get.to(() => RemoveAds());
            }
            ),
          ),
          TextButton(child: Text("Cancel"),
          onPressed: () => Get.back(),)
        ],
      )
    );
  }

}