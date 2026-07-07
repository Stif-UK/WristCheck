import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/worn_watch_card.dart';

class WatchesWornCarousel extends StatelessWidget {
  WatchesWornCarousel({super.key});

  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
        AppLocalizations.of(context)!.watchesWornTitle,
        style: Theme.of(context).textTheme.bodyLarge,
            ),
      ),
    SizedBox(
    height: 250,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: recapController.watchesWorn.length,
    itemBuilder: (context, index) {
    final wornWatch = recapController.watchesWorn[index];
    return WornWatchCard(wornWatch: wornWatch);
    },
    ),
    ),
      ],
    );
  }
}
