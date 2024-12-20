import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';

class PeriodReviewLanding extends StatelessWidget {
  PeriodReviewLanding({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Landing"),
        ElevatedButton(child: Text("submit"),
        onPressed: () =>reviewController.updateReviewState(ReviewState.loading),)
      ],
    );
  }
}
