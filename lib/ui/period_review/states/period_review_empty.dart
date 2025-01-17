import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/util/period_review_helper.dart';

class PeriodReviewEmpty extends StatelessWidget {
  PeriodReviewEmpty({super.key});
  final reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("There isn't enough data...",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Icon(FontAwesomeIcons.batteryQuarter, size: 40,),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("You haven't tracked enough data to generate a Wrist Recap for ${reviewController.reviewYear}.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,),
          ),
          Text("A minimum of ${reviewController.minimumRecords} wear records are required for the year to generate a report.",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}


