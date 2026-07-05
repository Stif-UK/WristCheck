import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/helper_classes.dart';

class WristRecapMonthlyController extends GetxController{
  final month = 1.obs;
  final year = 2025.obs;
  final watchesWorn = <WornWatchesClass>[].obs;
  final watchesBought = <Watches>[].obs;
  final watchesSold = <Watches>[].obs;
  final isLastMonth = false.obs;

  //Step 1. Get all watches worn in the month
  //Step 2. Get all
  
  updateMonth(int monthInt){
    month(monthInt);
  }
  
  updateYear(int yearInt){
    year(yearInt);
  }

  updateWatchesWorn(List<WornWatchesClass> watchList){
    watchesWorn(watchList);
  }

  updateWatchesBought(List<Watches> watchList){
    watchesBought(watchList);
  }

  updateWatchesSold(List<Watches> watchList){
    watchesSold(watchList);
  }

  generateWornWatchesDate(int wearMonth, int wearYear){
    List<WornWatchesClass> wearList = [];
    //Get all watches during period
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), wearMonth, wearYear);
    //For each watch create a WornWatches object with the watch and its wear count
    for(Watches watch in watchList){
        List<DateTime> wornDates = watch.wearList
            .where(
                (date) => date.month == month.value && date.year == year.value)
            .toList();

        int count = wornDates.length;
        WornWatchesClass watchData = WornWatchesClass(watch, count);
        //Only track data for watches that have been worn
        if (count > 0) wearList.add(watchData);
    }
    //Order the list - descending count
    if(wearList.isNotEmpty) wearList.sort((a, b) => b.count.compareTo(a.count));
    //Get total count
    int totalCount = 0;
    for(WornWatchesClass watch in wearList){
      totalCount = totalCount + watch.count;
    }
    //Set percentage for each watch
    for(WornWatchesClass watch in wearList){
      watch.setPercentage("${((watch.count / totalCount)*100).toStringAsFixed(1)} %");
    }
    //Update the controller value
    watchesWorn(wearList);
    
  }
  
  generateWatchesSold(){
    List<Watches> soldWatches = [];
    soldWatches = Boxes.getSoldWatches();
    soldWatches.removeWhere((watch) => watch.soldDate == null );
    soldWatches = soldWatches.where((watch) => watch.soldDate!.month == month.value && watch.soldDate!.year == year.value).toList();
    watchesSold(soldWatches);
  }

  generateWatchesPurchased(){
    List<Watches> purchasedWatches = [];
    purchasedWatches = Boxes.getAllNonArchivedWatches();
    purchasedWatches.removeWhere((watch) => watch.purchaseDate == null);
    purchasedWatches = purchasedWatches.where((watch) => watch.purchaseDate!.month == month.value && watch.purchaseDate!.year == year.value).toList();
  }

  checkIsLastMonth(){
    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month-1);
    isLastMonth(lastMonth.month == month.value && lastMonth.year == year.value);
  }

  incrementMonth() {
    DateTime newDate = DateTime(year.value, month.value + 1);
    month(newDate.month);
    year(newDate.year);
    //Retrigger the data generation and check if this is 'last month'
    refresh();
  }

  decrementMonth() {
    DateTime newDate = DateTime(year.value, month.value - 1);
    month(newDate.month);
    year(newDate.year);
    //Retrigger the data generation and check if this is 'last month'
    refresh();
  }

  refresh(){
    generateWornWatchesDate(month.value, year.value);
    checkIsLastMonth();
    generateWatchesSold();
    generateWatchesPurchased();
  }

}