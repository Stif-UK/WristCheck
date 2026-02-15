import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
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
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class WristCheckDialogs {

  static getServiceIntervalTooltipDialog(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.serviceIntervalTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.serviceIntervalText
    );
  }

  //TODO: Refactor this out - page no longer in the app
  // static getServicePageTooltipDialog(){
  //   Get.defaultDialog(
  //     title: "Service Schedule",
  //     barrierDismissible: true,
  //     middleText: "This tab shows the next service dates of watches in your collection, based on either their purchase date or last serviced date, along with the given service interval. \n \n"
  //         "If a service is due within the next 3 months the leading icon is highlighted in red",
  //   );
  // }

  static getDuplicateWearDialog(Watches currentWatch, DateTime date)   {
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.duplicateWearTitle,
      barrierDismissible: false,
      middleText: AppLocalizations.of(Get.context!)!.duplicateWearText,
        confirmTextColor: Colors.white,
        buttonColor: Colors.lightBlueAccent,
      onConfirm: (){
        Get.back();
        WatchMethods.attemptToRecordWear(currentWatch, date, true);
      },
      textCancel: AppLocalizations.of(Get.context!)!.cancel,
      textConfirm: AppLocalizations.of(Get.context!)!.duplicateWearConfirm
    );
  }

  static getCollectionStatsDialog(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.collectionStatsDialogTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.collectionStatsDialogText
    );
  }

  //TODO: Refactor out - this help text is no longer used within the app
  // static getViewWatchDialog(){
  //   Get.defaultDialog(
  //       title: "Watch Info",
  //       barrierDismissible: true,
  //       middleText: "This page allows viewing and editing of watch information. \n\n"
  //           "Select 'Wear Today' to record that the watch has been worn today - the calendar icon allows editing of the wear history"
  //           "\n\nSet a purchase date and service interval to create a service schedule for this watch."
  //           "\n\nChange the status to move the watch between your Wish List, Collection and Sold lists, or chose Archive to remove the watch from the main views (Archived watches can still be found under app settings)"
  //   );
  // }

  static getArchivedHelpDialog(){
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.archivedHelpDialogTitle,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.archivedHelpDialogText
    );

  }

  static getBackupHelpDialog(){
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.backupHelpDialogTitle,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.backupHelpDialogText
    );
  }

  static getIncorrectFilenameDialog(String filename){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.incorrectFilenameDialogTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.incorrectFilenameDialogText(filename)
    );
  }

  static getConfirmRestoreDialog(File watchbox){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.confirmRestoreDialogTitle,
      barrierDismissible: false,
      middleText: AppLocalizations.of(Get.context!)!.confirmRestoreDialogText,
        confirmTextColor: Colors.white,
        buttonColor: Colors.lightBlueAccent,
        textCancel: AppLocalizations.of(Get.context!)!.cancel,
        textConfirm: AppLocalizations.of(Get.context!)!.ok,
      onCancel: (){},
      onConfirm: (){
        BackupRestoreMethods.restoreWatchBox(watchbox);
        Get.back();
      }
    );
  }

  static getRestoreFailedDialog(String error){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.restoreFailedTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.restoreFailedText(error)
    );
  }

  static getRestoreSuccessDialog(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.restoreSuccessDialogTitle,
      barrierDismissible: true,
      middleText: AppLocalizations.of(Get.context!)!.restoreSuccessDialogText,
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
        title: AppLocalizations.of(Get.context!)!.backupRestoreHeader,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.backupLocationNullDialogText
    );
  }

  static getBackupFailedDialog(String error){
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.errorHeader,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.backupFailedDialogText(error)
    );
  }

  static getOpenWatchBoxFailed(String error){
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.errorHeader,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.watchboxFailedErrorDialog(error)
    );
  }

  //TODO: Refactor to remove this and the calling function - sharebackup has deprecated this
  static getBackupSuccessDialog(){
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.backupCompleteDialogTitle,
        barrierDismissible: true,
        middleText: AppLocalizations.of(Get.context!)!.backupCompleteDialogText
    );
  }

  static getWhatsNewDialog(BuildContext context){
    Get.bottomSheet(
      backgroundColor: Theme.of(Get.context!).dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
          ),
      Container(
          height: MediaQuery.of(context).size.height, //*0.85,
        child: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.gripLines,
                size: Theme.of(Get.context!).textTheme.headlineMedium!.fontSize,
                color: Theme.of(Get.context!).textTheme.headlineMedium!.color ,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(Get.context!)!.wristTrackUpdatedBottomSheetTitle,
                  style: Theme.of(Get.context!).textTheme.headlineMedium, textAlign: TextAlign.center,),
              ),
              Markdown(data: WhatsNewCopy.getLatestVersionCopy(),
              shrinkWrap: true,),
            ],
          ),
        )
      )
    );
  }

  static getFutureDateDialog(){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.errorHeader,
      middleText: AppLocalizations.of(Get.context!)!.futureDateErrorDialogText
    );
  }

  static getNotificationSettingsHelpDialog(){
    //If the platform is Android help text clarifies the potential for some manufacturers to block background notifications
    Platform.isAndroid? Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.notificationSettingsHelpDialogTitle,
      middleText: "${AppLocalizations.of(Get.context!)!.notificationsSettingsHelpDialogText}${AppLocalizations.of(Get.context!)!.notificationSettingsHelpDialogTextAndroid}"
    ):
        Get.defaultDialog(
            title: AppLocalizations.of(Get.context!)!.notificationSettingsHelpDialogTitle,
            middleText: AppLocalizations.of(Get.context!)!.notificationsSettingsHelpDialogText
        );
  }

  static getWearDatesHelpDialog() {
    Get.defaultDialog(
        title: AppLocalizations.of(Get.context!)!.wearDatesHelpDialogTitle,
        middleText: AppLocalizations.of(Get.context!)!.wearDatesHelpDialogText

    );
  }

  static showImageDeleteDialog(BuildContext context, Watches currentWatch, int index) {
    Widget deleteButton = ElevatedButton(
        child: Text(AppLocalizations.of(Get.context!)!.deleteImageDialogTitle),
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
    onPressed: () async {
          await ImagesUtil.deleteImageAndUpdateView(currentWatch, index);
      //Pop twice to close alert and bottomsheet
      Navigator.pop(context);
      Navigator.pop(context);

    },
    );

    // set up the cancel button
    //TODO: Create buttons for reuse across the app
    Widget cancelButton = ElevatedButton(
      child: Text(AppLocalizations.of(Get.context!)!.cancel),
      onPressed: ()=> Navigator.pop(context),
    );

    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(Get.context!)!.deleteImageDialogTitle),
      content: Text(AppLocalizations.of(Get.context!)!.deleteImageDialogText),
      actions: [
        cancelButton,
        deleteButton
      ]
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showDeleteWatchDialog(BuildContext context, Watches currentWatch) {
    final watchViewController = Get.put(WatchViewController());
    // set up the delete button
    Widget deleteButton = ElevatedButton(
      child: Text(AppLocalizations.of(Get.context!)!.deleteWatchTitle),
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
      onPressed: () async {
        await WatchMethods.archiveWatch(currentWatch);
        //Use back navigation twice to close overlay and move back while maintaining widget tree
        watchViewController.updateOverrideBacknav(true);
        Get.back(closeOverlays: true);
        Get.back();
        Get.snackbar(AppLocalizations.of(Get.context!)!.deleteWatchSnackbarConfirmation, AppLocalizations.of(Get.context!)!.deleteWatchSnackbarText(currentWatch.toString()));
      },
    );

    // set up the cancel button
    Widget cancelButton = ElevatedButton(
      child: Text(AppLocalizations.of(Get.context!)!.cancel),
      onPressed: ()=> Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(Get.context!)!.deleteWatchTitle),
      content: Text(AppLocalizations.of(Get.context!)!.deleteWatchDialogText),
      actions: [
        cancelButton,
        deleteButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static getFailedToPickImageDialog(PlatformException e){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.failedToPickImageDialogTitle,
      middleText: AppLocalizations.of(Get.context!)!.failedToPickImageDialogText(e.toString())
    );


  }

  static getSetupNotificationsDialog(BuildContext context){
    Get.defaultDialog(
      title: AppLocalizations.of(Get.context!)!.setupDailyReminderDialogTitle,
      middleText: AppLocalizations.of(Get.context!)!.setupDailyRemindersDialogText,
      textConfirm: AppLocalizations.of(Get.context!)!.yes,
      textCancel: AppLocalizations.of(Get.context!)!.noThanks,
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
      textCancel: AppLocalizations.of(Get.context!)!.dontShowThisMessageAgain,
      textConfirm: AppLocalizations.of(Get.context!)!.ok,
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
        textCancel: AppLocalizations.of(Get.context!)!.dontShowThisMessageAgain,
        textConfirm: AppLocalizations.of(Get.context!)!.ok,
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

  static getProUpgradeMessage(BuildContext context){
    Get.defaultDialog(
      title: "Pro Feature",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/customicons/pro_icon.png',scale:1.0,height:50.0,width:50.0, color: Theme.of(context).hintColor),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("This is a WristTrack Pro feature.\n\nTo learn more and upgrade, click below.",
              textAlign: TextAlign.center,
            ),
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
          TextButton(child: Text(AppLocalizations.of(Get.context!)!.cancel),
          onPressed: () => Get.back(),)
        ],
      )
    );
  }

}