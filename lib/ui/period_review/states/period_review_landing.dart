import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';

class PeriodReviewLanding extends StatelessWidget {
  PeriodReviewLanding({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Welcome to the WristTrack Wrist Recap!\n\n"
                "Here you can generate a summary of your wrist habits over a selected period.\n\n",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          ElevatedButton(child: Text("Generate 2024 Wrist Recap"),
          onPressed: () =>reviewController.updateReviewState(ReviewState.loading),)
        ],
      ),
    );
  }
}
