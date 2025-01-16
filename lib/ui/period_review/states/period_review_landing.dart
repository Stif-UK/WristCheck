import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';

class PeriodReviewLanding extends StatelessWidget {
  PeriodReviewLanding({super.key});
  final reviewController = Get.put(ReviewController());
  final double padInsets = 20.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(padInsets),
            child: Text("Welcome to the WristTrack Wrist Recap!\n\n"
                "Here you can generate a summary of your wrist habits over a selected period.\n\n",
            style: Theme.of(context).textTheme.bodyLarge,),
          ),
          ElevatedButton(child: Text("Generate Wrist Recap"),
          onPressed: () =>reviewController.updateReviewState(ReviewState.loading),),
          Padding(
            padding: EdgeInsets.all(padInsets),
            child: Text("Note: This feature is currently in BETA and will be enhanced over time.\n\n"
                "Results can currently only be generated for years with at least 30 days of tracked wear.\n\n"
                "Please feel free to reach out with feedback!",
              style: Theme.of(context).textTheme.bodyMedium,),
          )
        ],
      ),
    );
  }
}
