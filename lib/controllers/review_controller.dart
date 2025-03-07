import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/review_state.dart';
import 'package:wristcheck/model/watches.dart';

class ReviewController extends GetxController{
  final minimumRecords = 30;
  final reviewState = ReviewState.selectParameters.obs;
  final isLastPage = false.obs;
  final reviewYear = Rxn<int>();
  final firstWearInYear = DateTime.now().obs;
  final daysSinceFirstRecordInYear = 0.obs;
  final wearsInPeriod = 0.obs;
  final wearsInPeriodWatchList = <Watches>[].obs;
  final watchesBoughtInPeriod = <Watches>[].obs;
  final watchesSoldInPeriod = <Watches>[].obs;

  //Create a list of years
  List<int> yearList = [];
  populateYearList(){
    List<Watches> watches = Boxes.getAllWatches();
    List<int> calculatedYearList = [];
    for(Watches watch in watches){
      for(DateTime date in watch.wearList){
        if(!calculatedYearList.contains(date.year)) {
          calculatedYearList.add(date.year);
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
      daysSinceFirstRecordInYear(DateTime(reviewYear.value!, 12, 31).difference(firstWorn).inDays);
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