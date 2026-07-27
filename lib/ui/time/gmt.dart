import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';

class GMT extends StatelessWidget {
  const GMT({super.key});

  @override
  Widget build(BuildContext context) {
    final timeController = Get.find<TimeController>();
    return Center(
      child: Obx(
        () => Text(
          timeController.currentGMTtime.value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
