import 'package:hive/hive.dart';
import 'package:wristcheck/model/watches.dart';

class Boxes {
  static Box<Watches> getWatches() =>
    Hive.box<Watches>("WatchBox");

}