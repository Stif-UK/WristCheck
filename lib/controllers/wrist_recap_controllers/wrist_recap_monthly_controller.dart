import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/helper_classes.dart';

class WristRecapMonthlyController extends GetxController{
  final month = 1.obs;
  final year = 2025.obs;
  final watchesWorn = <WornWatchesClass>[].obs;
  final watchesBought = <Watches>[].obs;
  final watchesSold = <Watches>[].obs;

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
    //1. Get all watches during period
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllWatches(), wearMonth, wearYear);

    //2. For each watch create a WornWatches object with the watch and its wear count
    for(Watches watch in watchList){
      List<DateTime> wornDates = watch.wearList.where((date) => date.month == month.value && date.year == year.value)
          .toList();
      print(wornDates);
      int count = wornDates.length;
      WornWatchesClass watchData = WornWatchesClass(watch, count);
      wearList.add(watchData);
    }
    //3. Order the list - descending count
    if(wearList.isNotEmpty) wearList.sort((a, b) => b.count.compareTo(a.count));

    //4. Update the controller value
    watchesWorn(wearList);


  }

}