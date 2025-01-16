import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/model/watches.dart';

class ReviewController extends GetxController{
  final reviewState = ReviewState.selectParameters.obs;
  final isLastPage = false.obs;
  final reviewYear = 2023.obs;
  final firstWearInYear = DateTime.now().obs;
  final daysSinceFirstRecordInYear = 0.obs;
  final wearsInPeriod = 0.obs;
  final wearsInPeriodWatchList = <Watches>[].obs;
  final watchesBoughtInPeriod = <Watches>[].obs;
  final watchesSoldInPeriod = <Watches>[].obs;

  //Create a list of years
  List<String> yearList = [];
  populateYearList(){
    List<Watches> watches = Boxes.getAllWatches();
    List<String> calculatedYearList = [];
    for(Watches watch in watches){
      for(DateTime date in watch.wearList){
        if(!calculatedYearList.contains(date.year.toString())) {
          calculatedYearList.add(date.year.toString());
        };
      }
    }
    calculatedYearList.sort();
    this.yearList = calculatedYearList;
  }

  updateReviewState(ReviewState state){
    reviewState(state);
  }

  updateIsLastPage(bool lastPage){
    print("last page check: $lastPage");
    isLastPage(lastPage);
  }

  updateReviewYear(int year){
    reviewYear(year);
  }

  updateFirstWearInYear(DateTime firstWorn){
    firstWearInYear(firstWorn);
    if(reviewYear.value == DateTime.now().year){
      daysSinceFirstRecordInYear(DateTime.now().difference(firstWorn).inDays);
    }
    else{
      daysSinceFirstRecordInYear(DateTime(reviewYear.value, 12, 31).difference(firstWorn).inDays);
    }
  }

  updateWearsInPeriod(int count){
    wearsInPeriod(count);
  }

  updateWearsInPeriodWatchList(List<Watches> watchList){
    wearsInPeriodWatchList(watchList);
  }

  updateWatchesBoughtInPeriodList(List<Watches> purchaseList){
    watchesBoughtInPeriod(purchaseList);
  }

  updateWatchesSoldInPeriodList(List<Watches> soldList){
    watchesSoldInPeriod(soldList);
  }

}