import 'package:hive/hive.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:jiffy/jiffy.dart';

class Boxes {
  static Box<Watches> getWatches() =>
    Hive.box<Watches>("WatchBox");

  static List<Watches> getAllWatches() {
    return Hive.box<Watches>("WatchBox").values.toList();
  }

  static List<Watches> getCollectionWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == "In Collection").toList();
  }

  static List<Watches> getSoldWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == "Sold").toList();
  }

  static List<Watches> getWishlistWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == "Wishlist").toList();
  }

  static List<Watches> getFavouriteWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.favourite == true && watch.status != "Sold").toList();
  }

  static List<Watches> getServiceSchedule(){
    var returnList = Hive.box<Watches>("WatchBox").values.where((watch) => watch.nextServiceDue != null && watch.status == "In Collection").toList();
    returnList.sort((a, b) => a.nextServiceDue!.compareTo(b.nextServiceDue!));
    return returnList;
  }
  
  static List<Watches> getWatchesWornFilter(int? month, int? year){
    //start by making the return list the whole box
      var returnList = Hive.box<Watches>("WatchBox").values.toList();
    //if a year is provided, then reduce returnList to only those watches that have the year in their wearlist
    if(year != null){
      returnList = returnList.where((watch) => watch.wearList.any((element) => element.year == year)).toList();
    }
    //next if a month is provided, then further reduce list to only those months
      if(month != null){
        returnList = returnList.where((watch) => watch.wearList.any((element) => element.month == month)).toList();
      }

      //We now have a filtered list, so within that list we now need to filter the watches filteredWearList variable
     //To begin we make sure that the filteredWearList is instantiated with the full list of dates
      for (var watch in returnList) {
        watch.filteredWearList = List.from(watch.wearList);
      }
      //We then trim the years
    if(year != null){
      for (var watch in returnList) {
        //instantiate an empty list in the watches filteredWearList variable

        watch.filteredWearList!.removeWhere((date) => date.year != year);
      }
    }
    //and next trim the months
      if(month != null){
        for (var watch in returnList) {
          //instantiate an empty list in the watches filteredWearList variable
          watch.filteredWearList!.removeWhere((date) => date.month != month);
        }
      }
    //finally we return this result
    return returnList;

  }

  // static List<Watches>  getFilteredWatches(String filter){
  //   switch (filter) {
  //     case "Show All":
  //       {
  //         print("Received $filter, returning all watches");
  //         return Boxes.getAllWatches();
  //       }
  //       break;
  //     case "In Collection":
  //       {
  //         print("Received $filter, returning collection watches");
  //         return Boxes.getCollectionWatches();
  //       }
  //       break;
  //     case "Sold":
  //       {
  //         print("Received $filter, returning sold watches");
  //         return Boxes.getSoldWatches();
  //       }
  //       break;
  //     case "Wishlist":
  //       {
  //         print("Received $filter, returning wishlist watches");
  //         return Boxes.getWishlistWatches();
  //       }
  //       break;
  //     default:
  //       {
  //         print("Received $filter, returning default");
  //         return Boxes.getAllWatches();
  //       }
  //       break;
  //   };
  // }



}