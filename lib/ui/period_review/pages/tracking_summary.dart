import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/ui/period_review/widgets/review_page.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ReviewTrackingSummary extends StatelessWidget {
  ReviewTrackingSummary({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return ReviewPage(
      colour: Theme.of(context).canvasColor,
      title: "Wears Tracked",
      subtitle1:"In ${reviewController.reviewYear.value} you tracked what was on your wrist",
      subtitleBig1: "${reviewController.wearsInPeriod.value} times",
      subtitle2: "(that's ${(reviewController.wearsInPeriod.value/365).toStringAsFixed(2)} times per day since the first entry on ${WristCheckFormatter.getFormattedDate(reviewController.firstWearInYear.value)}!)",
    );
  }
}
