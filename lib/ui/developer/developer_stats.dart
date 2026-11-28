import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/api/purchase_api.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/privacy/biometric_lock_wrapper.dart';
import 'package:wristcheck/ui/developer/developer_accuracy_view.dart';
import 'package:wristcheck/ui/developer/raw_data_view.dart';
import 'package:wristcheck/ui/onboarding.dart';
import 'package:wristcheck/ui/wrist_recap/animated_recap_preview_page.dart';
import 'package:wristcheck/ui/widgets/nba_notifications/wristtrack_global_banner.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class DeveloperStats extends StatefulWidget {
  const DeveloperStats({
    Key? key,
    this.initialTabIndex = 0,
    this.wristRewindEnabledOverride,
    this.wristRewindNotificationEnabledOverride,
  }) : super(key: key);

  final int initialTabIndex;
  final bool? wristRewindEnabledOverride;
  final bool? wristRewindNotificationEnabledOverride;

  @override
  State<DeveloperStats> createState() => _DeveloperStatsState();
}

class _DeveloperStatsState extends State<DeveloperStats> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    final controller = Get.put(WristCheckController());
    if (widget.wristRewindEnabledOverride != null || Firebase.apps.isNotEmpty) {
      controller.refreshWristRewind2026(
        enabledOverride: widget.wristRewindEnabledOverride,
      );
    }
    if (widget.wristRewindNotificationEnabledOverride != null ||
        Firebase.apps.isNotEmpty) {
      controller.refreshWristRewind2026Notification(
        enabledOverride: widget.wristRewindNotificationEnabledOverride,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wristCheckController = Get.put(WristCheckController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Stats"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

        }, items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.cashRegister),
          label: "Purchase",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.info),
          label: "Info",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.database),
          label: "Database",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.bell),
          label: "Notifications",
        ),
      ],

      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: _buildCurrentTab(wristCheckController, context),
        ),
      ),
    );
  }

  Widget _buildCurrentTab(WristCheckController wristCheckController, BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return _buildPurchaseTab(wristCheckController);
      case 1:
        return _buildInfoTab(context);
      case 2:
        return _buildDatabaseTab();
      case 3:
        return _buildNotificationsTab(wristCheckController);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPurchaseTab(WristCheckController wristCheckController) {
    return Column(
      children: [
        ListTile(
          title: const Text("App Purchased"),
          subtitle: Text("${WristCheckPreferences.getAppPurchasedStatus() ?? false}"),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("OTP Auth Test"),
          subtitle: const Text("Open the OTP verify view"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => Get.toNamed('/otp-demo'),
        ),
        const Divider(thickness: 2,),
        FutureBuilder(
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ListTile(title: Text('${snapshot.error} occurred'),);
              } else if (snapshot.hasData) {
                final data = snapshot.data as String;
                return ListTile(
                  title: const Text("Purchase Date"),
                  subtitle: Text('$data',),
                );
              }
            }
            return const ListTile(
              title: Text("Purchase Date"),
              trailing: CircularProgressIndicator(),
            );
          },
          future: getPurchaseDate(),
        ),
        const Divider(thickness: 2,),
        FutureBuilder(
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ListTile(title: Text('${snapshot.error} occurred'),);
              } else if (snapshot.hasData) {
                final data = snapshot.data as String;
                return ListTile(
                  title: const Text("Last Donation Date"),
                  subtitle: Text('$data',),
                );
              }
            }
            return const ListTile(
              title: Text("Last Donation Date"),
              trailing: CircularProgressIndicator(),
            );
          },
          future: getLastDonationDate(),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Last Donation Prompt Dismissed"),
          subtitle: WristCheckPreferences.getLastDonationNotificationDismissed() != null
              ? Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastDonationNotificationDismissed()!))
              : const Text("Not Recorded"),
          onLongPress: () async {
            await WristCheckPreferences.setLastDonationNotificationDismissed(DateTime(2000, 1, 1));
            setState(() {});
            Get.snackbar(
                "Date Reset",
                "Last Donation Prompt date reset to 01/01/2000",
                icon: const Icon(Icons.refresh),
                snackPosition: SnackPosition.BOTTOM
            );
          },
        ),
        const Divider(thickness: 2,),
        FutureBuilder(
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ListTile(title: Text('${snapshot.error} occurred'),);
              } else if (snapshot.hasData) {
                final data = snapshot.data as String;
                return ListTile(
                  title: const Text("Last Entitlement Check"),
                  subtitle: Text('$data',),
                );
              }
            }
            return const ListTile(
              title: Text("Last Entitlement Check"),
              trailing: CircularProgressIndicator(),
            );
          },
          future: getLastEntilementCheck(),
        ),
        const Divider(thickness: 2,),
        FutureBuilder(
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return ListTile(title: Text('${snapshot.error} occurred'),);
              } else if (snapshot.hasData) {
                final data = snapshot.data as String;
                return ListTile(
                  title: const Text("App User ID"),
                  subtitle: Text('$data',),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: (){
                      Clipboard.setData(ClipboardData(text:'$data'));
                      Get.snackbar(
                          "Copied",
                          "appUserID saved to clipboard",
                          icon: const Icon(Icons.copy),
                          snackPosition: SnackPosition.BOTTOM
                      );
                    },
                  ),
                );
              }
            }
            return const ListTile(
              title: Text("App User ID"),
              trailing: CircularProgressIndicator(),
            );
          },
          future: PurchaseApi.getAppUserID(),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Revert Purchase Status"),
          subtitle: const Text("Remove pro option and show ads by clicking here. If done in error purchases can be restored on the 'remove ads' page"),
          onTap: (){
            wristCheckController.revertPurchaseStatus();
            Get.snackbar(
                "Reverted",
                "User is no longer Pro on this app",
                icon: const Icon(Icons.no_accounts),
                snackPosition: SnackPosition.BOTTOM
            );
          },
        ),
        const Divider(thickness: 2,),
      ],
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Preview Annual Recap Animation"),
          subtitle: const Text("Tap to view wristtrack_recap_23_11.riv Rive animation"),
          onTap: () {
            Get.to(() => const AnimatedRecapPreviewPage());
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Open Count"),
          subtitle: Text("App Opened: ${WristCheckPreferences.getOpenCount()} times"),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Show 'what's new' dialog"),
          subtitle: const Text("Click here to trigger dialog box for testing"),
          onTap: (){
            WristCheckDialogs.getWhatsNewDialog(context);
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Show onboarding slides"),
          subtitle: const Text("Click here to trigger the first use demo"),
          onTap: (){
            Get.to(()=>const WristCheckOnboarding());
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Reset all dialog preferences"),
          subtitle: const Text("Any dialogs that were chosen to 'not show again' will now be set to show"),
          onTap: (){
            WristCheckPreferences.setShowSoldDialog(true);
            WristCheckPreferences.setShowAccuracyHelp(true);
            Get.snackbar(
              "Action",
              "All Dialogs reset to show",
              snackPosition: SnackPosition.BOTTOM
            );
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: Text("Generate Crash"),
          subtitle: Text("Caution: Pressing this tile will cause an app crash for crashlytics testing only!"),
          onTap: () => throw Exception("Crashlytics test exception"),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: Text("Last Sale Prompt Dismissed"),
          subtitle: WristCheckPreferences.getLastSalePrompt() != null? Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastSalePrompt()!)) : Text("Not Recorded"),
          onLongPress: () async {
            DateTime newDate = DateTime.now().subtract(Duration(days: 31));
            await WristCheckPreferences.setLastSalePrompt(newDate);
            setState(() {});
            Get.snackbar(
                "Date Amended",
                "Last Prompted date moved 30+ days into the past",
                icon: const Icon(Icons.date_range),
                snackPosition: SnackPosition.BOTTOM
            );
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Last WristRecap Notification Dismissed"),
          subtitle: Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastRecapNotification())),
          onLongPress: () {
            WristCheckPreferences.setLastRecapNotification(DateTime(2000, 1, 1));
            setState(() {});
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Last Go Pro Notification Dismissed"),
          subtitle: Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastGoProNotificationDismissed())),
          onLongPress: () {
            WristCheckPreferences.setLastGoProNotificationDismissed(DateTime(2000, 1, 1));
            setState(() {});
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Last NBA shown date"),
          subtitle: Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastNBADate())),
          onLongPress: () {
            WristCheckPreferences.setLastNBADate(DateTime(2000, 1, 1));
            setState(() {});
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Last Rewarded Ad Watched"),
          subtitle: Text(WristCheckFormatter.getFormattedDate(WristCheckPreferences.getLastRecordedAdTimestamp())),
          onLongPress: () {
            WristCheckPreferences.setLastRecordedAdTimestamp(DateTime(2000, 1, 1));
            setState(() {});
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Number of recorded ads watched"),
          subtitle: Text(WristCheckPreferences.getRewardedAdCount().toString()),
        ),
        const Divider(thickness: 2,),
      ],
    );
  }

  Widget _buildDatabaseTab() {
    return Column(
      children: [
        ListTile(
          title: const Text("Show Accuracy Database"),
          onTap: () => Get.to(()=> DeveloperAccuracyView()),
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Show Raw Watch Database"),
          onTap: () => Get.to(()=> RawDataView()),
        ),
        const Divider(thickness: 2,),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.folderOpen),
          title: const Text("Export All /img Files to Folder"),
          subtitle: const Text(
            "Scans local /img storage directly (ignoring database paths) and copies all full images plus any fallback thumbnails into a folder you pick.",
          ),
          onTap: _exportAllImgFilesToFolder,
        ),
        const Divider(thickness: 2,),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.link),
          title: const Text("Recover & Re-link Orphaned Images"),
          subtitle: const Text(
            "Matches unreferenced /img files back to watches missing image paths and triggers a cloud sync.",
          ),
          onTap: _confirmAndRelinkOrphanedImages,
        ),
        const Divider(thickness: 2,),
      ],
    );
  }

  Future<void> _exportAllImgFilesToFolder() async {
    final String? selectedDir = await BiometricLockWrapper.suppressLockDuring(
      () => FilePicker.getDirectoryPath(),
    );
    if (selectedDir == null || selectedDir.trim().isEmpty) return;

    Get.dialog(
      const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      barrierDismissible: false,
    );

    try {
      final result = await ImagesUtil.exportAllImgDirectoryFiles(selectedDir);
      if (Get.isDialogOpen ?? false) Get.back();

      final String summary = result.totalExported == 0
          ? "No image files were found in the local /img directory (scanned ${result.totalFilesScanned} files)."
          : "Exported ${result.fullImagesExported} full image(s) and ${result.thumbnailFallbacksExported} fallback thumbnail(s)"
              "${result.failedCount > 0 ? ' (${result.failedCount} failed)' : ''}.\n\nSaved to:\n${result.exportDirectoryPath}";

      await Get.defaultDialog(
        title: "Image Export Complete",
        middleText: summary,
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      await Get.defaultDialog(
        title: "Image Export Failed",
        middleText: e.toString(),
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    }
  }

  Future<void> _confirmAndRelinkOrphanedImages() async {
    await Get.defaultDialog(
      title: "Recover Orphaned Images",
      middleText:
          "This will scan local /img files and re-attach any unreferenced images to watches that currently have empty image paths, then queue a sync.",
      textConfirm: "Recover",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        Get.dialog(
          const PopScope(
            canPop: false,
            child: Center(child: CircularProgressIndicator()),
          ),
          barrierDismissible: false,
        );

        try {
          final result = await ImagesUtil.relinkOrphanedImages();
          if (Get.isDialogOpen ?? false) Get.back();

          await Get.defaultDialog(
            title: "Recovery Complete",
            middleText:
                "Found ${result.orphanedFilesFound} unreferenced image file(s).\n\n"
                "Restored ${result.slotsRestored} image slot(s) across ${result.watchesUpdated} watch(es).",
            textConfirm: "OK",
            confirmTextColor: Colors.white,
            onConfirm: () => Get.back(),
          );
        } catch (e) {
          if (Get.isDialogOpen ?? false) Get.back();
          await Get.defaultDialog(
            title: "Recovery Failed",
            middleText: e.toString(),
            textConfirm: "OK",
            confirmTextColor: Colors.white,
            onConfirm: () => Get.back(),
          );
        }
      },
    );
  }

  Widget _buildNotificationsTab(WristCheckController wristCheckController) {
    return Column(
      children: [
        Obx(() {
          final _ = wristCheckController.activeNBA.value;
          final status = wristCheckController.getWristRewind2026CountdownStatus();
          final String statusText;
          if (status.isDismissed) {
            statusText = 'Dismissed / Followed';
          } else if (status.firstShown == null) {
            statusText = status.remoteConfigEnabled
                ? 'Pending first display'
                : 'Inactive (Remote Config false)';
          } else if (status.isExpired) {
            statusText = 'Expired';
          } else if (status.remoteConfigEnabled) {
            statusText = 'Active';
          } else {
            statusText = 'Paused (Remote Config false)';
          }

          final String firstShownText = status.firstShown != null
              ? WristCheckFormatter.getFormattedDateAndTime(status.firstShown!)
              : 'Not started';

          final String countdownText;
          if (status.firstShown == null) {
            countdownText = 'Not started';
          } else if (status.isExpired) {
            countdownText =
                '0d 0h 0m remaining (ended ${WristCheckFormatter.getFormattedDateAndTime(status.expiresAt!)})';
          } else {
            final remaining = status.remaining!;
            final days = remaining.inDays;
            final hours = remaining.inHours.remainder(24);
            final minutes = remaining.inMinutes.remainder(60);
            countdownText =
                '${days}d ${hours}h ${minutes}m remaining (ends ${WristCheckFormatter.getFormattedDateAndTime(status.expiresAt!)})';
          }

          return ListTile(
            title: const Text('2026 Wrist Rewind 7-Day Countdown'),
            subtitle: Text(
              'Status: $statusText\n'
              'Banner Config (wrist_rewind_2026_notification): ${status.remoteConfigEnabled}\n'
              'More Menu Config (wrist_rewind_2026): ${wristCheckController.showWristRewind2026.value}\n'
              'First Shown: $firstShownText\n'
              'Countdown: $countdownText\n'
              'Dismissed: ${status.isDismissed}\n'
              'Tap to refresh, tap reset icon or long press to reset.',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset 7-day countdown',
              onPressed: () => _resetWristRewind2026Countdown(wristCheckController),
            ),
            onTap: () async {
              if (widget.wristRewindEnabledOverride != null || Firebase.apps.isNotEmpty) {
                await wristCheckController.refreshWristRewind2026(
                  enabledOverride: widget.wristRewindEnabledOverride,
                );
              }
              if (widget.wristRewindNotificationEnabledOverride != null ||
                  Firebase.apps.isNotEmpty) {
                await wristCheckController.refreshWristRewind2026Notification(
                  enabledOverride: widget.wristRewindNotificationEnabledOverride,
                );
              }
              if (mounted) {
                setState(() {});
              }
            },
            onLongPress: () => _resetWristRewind2026Countdown(wristCheckController),
          );
        }),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Show notification JSON"),
          subtitle: const Text("Tap to view current Remote Config banner payload"),
          onTap: () {
            final remoteConfig = FirebaseRemoteConfig.instance;
            final jsonContent = remoteConfig.getString('global_banner_notice');
            final displayJson = jsonContent.isNotEmpty ? jsonContent : remoteConfig.getString('global_banner_notification');

            Get.defaultDialog(
              title: "Notification JSON",
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(displayJson.isNotEmpty ? displayJson : "{}"),
                ),
              ),
              textConfirm: "Close",
              confirmTextColor: Colors.white,
              onConfirm: () => Get.back(),
            );
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Dismissed Notification IDs"),
          subtitle: Text("Most recent: ${WristCheckPreferences.getDismissedBannerIds().isNotEmpty ? WristCheckPreferences.getDismissedBannerIds().last : 'None'}\nTap to view, long press to clear."),
          onTap: () {
            List<String> dismissed = WristCheckPreferences.getDismissedBannerIds();
            Get.defaultDialog(
              title: "Dismissed IDs",
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: dismissed.isEmpty
                      ? const Text("No dismissed notification IDs found.")
                      : ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: dismissed
                                  .map((id) => ListTile(
                                        title: Text(id),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                ),
              ),
              textConfirm: "Close",
              confirmTextColor: Colors.white,
              onConfirm: () => Get.back(),
            );
          },
          onLongPress: () async {
            await WristCheckPreferences.clearDismissedBannerIds();
            setState(() {});
            Get.snackbar(
              "Cleared",
              "All dismissed notification IDs cleared",
              icon: const Icon(Icons.delete),
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        const Divider(thickness: 2,),
        ListTile(
          title: const Text("Load Test Notification"),
          subtitle: const Text("Tap to force load the global banner notification"),
          onTap: () {
            final wristCheckController = Get.find<WristCheckController>();
            wristCheckController.activeNBA(WristtrackGlobalBanner());
            Get.snackbar(
              "Notification Loaded",
              "Global banner notification loaded into active NBA",
              icon: const Icon(Icons.notifications_active),
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        const Divider(thickness: 2,),
      ],
    );
  }

  Future<void> _resetWristRewind2026Countdown(WristCheckController wristCheckController) async {
    await wristCheckController.resetWristRewind2026Notification(
      enabledOverride: widget.wristRewindNotificationEnabledOverride,
    );
    if (mounted) {
      setState(() {});
    }
    Get.snackbar(
      'Countdown Reset',
      '2026 Wrist Rewind 7-day countdown and dismissal state reset',
      icon: const Icon(Icons.refresh),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<String> getPurchaseDate() async {
    return  WristCheckPreferences.getAppPurchasedStatus() ?? false ? WristCheckFormatter.getFormattedDate(DateTime.parse(await PurchaseApi.getAppPurchaseDate(true))): "N/A";
  }

  Future<String> getLastDonationDate() async{
    return WristCheckPreferences.getAppPurchasedStatus() ?? false ? WristCheckFormatter.getFormattedDate(DateTime.parse(await PurchaseApi.getAppPurchaseDate(false))): "N/A";
  }

  Future<String> getLastEntilementCheck() async{
    return WristCheckPreferences.getLastEntitlementCheckDate() != null ? WristCheckFormatter.getFormattedDate(await WristCheckPreferences.getLastEntitlementCheckDate()!): "N/A";
  }


}
