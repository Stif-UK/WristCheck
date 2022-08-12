import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:jiffy/jiffy.dart';

class WatchMethods {

  static Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status,
      DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval){
    String m = manufacturer!;
    String mo = model!;
    String? sn = serialNumber;
    bool fv = favourite;
    String st = status;
    DateTime? pd = purchaseDate;
    DateTime? ls = lastServicedDate;
    int si = serviceInterval;


    final watch = Watches()
      ..manufacturer = m
      ..model = mo
      ..serialNumber = sn
      ..favourite = fv
      ..status = st
      ..purchaseDate = pd
    ..lastServicedDate = ls
    ..serviceInterval = si
    ..nextServiceDue = calculateNextService(pd, ls, si);

    final box = Boxes.getWatches();

    return box.add(watch);

  }

  static DateTime? calculateNextService(DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval){

    DateTime? nextServiceDate;

    if(serviceInterval == 0){
      return null;
    } else if (lastServicedDate != null){
      return Jiffy(lastServicedDate).add(years: serviceInterval).dateTime;
    } else{
      purchaseDate == null? nextServiceDate = null : nextServiceDate = Jiffy(purchaseDate).add(years: serviceInterval).dateTime;
      return nextServiceDate;
    }


  }

}