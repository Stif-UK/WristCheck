import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';

class PeriodReviewResults extends StatelessWidget {
  PeriodReviewResults({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(()=> Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(title: Text("In ${reviewController.reviewYear} you tracked what you were wearing ${reviewController.wearsInPeriod.value} times"),),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: const Divider(thickness: 2,),
        )
      ],
    );
  }
}
