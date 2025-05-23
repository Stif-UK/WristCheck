import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/ui/period_review/states/period_review_empty.dart';
import 'package:wristcheck/ui/period_review/states/period_review_landing.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/period_review/states/period_review_loading.dart';
import 'package:wristcheck/ui/period_review/states/period_review_results.dart';

class PeriodReviewBody extends StatelessWidget {
  PeriodReviewBody({super.key});
  final reviewController = Get.put(ReviewController());


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(()=> getBody())
    );

  }

  getBody() {
    switch(reviewController.reviewState.value){
      case ReviewState.selectParameters:
        return PeriodReviewLanding();
        break;
      case ReviewState.empty:
        return PeriodReviewEmpty();
        break;
      case ReviewState.noData:
      // TODO: Handle this case.
        break;
      case ReviewState.loading:
        return PeriodReviewLoading();
        break;
      case ReviewState.showResults:
        return PeriodReviewResults();
        break;
      default:
        return PeriodReviewLanding();
    }
  }

}
