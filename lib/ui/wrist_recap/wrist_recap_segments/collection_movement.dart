import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Collection Movement"),
            Text("${recapController.watchesSold.length} watches sold"),

          ],
        ),
      ),
    );
  }
}
