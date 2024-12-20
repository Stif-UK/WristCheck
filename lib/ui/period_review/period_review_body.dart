import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/ui/StatsWidget.dart';
import 'package:wristcheck/ui/calendar/calendarhome.dart';
import 'package:wristcheck/ui/period_review/states/period_review_landing.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/ui/period_review/states/period_review_loading.dart';

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
      // TODO: Handle this case.
        break;
      case ReviewState.noData:
      // TODO: Handle this case.
        break;
      case ReviewState.loading:
        return PeriodReviewLoading();
        break;
      case ReviewState.showResults:
      // TODO: Handle this case.
        break;
      default:
        return PeriodReviewLanding();
    }
  }

}
