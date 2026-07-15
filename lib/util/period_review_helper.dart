import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/helper_classes.dart';

class PeriodReviewHelper{

  static void calculateReviewData(int year){
    final reviewController = Get.put(ReviewController());
    final watchBox = Boxes.getAllWatches();
    
    DateTime startDate = DateTime(year,1,1);
    DateTime endDate = DateTime(year, 12, 31);
    DateTime earliestWearInYear = DateTime(year, 12, 31);

    //Get List of watches worn in the given year
    List<WornWatchesClass> wornInPeriodWatchList = Boxes.getWatchesWornBetweenTwoDates(watchBox, startDate, endDate);

    //Set the filtered wear list of each watch - we can use this in further calculations
    for(WornWatchesClass worn in wornInPeriodWatchList){
      List<DateTime> yearWears = worn.watch.wearList.where((date) => date.year == year).toList();
      //Set earliest recorded wear date
      if(yearWears.isNotEmpty && yearWears.first.isBefore(earliestWearInYear)){
        earliestWearInYear = yearWears.first;
      }
    }

    reviewController.updateFirstWearInYear(earliestWearInYear);


    //Sort the list based on most to least worn in the year
    wornInPeriodWatchList.sort((a, b) => b.count.compareTo(a.count));

    //Calculate total wears in the year and pass to controller
    int count = 0;
    for(WornWatchesClass worn in wornInPeriodWatchList){
      count = count + worn.count;
    }
    reviewController.updateWearsInPeriod(count);

    //Pass list of watches to controller
    reviewController.updateWearsInPeriodWatchList(wornInPeriodWatchList);

    //Identify watches purchased and sold during the year
    List<Watches> purchaseList = List.from(Boxes.getAllWatches().where((watch) => watch.purchaseDate != null));
    purchaseList = purchaseList.where((watch) => watch.purchaseDate!.year == year).toList();
    reviewController.updateWatchesBoughtInPeriodList(purchaseList);

    List<Watches> soldList = List.from(Boxes.getAllWatches().where((watch) => watch.soldDate != null));
    soldList = soldList.where((watch) => watch.soldDate!.year == year).toList();
    reviewController.updateWatchesSoldInPeriodList(soldList);




  }


}