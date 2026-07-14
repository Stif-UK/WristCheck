import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class TimeSettingsBottomSheet extends StatelessWidget {
  TimeSettingsBottomSheet({Key? key}) : super(key: key);
  final timeController = Get.find<TimeController>();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.timeSettingsTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          Obx(() => SwitchListTile(
                title: Text(AppLocalizations.of(context)!.beepCountdown),
                value: timeController.enableBeep.value,
                onChanged: (beep) {
                  analytics.logEvent(name: "enablebeep", parameters: {"beep": beep});
                  timeController.updateBeepSetting(beep);
                },
              )),
          Obx(() => SwitchListTile(
                title: Text(AppLocalizations.of(context)!.timeFormat),
                value: timeController.militaryTime.value,
                onChanged: (mt) {
                  analytics.logEvent(name: "enable24hrtime", parameters: {"24hr": mt});
                  timeController.updateMilitaryTime(mt);
                },
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
