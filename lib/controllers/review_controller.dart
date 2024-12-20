import 'package:get/get.dart';
import 'package:wristcheck/model/enums/review_state.dart';

class ReviewController extends GetxController{
  final reviewState = ReviewState.selectParameters.obs;

  updateReviewState(ReviewState state){
    reviewState(state);
  }

}