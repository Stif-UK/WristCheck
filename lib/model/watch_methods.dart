import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';

class WatchMethods {

  static Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status, DateTime? purchaseDate){
    String m = manufacturer!;
    String mo = model!;
    String? sn = serialNumber;
    bool fv = favourite;
    String st = status;
    DateTime? pd = purchaseDate;


    final watch = Watches()
      ..manufacturer = m
      ..model = mo
      ..serialNumber = sn
      ..favourite = fv
      ..status = st
      ..purchaseDate = pd;

    final box = Boxes.getWatches();

    return box.add(watch);

  }

}