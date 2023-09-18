import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:in_app_review/in_app_review.dart';

class WatchMethods {

  static Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status,
      DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval, String? notes, String? referenceNumber, String? movement){
    String m = manufacturer!;
    String mo = model!;
    String? sn = serialNumber;
    bool fv = favourite;
    String st = status;
    DateTime? pd = purchaseDate;
    DateTime? ls = lastServicedDate;
    int si = serviceInterval;
    String? n = notes;
    String? rn = referenceNumber;
    String? mvmt = movement;


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
    ..wearList = <DateTime>[]
    ..filteredWearList = <DateTime>[]
    ..frontImagePath = ""
    ..backImagePath = ""
    ..referenceNumber = rn
    ..movement = mvmt;


    final box = Boxes.getWatches();

    return box.add(watch);

  }

  static DateTime? calculateNextService(DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval){

    DateTime? nextServiceDate;

    if(serviceInterval == 0){
      return null;
    } else if (lastServicedDate != null){
      return Jiffy.parseFromDateTime(lastServicedDate).add(years: serviceInterval).dateTime;
    } else{
      purchaseDate == null? nextServiceDate = null : nextServiceDate = Jiffy.parseFromDateTime(purchaseDate).add(years: serviceInterval).dateTime;
      return nextServiceDate;
    }


  }

  static _recordWear(Watches watch, DateTime date){
    if(!date.isAfter(DateTime.now())){
      watch.wearList.add(date);
      watch.save();
      //increment the lifetime tracked wear count
      int? _wearCount = WristCheckPreferences.getWearCount();
      _wearCount == null? WristCheckPreferences.setWearCount(1) : WristCheckPreferences.setWearCount(_wearCount+1);
      //Trigger a snackbar
      WristCheckSnackBars.addWearSnackbar(watch, date);
      //Check if an app review should be prompted
      appReviewCheck();
    } else{
      WristCheckDialogs.getFutureDateDialog();
    }

  }

  static Future<void> attemptToRecordWear(Watches watch, DateTime date, bool acceptDuplicate) async {
    if(acceptDuplicate){
      _recordWear(watch, date);
    } else {
      if(checkForDuplicateWear(watch, date)){
        //if there is a duplicate trigger a dialog
        await WristCheckDialogs.getDuplicateWearDialog(watch, date);
      } else {
        _recordWear(watch, date);

      }
    }

  }

  static bool checkForDuplicateWear(Watches watch, DateTime date){
    if(watch.wearList == null || watch.wearList.isEmpty){
      return false;
    }
    //check if the date already exists in our list
    var inputDate = WristCheckFormatter.getFormattedDate(date);

    for (var date2 in watch.wearList.reversed) {
      var selectedDate = WristCheckFormatter.getFormattedDate(date2);
      if(inputDate == selectedDate){
        return true;
      }else{
        return false;
      }

    }
    return false;
  }


  static Watches? getOldestorNewestWatch(List<Watches> watchBox, bool oldest){
    List<Watches> datedWatches = watchBox.where((watch) => watch.purchaseDate != null).toList();
    if(datedWatches.isEmpty ){
      return null;
    }
    datedWatches.sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));

    return oldest? datedWatches.last : datedWatches.first;



  }

  static List<Watches> getMostOrLeastWornWatch(List<Watches> watchBox, bool most){
    //create a copy list to sort and iterate over
    List<Watches> orderedByWearCount = List.from(watchBox);
    orderedByWearCount.sort((a, b) => a.wearList.length.compareTo(b.wearList.length));


    //get the wear count of the last watch in the ordered collection
    int comparable = 0;
    most? comparable = orderedByWearCount.last.wearList.length : comparable = orderedByWearCount.first.wearList.length;

    // int longest = orderedByWearCount.last.wearList.length;
    // int shortest = orderedByWearCount.first.wearList.length;
    //create a list to return
    List<Watches> returnlist = [];
    //now check if any other watches have been worn the same amount of times - if so add them to the list
    for (var watch in orderedByWearCount) {
      if(watch.wearList.length == comparable){
        returnlist.add(watch);
      }

    }
    return returnlist;
  }

  /*
  appReviewCheck() performs some tests to validate app usage and duration since the app last triggered
  an app review prompt.
  Initially this is app opened 10+ times, watches worn 5+ times and 10 days past the set reference date
  which is initialised on first app opening.
  If an app review is prompted then the reference date is set to 3 months in the future
   */
  static appReviewCheck() async {
    final InAppReview inAppReview = InAppReview.instance;
    int openCount = WristCheckPreferences.getOpenCount() ?? 0;
    int wearCount = WristCheckPreferences.getWearCount() ?? 0;
    DateTime? refDate = WristCheckPreferences.getReferenceDate() ?? DateTime.now();

    bool openEnough = openCount > 10;
    bool wearEnough = wearCount > 5;
    bool dateCheck = DateTime.now().difference(refDate) > const Duration(days: 10);

    print("appReviewCheck called: $openEnough, $wearEnough, $dateCheck");


    if(openEnough && wearEnough && dateCheck){
      if(await inAppReview.isAvailable()){
        inAppReview.requestReview();
        //After calling requestReview() set a new Reference Date, 3 months in the future
        var now = DateTime.now();
        WristCheckPreferences.setReferenceDate(DateTime(now.year, now.month +3, now.day));
      }
    }

  }


}