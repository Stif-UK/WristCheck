import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchMethods {

  //TODO: Update addWatch() to check for unique watch - watch already exists exception trigger dialog
  static Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status,
      DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval, String? notes){
    String m = manufacturer!;
    String mo = model!;
    String? sn = serialNumber;
    bool fv = favourite;
    String st = status;
    DateTime? pd = purchaseDate;
    DateTime? ls = lastServicedDate;
    int si = serviceInterval;
    String? n = notes;


    final watch = Watches()
      ..manufacturer = m.trim()
      ..model = mo.trim()
      ..serialNumber = sn
      ..favourite = fv
      ..status = st
      ..purchaseDate = pd
    ..lastServicedDate = ls
    ..serviceInterval = si
    ..nextServiceDue = calculateNextService(pd, ls, si)
    ..notes = n
    ..wearList = <DateTime>[];

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

  static _recordWear(Watches watch, DateTime date){
    //ToDo: Need to check for duplicates and gain acknowledgement to track the same date twice

    watch.wearList.add(date);
    watch.save();
    WristCheckSnackBars.addWearSnackbar(watch, date);

  }

  static attemptToRecordWear(Watches watch, DateTime date, bool acceptDuplicate) async {
    if(acceptDuplicate){
      _recordWear(watch, date);
      return true;
    } else {
      if(checkForDuplicateWear(watch, date)){
        //if there is a duplicate trigger a dialog
        WristCheckDialogs.getDuplicateWearDialog(watch, date);
      } else {
        _recordWear(watch, date);

      }
    }

  }

  static bool checkForDuplicateWear(Watches watch, DateTime date){
    if(watch.wearList ==null || watch.wearList.isEmpty){
      return false;
    }
    //check if the date already exists in our list
    var inputDate = WristCheckFormatter.getFormattedDate(date);

    for (var date2 in watch.wearList.reversed) {
      var selectedDate = WristCheckFormatter.getFormattedDate(date2);
      if(inputDate == selectedDate){
        print("These dates match: $inputDate ($date)& $selectedDate ($date2)");
        return true;
      }else{
        print("no matches found");
        return false;
      }

    }

    return false;


  }

}