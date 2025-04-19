import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:in_app_review/in_app_review.dart';

class WatchMethods {

  static Future addWatch(String? manufacturer, String? model, String? serialNumber, bool favourite, String status,
      DateTime? purchaseDate, DateTime? lastServicedDate, int serviceInterval, String? notes, String? referenceNumber, String? movement,
      String? category, String? purchasedFrom, String soldTo, int? purchasePrice, int? soldPrice, DateTime? soldDate, DateTime? deliveryDate, DateTime? warrantyEndDate,
      double? caseDiameter, int? lugWidth, double? lug2lug, double? caseThickness, int? waterResistance, String? caseMaterial, int? winderTPD, String? winderDirection,
      String? dateComplication){
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
    String? cat = category;
    String? pf = purchasedFrom;
    String? sold = soldTo;
    int? pp = purchasePrice;
    int? sp = soldPrice;
    DateTime? sd = soldDate;
    DateTime? dd = deliveryDate;
    DateTime? wed = warrantyEndDate;
    double? diameter = caseDiameter;
    int? lw = lugWidth;
    double? l2l = lug2lug;
    double? thickness = caseThickness;
    int? wr = waterResistance;
    String? cr = caseMaterial;
    int? wtpd = winderTPD;
    String? windDir = winderDirection;
    String? date = dateComplication;




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
    ..movement = mvmt
    ..category = cat
    ..purchasedFrom = pf
    ..soldTo = sold
    ..purchasePrice = pp
    ..soldPrice = sp
    ..soldDate = sd
    ..deliveryDate = dd
    ..warrantyEndDate = wed
    ..caseDiameter = diameter
    ..lugWidth = lw
    ..lug2lug = l2l
    ..caseThickness = thickness
    ..waterResistance = wr
    ..caseMaterial = cr
    ..winderTPD = wtpd
    ..winderDirection = windDir
    ..dateComplication = date;

    final box = Boxes.getWatches();
    return box.add(watch);
  }

  static void removeWearDate(DateTime dateToRemove, Watches watch){
    //Get the wearList index of the current date
    try {
      int index = watch.wearList.indexWhere((element) {
        return element.day == dateToRemove.day && element.month == dateToRemove.month && element.year == dateToRemove.year;
      });
      print(index);
      DateTime removed = watch.wearList.removeAt(index);
      watch.save();
      WristCheckSnackBars.removeWearSnackbar(watch, removed);
    } on Exception catch (e) {
      WristCheckDialogs.getGeneralErrorDialog(e);
    }
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

  static _recordWear(Watches watch, DateTime date) async {
    if(!date.isAfter(DateTime.now())){
      watch.wearList.add(date);
      watch.save();
      //increment the lifetime tracked wear count
      int? _wearCount = WristCheckPreferences.getWearCount();
      _wearCount == null? WristCheckPreferences.setWearCount(1) : WristCheckPreferences.setWearCount(_wearCount+1);
      //Trigger a snackbar
      WristCheckSnackBars.addWearSnackbar(watch, date);
      final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      analytics.logEvent(name: "wear_tracked");
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
    if (orderedByWearCount.isNotEmpty) {
      most? comparable = orderedByWearCount.last.wearList.length : comparable = orderedByWearCount.first.wearList.length;
    }

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

  static double calculateCostPerWear(Watches currentWatch){
    int wearCount = currentWatch.wearList.length;
    int purchasePrice = currentWatch.purchasePrice ?? 0;
    if(currentWatch.status == "Sold" && currentWatch.soldPrice != null){
      if(currentWatch.soldPrice! > 0){
        purchasePrice = purchasePrice - currentWatch.soldPrice!;
      }
    }
    double returnValue = 0.0;
    if(wearCount != 0 && purchasePrice != 0){
      returnValue = purchasePrice/wearCount;
    }
    return returnValue;
  }

  static int calculateCollectionCost(bool getAll){
    List<Watches> collection = Boxes.getCollectionWatches();
    getAll? collection.addAll(Boxes.getSoldWatches()): null;
    int value = 0;
    for(var watch in collection){
      if(watch.purchasePrice != null){
        value = value + watch.purchasePrice!;
      }
    }
    return value;
  }

  static int calculateSoldIncome(){
    List<Watches> soldWatches = Boxes.getSoldWatches();
    int value = 0;
    for(var watch in soldWatches){
      if(watch.soldPrice != null){
        value = value + watch.soldPrice!;
      }
    }
    return value;
  }

  static int calculateResaleRatio(){
    List<Watches> soldWatches = Boxes.getSoldWatches();
    int purchaseTotal = 0;
    int soldTotal = 0;
    for(var watch in soldWatches){
      if(watch.purchasePrice != null && watch.purchasePrice != 0 && watch.soldPrice != null && watch.soldPrice != 0){
        purchaseTotal = purchaseTotal + watch.purchasePrice!;
        soldTotal = soldTotal + watch.soldPrice!;
      }
    }
    if(purchaseTotal == 0 || soldTotal == 0){
      return 0;
    }

    return ((soldTotal/purchaseTotal)*100).floor();
  }

  static String calculateTimeInCollection(Watches currentWatch, bool showDays){
    String timeInCollection = "N/A";
    Duration time = const Duration(days:0);
    if(currentWatch.purchaseDate != null){

      time = currentWatch.soldDate != null? currentWatch.soldDate!.difference(currentWatch.purchaseDate!): DateTime.now().difference(currentWatch.purchaseDate!);
      int timeInt = time.inDays;
      timeInCollection = "$timeInt days";
      if (!showDays) {
        if(timeInt > 90){timeInCollection = "3+ months";}
        if(timeInt > 180){timeInCollection = "6+ months";}
        if(timeInt > 270){timeInCollection = "9+ months";}
        if(timeInt > 365){
          var years = Jiffy.now().diff(Jiffy.parseFromDateTime(currentWatch.purchaseDate!), unit: Unit.year);
          timeInCollection = "$years+ years";
        }
      }

    }

    return timeInCollection;
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