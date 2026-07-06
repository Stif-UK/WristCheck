import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/worn_watch_card.dart';

class WatchesWornCarousel extends StatelessWidget {
  WatchesWornCarousel({super.key});

  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Text(
      "Watches worn:",
      style: Theme.of(context).textTheme.bodyLarge,
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
