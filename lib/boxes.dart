import 'dart:math';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

import 'package:wristcheck/model/enums/watch_status_enum.dart';

class Boxes {
  // static Box<Watches> getWatches() =>
  //   Hive.box<Watches>("WatchBox");

  /*
  getWatches() returns the main app database of all Watches
   */
  static Box<Watches> getWatches() {
    //Check first that box is open, if it isn't re-open it before returning.
    return Hive.box<Watches>("WatchBox").isOpen? Hive.box<Watches>("WatchBox") : openAndReturn();
  }

  static Box<Watches> openAndReturn(){
    Hive.openBox<Watches>("WatchBox");
    return Hive.box<Watches>("WatchBox");
  }

  /*
  getMeasurements() returns the secondary database of all tracked watch accuracy data points
   */
  static Box<Measurement> getMeasurements(){
    return Hive.box<Measurement>("AccuracyBox");
  }

  static Iterable<Measurement> getMeasurementsForWatch(Watches watch){
    return getMeasurements().values.toList().where((measurement) => measurement.watchKey == watch.key);
  }

  static List<Watches> getWatchesByFilter(CollectionView collectionValue){
    List<Watches> returnlist = [];

    switch(collectionValue){
      case CollectionView.all:
        returnlist = getCollectionWatches();
        break;
      case CollectionView.favourites:
        returnlist = getFavouriteWatches();
        break;
      case CollectionView.sold:
        returnlist = getSoldWatches();
        break;
      case CollectionView.wishlist:
        returnlist = getWishlistWatches();
        break;
      case CollectionView.random:
        returnlist = getRandomWatch();
        break;
      case CollectionView.preorder:
        returnlist = getPreOrderWatches();
        break;
      case CollectionView.retired:
        returnlist = getRetiredWatches();
        break;
      case CollectionView.onLoan:
        returnlist = getOnLoanWatches();
        break;
    }

    return returnlist;
  }

  static List<Watches> getAllWatches() {
    return Hive.box<Watches>("WatchBox").values.toList();
  }

  static List<Watches> getAllNonArchivedWatches(){
    List<Watches> returnList = Hive.box<Watches>("WatchBox").values.toList();
    returnList.removeWhere((watch) => watch.status == WatchStatusEnum.archived.toDbString());
    return returnList;
  }

  static List<Watches> getRandomWatch() {
    List<Watches> returnList = [];
    List<Watches> collection = getCollectionWatches();
    if (collection.isNotEmpty) {
      Watches? randomWatch;
      //get size of collection
      var collectionSize = collection.length;
      //generate a random number in that range
      Random ran = Random();
      int randomNo = ran.nextInt(collectionSize);
      randomWatch = collection.elementAt(randomNo);
      returnList.add(randomWatch);
    }
    return returnList;
  }

  static List<Watches> getCollectionWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.inCollection.toDbString()).toList();
  }

  static List<Watches> getValidToHaveWornWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.inCollection.toDbString() || watch.status == WatchStatusEnum.sold.toDbString() || watch.status == WatchStatusEnum.retired.toDbString() || watch.status == WatchStatusEnum.onLoan.toDbString()).toList();
  }

  static List<Watches> getSoldWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.sold.toDbString()).toList();
  }

  static List<Watches> getCollectionAndSoldWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.inCollection.toDbString() || watch.status == WatchStatusEnum.sold.toDbString()).toList();
  }

  static List<Watches> getCollectionAndOnLoanWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.inCollection.toDbString() || watch.status == WatchStatusEnum.onLoan.toDbString()).toList();
  }

  static List<Watches> getCollectionAndSoldAndOnLoanWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.inCollection.toDbString() || watch.status == WatchStatusEnum.sold.toDbString() || watch.status == WatchStatusEnum.onLoan.toDbString()).toList();
  }

  static List<Watches> getWishlistWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.wishlist.toDbString()).toList();
  }

  static List<Watches> getArchivedWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.archived.toDbString()).toList();
  }

  static List<Watches> getOnLoanWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.onLoan.toDbString()).toList();
  }

  static List<Watches> getPreOrderWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.preOrder.toDbString()).toList();
  }

  static List<Watches> getRetiredWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.status == WatchStatusEnum.retired.toDbString()).toList();
  }

  static List<Watches> getFavouriteWatches() {
    return Hive.box<Watches>("WatchBox").values.where((watch) => watch.favourite == true && watch.status != "Sold").toList();
  }


  static List<Watches> getServiceSchedule(){
    var returnList = Hive.box<Watches>("WatchBox").values.where((watch) => watch.nextServiceDue != null && watch.status == WatchStatusEnum.inCollection.toDbString()).toList();
    returnList.sort((a, b) => a.nextServiceDue!.compareTo(b.nextServiceDue!));
    return returnList;
  }

  static List<Watches> getWarrantySchedule(){
    var returnList = Hive.box<Watches>("WatchBox").values.where((watch) => watch.warrantyEndDate != null && watch.status == WatchStatusEnum.inCollection.toDbString()).toList();
    returnList.sort((a, b) => a.warrantyEndDate!.compareTo(b.warrantyEndDate!));
    return returnList;
  }

  static List<Watches> getWatchesWornOnDate(List<Watches> initialList, int year, int month, int day){
    List<Watches> returnList = initialList;
    returnList = returnList.where((watch) => watch.wearList.any((element) => element.year == year && element.month == month && element.day == day)).toList();
    return returnList;
  }
  
  static List<WornWatchesClass> getWatchesWornFilter(List<Watches> initialList, int? month, int? year){
    List<WornWatchesClass> returnList = [];

    for (var watch in initialList) {
      List<DateTime> filteredList = List.from(watch.wearList);
      if (year != null) {
        filteredList.removeWhere((date) => date.year != year);
      }
      if (month != null) {
        filteredList.removeWhere((date) => date.month != month);
      }

      if (filteredList.isNotEmpty) {
        returnList.add(WornWatchesClass(watch, filteredList.length));
      }
    }

    //finally before returning, sort the list if required
    returnList = Boxes.sortWearChart(returnList);
    return returnList;
  }

  static List<WornWatchesClass> getRollingWatchesWornFilter(List<Watches> initialList, int days){
    List<WornWatchesClass> returnList = [];
    DateTime now = DateTime.now();

    for (var watch in initialList) {
      List<DateTime> filteredList = List.from(watch.wearList);
      filteredList.removeWhere((date) => now.difference(date).inDays >= days);

      if (filteredList.isNotEmpty) {
        returnList.add(WornWatchesClass(watch, filteredList.length));
      }
    }

    //finally before returning, sort the list if required
    returnList = Boxes.sortWearChart(returnList);
    return returnList;
  }

  static List<WornWatchesClass> getWatchesWornBetweenTwoDates(List<Watches> initialList, DateTime startDate, DateTime endDate){
    List<WornWatchesClass> returnList = [];

    for (var watch in initialList) {
      List<DateTime> filteredList = List.from(watch.wearList);
      filteredList.removeWhere((date) => date.isBefore(startDate));
      filteredList.removeWhere((date) => date.isAfter(endDate));

      if (filteredList.isNotEmpty) {
        returnList.add(WornWatchesClass(watch, filteredList.length));
      }
    }

    //finally before returning, sort the list if required
    returnList = Boxes.sortWearChart(returnList);
    return returnList;
  }

  static List<WornWatchesClass> sortWearChart(List<WornWatchesClass> toSort){
    List<WornWatchesClass> returnList = toSort;

    ChartOrdering chartOrder = WristCheckPreferences.getWearChartOrder() ?? ChartOrdering.watchbox;

    switch(chartOrder){
      case ChartOrdering.watchbox:
        WatchOrder? watchOrder = WristCheckPreferences.getWatchOrder();
        if (watchOrder == null) return returnList;
        List<Watches> watchesToSort = returnList.map((e) => e.watch).toList();
        List<Watches> sortedWatches = sortWatchBox(watchesToSort, watchOrder).reversed.toList();
        
        List<WornWatchesClass> sortedReturnList = [];
        for (var watch in sortedWatches) {
          sortedReturnList.add(returnList.firstWhere((element) => element.watch == watch));
        }
        return sortedReturnList;

      case ChartOrdering.descending:
        returnList.sort((a,b) => a.count.compareTo(b.count));
        return returnList;
      case ChartOrdering.ascending:
        returnList.sort((a,b) => b.count.compareTo(a.count));
        return returnList;
    }
  }

  static List<Watches> sortWatchBox(List<Watches> unsortedList, WatchOrder order){
    List<Watches> returnList = unsortedList;

    //Custom sort function for lastworn
    int mySortComparison(Watches a, Watches b) {
      final propertyA = a.wearList.isEmpty? DateTime(1900,01,01): a.wearList.last;
      final propertyB = b.wearList.isEmpty? DateTime(1900,01,01): b.wearList.last;
      if (propertyA.isAfter(propertyB)){
        return -1;
      } else if (propertyA.isBefore(propertyB)) {
        return 1;
      } else {
        return 0;
      }
    }

    switch(order){
      case WatchOrder.watchbox:
        returnList = unsortedList;
        break;
      case WatchOrder.reverse:
        returnList = unsortedList.reversed.toList();
        break;
      case WatchOrder.mostworn:
        returnList.sort((a,b)=>b.wearList.length.compareTo(a.wearList.length));
        break;
      case WatchOrder.alpha_asc:
        returnList.sort((a,b)=>a.model.compareTo(b.model));
        returnList.sort((a,b)=>a.manufacturer.compareTo(b.manufacturer));
        break;
      case WatchOrder.alpha_desc:
        returnList.sort((a,b)=>a.model.compareTo(b.model));
        returnList.sort((a,b)=>b.manufacturer.compareTo(a.manufacturer));
        break;
      case WatchOrder.lastworn:
        returnList.sort(mySortComparison);
        break;
    }

    return returnList;
  }

  static List<WornWatchesClass> getWearChartLoadData(WearChartOptions option, bool incCollection, bool incSold, bool incRetired, bool incArchived, bool incOnLoan, bool filterByCategory, List<CategoryEnum> categoryFilterList, bool filterByMovement, List<MovementEnum> movementFilterList) {

    final controller = Get.put(FilterController());
    var now = DateTime.now();
    var lastMonth = DateTime(now.year, now.month-1);
    //Populate the initial list based on settings chosen
    List<Watches> initialList = [];
    if(incCollection){
      initialList.addAll(Boxes.getCollectionWatches());
    }
    if(incSold){
      initialList.addAll(Boxes.getSoldWatches());
    }
    if(incRetired){
      initialList.addAll(Boxes.getRetiredWatches());
    }
    if(incArchived){
      initialList.addAll(Boxes.getArchivedWatches());
    }
    if(incOnLoan){
      initialList.addAll(Boxes.getOnLoanWatches());
    }
    if(filterByCategory && categoryFilterList.isNotEmpty){
      initialList = Boxes.runCategoryFilter(initialList, categoryFilterList);
    }
    if(filterByMovement && movementFilterList.isNotEmpty){
      initialList = Boxes.runMovementFilter(initialList, movementFilterList);
    }
    List<WornWatchesClass> returnValue = [];


    switch (option){
      case WearChartOptions.all:{
        returnValue = Boxes.getWatchesWornFilter(initialList, null, null);
      }
      break;
      case WearChartOptions.thisYear:{
        returnValue = Boxes.getWatchesWornFilter(initialList, null, now.year);
      }
      break;
      case WearChartOptions.lastYear:{
        returnValue = Boxes.getWatchesWornFilter(initialList, null, now.year-1);
      }
      break;
      case WearChartOptions.thisMonth:{
        returnValue = Boxes.getWatchesWornFilter(initialList, now.month, now.year);
      }
      break;
      case WearChartOptions.lastMonth:{
        returnValue = Boxes.getWatchesWornFilter(initialList, lastMonth.month, lastMonth.year);
      }
      break;
      case WearChartOptions.last30days:{
        returnValue = Boxes.getRollingWatchesWornFilter(initialList, 30);
      }
      break;
      case WearChartOptions.last90days:{
        returnValue = Boxes.getRollingWatchesWornFilter(initialList, 90);
      }
      break;
      case WearChartOptions.last365days:{
        returnValue = Boxes.getRollingWatchesWornFilter(initialList, 365);
      }
      break;
      case WearChartOptions.lastPurchase:{
        //Use a copy of list to get the last purchase date to avoid deleting values from the list
        List<Watches> copyList = List.from(initialList);
        DateTime? lastPurchaseDate = getLastPurchaseDate(copyList);
        controller.updateLastPurchaseDate(lastPurchaseDate);
        if(lastPurchaseDate != null){
          DateTime now = DateTime.now();
          //set end date to tomorrow to avoid filtering out current date
          DateTime tomorrow = now.add(Duration(days: 1));
          returnValue = Boxes.getWatchesWornBetweenTwoDates(initialList, lastPurchaseDate, tomorrow);
        } else {
          returnValue = <WornWatchesClass>[];
        }
      }
      break;
      case WearChartOptions.manual:{
        int? monthInt = WristCheckFormatter.getMonthInt(controller.selectedMonth.value);
        int? yearInt = controller.selectedYear.value == FilterController.allYearsSentinel ? null : int.parse(controller.selectedYear.value);
        returnValue = Boxes.getWatchesWornFilter(initialList, monthInt, yearInt);
      }
      break;
      case WearChartOptions.betweenDates:{
        returnValue = Boxes.getWatchesWornBetweenTwoDates(initialList, controller.startDate.value, controller.endDate.value);
      }
      break;
      default:{
        returnValue = Boxes.getWatchesWornFilter(initialList, null, null);
      }
    }

    return returnValue;
  }

  static DateTime? getLastPurchaseDate(List<Watches> initialList){
    var filterController = Get.put(FilterController());
    //remove nulls
    initialList.removeWhere((watch) => watch.purchaseDate == null);

    //Sort list
    initialList.sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));

    if(initialList.isNotEmpty) {
      DateTime returnTime = initialList.first.purchaseDate!;
      filterController.updateLastPurchaseDate(returnTime);
      return returnTime;
    } else {
      return null;
    }
  }

  static List<Watches> runCategoryFilter(List<Watches> watchList, List<CategoryEnum> categories){
    List<Watches> returnList = [];
    for(CategoryEnum category in categories){
      returnList.addAll(watchList.where((watch) => WristCheckFormatter.getCategoryEnum(watch.category) == category).toList());
    }

    return returnList;
  }

  static List<Watches> runMovementFilter(List<Watches> watchList, List<MovementEnum> movements){
    List<Watches> returnList = [];
    for(MovementEnum movement in movements){
      returnList.addAll(watchList.where((watch) => WristCheckFormatter.getMovementEnum(watch.movement) == movement).toList());
    }

    return returnList;
  }

}