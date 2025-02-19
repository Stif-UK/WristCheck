import 'package:flutter/material.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/ui/period_review/widgets/review_page.dart';
import 'package:get/get.dart';

class CollectionGrowth extends StatelessWidget {
  CollectionGrowth({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    int sales = reviewController.watchesSoldInPeriod.length;
    int purchases = reviewController.watchesBoughtInPeriod.length;
    int difference = purchases - sales;
    String title = "";

    switch (difference) {
      case 0:
        title = "Your Collection size was static in ${reviewController.reviewYear}!";
        break;
      default:
        if (difference > 0) {
          title = "Your Collection Grew in ${reviewController.reviewYear}!";
        } else {
          title = "Your Collection Shrank in ${reviewController.reviewYear}!"; // Negate for positive output
        }
    }

    return ReviewPage(
      colour: Theme.of(Get.context!).canvasColor,
      title: title,
      subtitle1: "You tracked ${reviewController.watchesBoughtInPeriod.length} purchases",
      subtitle2: "and ${reviewController.watchesSoldInPeriod.length} sales!",);
  }
}
