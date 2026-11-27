import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:wristcheck/sync/sync_service.dart';
import 'package:hive_ce/hive.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/images_util.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:in_app_review/in_app_review.dart';

class WatchMethods {

  static Future addWatch(
    String manufacturer,
    String model, {
    String? serialNumber,
    bool favourite = false,
    String? status,
    DateTime? purchaseDate,
    DateTime? lastServicedDate,
    int serviceInterval = 0,
    String? notes,
    String? referenceNumber,
    String? movement,
    String? category,
    String? purchasedFrom,
    String? soldTo,
    int? purchasePrice,
    int? soldPrice,
    DateTime? soldDate,
    DateTime? deliveryDate,
    DateTime? warrantyEndDate,
    double? caseDiameter,
    int? lugWidth,
    double? lug2lug,
    double? caseThickness,
    int? waterResistance,
    String? caseMaterial,
    int? winderTPD,
    String? winderDirection,
    String? dateComplication,
    int? year,
    int? weight,
    int? winderTPDmax,
    int? value,
    String? primaryColour,
    String? secondaryColour,
    int? powerReserve,
    String? crystal,
    String? crown,
    List<DateTime>? wearList,
    bool triggerSync = true,
  }) async {
    String m = manufacturer;
    String mo = model;
    String? sn = serialNumber;
    bool fv = favourite;
    String? st = status;
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
    int? y = year;
    int? w = weight;
    int? wtpdmax = winderTPDmax;
    int? val = value;
    String? pCol = primaryColour;
    String? sCol = secondaryColour;
    int? pr = powerReserve;
    String? cry = crystal;
    String? crn = crown;

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
      ..wearList = wearList != null ? List<DateTime>.from(wearList) : <DateTime>[]
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
      ..dateComplication = date
      ..lumeImagePath = ""
      ..primaryImageIndex = 0
      ..year = y
      ..weight = w
      ..winderTPDmax = wtpdmax
      ..value = val
      ..primaryColour = pCol
      ..secondaryColour = sCol
      ..powerReserve = pr
      ..crystal = cry
      ..crown = crn;


    watch.ensureInitialized();
    watch.updatedAt = DateTime.now().toUtc();
    watch.isDirty = true;
    final box = Boxes.getWatches();
    final result = await box.add(watch);
    if (triggerSync) {
      unawaited(SyncService.syncData());
    }
    return result;
  }

  static Future<bool> archiveWatch(Watches watch) async{
    watch.ensureInitialized();
    watch.status = WatchStatusEnum.archived.toDbString();
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    unawaited(SyncService.syncData());
    return true;
  }

  static Future<void> deleteWatch(Watches watch) async{
    //Get the databases
    final Box watchbox = Boxes.getWatches();
    final Box<Measurement> measurements = Boxes.getMeasurements();
    //1.Delete associated images
    ImagesUtil.deleteImages(watch);
    //2. Delete any associated Measurement records
    List<Measurement> recordList = measurements.values.where((record) => record.watchKey == watch.key).toList();
    for(Measurement record in recordList){
      measurements.delete(record.key);
    }
    //3. Soft delete for cloud sync, then delete locally
    watch.ensureInitialized();
    watch.isDeleted = true;
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    await SyncService.syncData();

    //4. Delete the watch locally
    watchbox.delete(watch.key);
  }

  static void updateStatus(Watches watch, String status) async {
    watch.ensureInitialized();
    watch.status = status;
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    unawaited(SyncService.syncData());
  }

  static void setPrimaryImage(Watches watch, int index) async {
    watch.ensureInitialized();
    watch.primaryImageIndex = index;
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    unawaited(SyncService.syncData());
  }

  /*
  Returns all non-archived watches matching the given Manufacturer and Model (case-insensitive, trimmed).
   */
  static List<Watches> findDuplicateWatches(String manufacturer, String model) {
    final normMake = manufacturer.trim().toLowerCase();
    final normModel = model.trim().toLowerCase();
    if (normMake.isEmpty || normModel.isEmpty) return [];

    final List<Watches> collection = Boxes.getAllNonArchivedWatches();
    return collection.where((c) {
      return c.manufacturer.trim().toLowerCase() == normMake &&
          c.model.trim().toLowerCase() == normModel;
    }).toList();
  }

  /*
  Returns true if a watch already exists with the same values for Manufacturer and Model
   */
  static bool checkForDuplicate(String manufacturer, String model) {
    return findDuplicateWatches(manufacturer, model).isNotEmpty;
  }

  static bool _isEmptyStringField(String? value) {
    if (value == null) return true;
    final trimmed = value.trim();
    return trimmed.isEmpty ||
        trimmed == 'Not Selected' ||
        trimmed == 'Not Entered';
  }

  /// Merges an [ImportWatchCandidate] into an [existing] watch record.
  /// When [overwriteExisting] is false, only blank/missing fields are filled.
  /// Wear dates are always appended without creating same-day duplicates or future dates.
  /// Returns the number of newly added wear dates.
  static Future<int> mergeWatchFromImport(
    Watches existing,
    ImportWatchCandidate candidate, {
    required bool overwriteExisting,
    bool triggerSync = false,
  }) async {
    String? pickString(String? current, String? incoming) {
      if (incoming == null || _isEmptyStringField(incoming)) return current;
      if (overwriteExisting || _isEmptyStringField(current)) {
        return incoming.trim();
      }
      return current;
    }

    T? pickValue<T>(T? current, T? incoming) {
      if (incoming == null) return current;
      if (overwriteExisting || current == null) return incoming;
      return current;
    }

    int? pickPositiveInt(int? current, int? incoming) {
      if (incoming == null) return current;
      if (overwriteExisting || current == null || current == 0) return incoming;
      return current;
    }

    existing.status = pickString(existing.status, candidate.status);
    existing.category = pickString(existing.category, candidate.category);
    existing.movement = pickString(existing.movement, candidate.movement);
    existing.primaryColour = pickString(existing.primaryColour, candidate.primaryColour);
    existing.secondaryColour = pickString(existing.secondaryColour, candidate.secondaryColour);
    existing.serialNumber = pickString(existing.serialNumber, candidate.serialNumber);
    existing.referenceNumber = pickString(existing.referenceNumber, candidate.referenceNumber);
    existing.dateComplication = pickString(existing.dateComplication, candidate.dateComplication);
    existing.year = pickValue<int>(existing.year, candidate.year);
    existing.warrantyEndDate = pickValue<DateTime>(existing.warrantyEndDate, candidate.warrantyEndDate);
    existing.lastServicedDate = pickValue<DateTime>(existing.lastServicedDate, candidate.lastServicedDate);
    if (candidate.serviceInterval != null &&
        (overwriteExisting || existing.serviceInterval == 0)) {
      existing.serviceInterval = candidate.serviceInterval!;
    }
    existing.purchaseDate = pickValue<DateTime>(existing.purchaseDate, candidate.purchaseDate);
    existing.deliveryDate = pickValue<DateTime>(existing.deliveryDate, candidate.deliveryDate);
    existing.purchasePrice = pickPositiveInt(existing.purchasePrice, candidate.purchasePrice);
    existing.purchasedFrom = pickString(existing.purchasedFrom, candidate.purchasedFrom);
    existing.soldDate = pickValue<DateTime>(existing.soldDate, candidate.soldDate);
    existing.soldPrice = pickPositiveInt(existing.soldPrice, candidate.soldPrice);
    existing.soldTo = pickString(existing.soldTo, candidate.soldTo);
    existing.value = pickPositiveInt(existing.value, candidate.value);
    existing.caseDiameter = pickValue<double>(existing.caseDiameter, candidate.caseDiameter);
    existing.caseThickness = pickValue<double>(existing.caseThickness, candidate.caseThickness);
    existing.caseMaterial = pickString(existing.caseMaterial, candidate.caseMaterial);
    existing.lugWidth = pickValue<int>(existing.lugWidth, candidate.lugWidth);
    existing.lug2lug = pickValue<double>(existing.lug2lug, candidate.lug2lug);
    existing.waterResistance = pickValue<int>(existing.waterResistance, candidate.waterResistance);
    existing.powerReserve = pickValue<int>(existing.powerReserve, candidate.powerReserve);
    existing.winderTPD = pickValue<int>(existing.winderTPD, candidate.winderTPD);
    existing.winderDirection = pickString(existing.winderDirection, candidate.winderDirection);
    existing.notes = pickString(existing.notes, candidate.notes);
    if (candidate.favourite != null && (overwriteExisting || !existing.favourite)) {
      existing.favourite = candidate.favourite!;
    }

    existing.nextServiceDue = calculateNextService(
      existing.purchaseDate,
      existing.lastServicedDate,
      existing.serviceInterval,
    );

    int addedWearCount = 0;
    final now = DateTime.now();
    for (final date in candidate.wearDates) {
      if (!date.isAfter(now) && !checkForDuplicateWear(existing, date)) {
        existing.wearList.add(date);
        addedWearCount++;
      }
    }

    existing.ensureInitialized();
    existing.isDirty = true;
    existing.updatedAt = DateTime.now().toUtc();
    await existing.save();
    if (triggerSync) {
      unawaited(SyncService.syncData());
    }
    return addedWearCount;
  }

  static void removeWearDate(DateTime dateToRemove, Watches watch){
    //Get the wearList index of the current date
    try {
      int index = watch.wearList.indexWhere((element) {
        return element.day == dateToRemove.day && element.month == dateToRemove.month && element.year == dateToRemove.year;
      });
      print(index);
      DateTime removed = watch.wearList.removeAt(index);
      watch.ensureInitialized();
      watch.isDirty = true;
      watch.updatedAt = DateTime.now().toUtc();
      watch.save();
      unawaited(SyncService.syncData());
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
      watch.ensureInitialized();
      watch.isDirty = true;
      watch.updatedAt = DateTime.now().toUtc();
      await watch.save();
      unawaited(SyncService.syncData());
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

  static Future<Map<String, List<DateTime>>> recordMultipleWearDates(Watches watch, List<DateTime> dates) async {
    Map<String, List<DateTime>> results = {"Success": <DateTime>[], "In Future": <DateTime>[], "Duplicate": <DateTime>[]};
    for(DateTime date in dates){
      //First, create a list statuses
      //1. Check that the date isn't in the future
      if(!date.isAfter(DateTime.now())){
        //2. Check date doesn't already exist in the list
        if(!checkForDuplicateWear(watch, date)){
          results["Success"]?.add(date);
        } else { //result is duplicate
          results["Duplicate"]?.add(date);
        }
      } else { //result is in the future
        results["In Future"]?.add(date);
      }
    }

    List<DateTime> successList = results["Success"]!;
    for(DateTime date in successList){
      watch.wearList.add(date);
    }
    watch.ensureInitialized();
    watch.isDirty = true;
    watch.updatedAt = DateTime.now().toUtc();
    await watch.save();
    unawaited(SyncService.syncData());

    return results;
  }

  static Future<void> attemptToRecordWear(Watches watch, DateTime date, bool acceptDuplicate) async {
    if(acceptDuplicate){
      await _recordWear(watch, date);
    } else {
      if(checkForDuplicateWear(watch, date)){
        //if there is a duplicate trigger a dialog
        await WristCheckDialogs.getDuplicateWearDialog(watch, date);
      } else {
        await _recordWear(watch, date);

      }
    }

  }

  /*
  Returns True if the given date already exists in the watch wearlist - the comparison is based on day/month/year elements of the timestamp
   */
  static bool checkForDuplicateWear(Watches watch, DateTime date){
    for(var date2 in watch.wearList){
      if(date.day == date2.day && date.month == date2.month && date.year == date2.year) return true;
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

  static int calculateTotalCollectionValue(){
    List<Watches> collection = Boxes.getCollectionWatches();
    int value = 0;
    for(var watch in collection){
      if(watch.value != null){
        value = value + watch.value!;
      }
    }
    return value;
  }

  static int calculateValueTrackedCount(){
    List<Watches> collection = Boxes.getCollectionWatches();
    int count = 0;
    for(var watch in collection){
      if(watch.value != null && watch.value! > 0){
        count++;
      }
    }
    return count;
  }

  static int calculateTotalCollectionCount(){
    return Boxes.getCollectionWatches().length;
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
    String timeInCollection = AppLocalizations.of(Get.context!)!.na;
    Duration time = const Duration(days:0);
    if(currentWatch.purchaseDate != null){

      time = currentWatch.soldDate != null? currentWatch.soldDate!.difference(currentWatch.purchaseDate!): DateTime.now().difference(currentWatch.purchaseDate!);
      int timeInt = time.inDays;
      timeInCollection = AppLocalizations.of(Get.context!)!.timeInCollectionDays(timeInt);
      if (!showDays) {
        if(timeInt > 90){timeInCollection = AppLocalizations.of(Get.context!)!.timeInCollectionThreePlusMonths;}
        if(timeInt > 180){timeInCollection = AppLocalizations.of(Get.context!)!.timeInCollectionSixPlusMonths;}
        if(timeInt > 270){timeInCollection = AppLocalizations.of(Get.context!)!.timeInCollectionNinePlusMonths;}
        if(timeInt > 365){
          var years = Jiffy.now().diff(Jiffy.parseFromDateTime(currentWatch.purchaseDate!), unit: Unit.year);
          timeInCollection = AppLocalizations.of(Get.context!)!.timeInCollectionYears(years);
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