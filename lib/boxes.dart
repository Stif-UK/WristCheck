import 'package:hive/hive.dart';
import 'package:wristcheck/model/watches.dart';

class Boxes {
  static Box<Watches> getWatches() =>
    Hive.box<Watches>("WatchBox");

  static List<Watches> getAllWatches() {
    return Hive.box<Watches>("WatchBox").values.toList();
  }

  static List<Watches> getCollectionWatches() {
    return Hive.box<Watches>("WatchBox").values.where((Watches) => Watches.status == "In Collection").toList();
  }

  static List<Watches> getSoldWatches() {
    return Hive.box<Watches>("WatchBox").values.where((Watches) => Watches.status == "Sold").toList();
  }

  static List<Watches> getWishlistWatches() {
    return Hive.box<Watches>("WatchBox").values.where((Watches) => Watches.status == "Wishlist").toList();
  }



}