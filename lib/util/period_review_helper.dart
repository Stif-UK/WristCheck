import 'package:wristcheck/boxes.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/review_controller.dart';
import 'package:wristcheck/model/watches.dart';

class PeriodReviewHelper{

  static void calculateReviewData(int year){
    final reviewController = Get.put(ReviewController());
    final watchBox = Boxes.getAllWatches();
    
    DateTime startDate = DateTime(year,1,1);
    DateTime endDate = DateTime(year, 12, 31);
    DateTime earliestWearInYear = DateTime(year, 12, 31);

    //Get List of watches worn in the given year
    List<Watches> wornInPeriodWatchList = Boxes.getWatchesWornBetweenTwoDates(watchBox, startDate, endDate);

    //Set the filtered wear list of each watch - we can use this in further calculations
    for(Watches watch in wornInPeriodWatchList){
      //Fill the filtered list
      watch.filteredWearList = List.from(watch.wearList);
      //Remove anything not from the given year
      watch.filteredWearList!.removeWhere((date) => date.year != year);
      //Set earliest recorded wear date
      if(watch.filteredWearList!.first.isBefore(earliestWearInYear)){
        earliestWearInYear = watch.filteredWearList!.first;
      }
    }

    reviewController.updateFirstWearInYear(earliestWearInYear);


    //Sort the list based on most to least worn in the year
    wornInPeriodWatchList.sort((a, b) => b.filteredWearList!.length.compareTo(a.filteredWearList!.length));

    //Calculate total wears in the year and pass to controller
    int count = 0;
    for(Watches watch in wornInPeriodWatchList){
      count = count + watch.filteredWearList!.length;
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