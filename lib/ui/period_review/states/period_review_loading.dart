import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/util/period_review_helper.dart';

class PeriodReviewLoading extends StatelessWidget {
  PeriodReviewLoading({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    //Trigger a countdown to switch the page
    triggerNavSwitch();
    //Trigger the data calculations - these should easily complete within the timeframe
    PeriodReviewHelper.calculateReviewData(reviewController.reviewYear.value!); //Can assume non-null as button to open this page is disabled for a null year
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Just a tick while we crunch some numbers...",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 50,),
          LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 50)
        ],
      ),
    );
  }

  void triggerNavSwitch() {
    Future.delayed(const Duration(milliseconds: 8000), () {
      reviewController.updateReviewState(ReviewState.showResults);

    });

  }
}


