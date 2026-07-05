import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/collection_movement_card.dart';

class CollectionMovement extends StatelessWidget {
  CollectionMovement({super.key});

  final recapController = Get.put(WristRecapMonthlyController());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Collection Movement",
                  style: Theme.of(context).textTheme.bodyLarge,),
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("${recapController.watchesBought.length} watches bought"),
                      Text("${recapController.watchesSold.length} watches sold"),
                      if (recapController.watchesBought.isNotEmpty || recapController.watchesSold.isNotEmpty) ...[
                        const SizedBox(height: 10,),
                        ...recapController.watchesBought.map((watch) => CollectionMovementCard(watch: watch)),
                        ...recapController.watchesSold.map((watch) => CollectionMovementCard(watch: watch)),
                      ],
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
    ),
    );
  }
}
