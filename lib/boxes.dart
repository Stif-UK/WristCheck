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
  
  static List<Watches> getWatchesWornThisYear(int year){
    var returnList = Hive.box<Watches>("WatchBox").values.where((watch) => watch.wearList.any((element) => element.year == year)).toList();
    return returnList;

  }

  static List<Watches>  getFilteredWatches(String filter){
    switch (filter) {
      case "Show All":
        {
          print("Received $filter, returning all watches");
          return Boxes.getAllWatches();
        }
        break;
      case "In Collection":
        {
          print("Received $filter, returning collection watches");
          return Boxes.getCollectionWatches();
        }
        break;
      case "Sold":
        {
          print("Received $filter, returning sold watches");
          return Boxes.getSoldWatches();
        }
        break;
      case "Wishlist":
        {
          print("Received $filter, returning wishlist watches");
          return Boxes.getWishlistWatches();
        }
        break;
      default:
        {
          print("Received $filter, returning default");
          return Boxes.getAllWatches();
        }
        break;
    };
  }



}