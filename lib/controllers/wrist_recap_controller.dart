import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WristRecapController extends GetxController{
  final month = 1.obs;
  final year = 2025.obs;
  final monthView = true.obs;
  final selectedRecapOption = WristRecapEnums.monthly.obs;
  final watchesWorn = <WornWatchesClass>[].obs;
  final brandsWorn = <ManufacturersWornClass>[].obs;
  final duplicateBrand = false.obs;
  final categoriesWorn = <CategoriesWornClass>[].obs;
  final statusWorn = <StatusWornClass>[].obs;
  final categoriesComplete = true.obs;
  final watchesBought = <Watches>[].obs;
  final watchesSold = <Watches>[].obs;
  final topWatchMonthly = <TopWatchMonthlyClass>[].obs;
  final topBrandMonthly = <TopBrandMonthlyClass>[].obs;
  final topCategoryMonthly = <TopCategoryMonthlyClass>[].obs;
  final isLastMonth = false.obs;
  final expandAdCard = false.obs;
  final showOptionalAdCard = true.obs;
  final startDate = DateTime(DateTime.now().year, 1, 1).obs;
  final endDate = DateTime(DateTime.now().year, 12, 31).obs;

  
  updateMonth(int monthInt) async {
    month(monthInt);
  }
  
  updateYear(int yearInt) async {
    year(yearInt);
  }

  updateMonthView(bool newValue){
    monthView(newValue);
  }

  setRecapOption(WristRecapEnums? value) {
    if (value != null) {
      selectedRecapOption(value);
      //Update monthView based on selection for legacy support in UI segments
      monthView(value == WristRecapEnums.monthly);
      refresh();
    }
  }

  toggleMonthView(){
    monthView(!monthView.value);
    refresh();
  }

  updateWatchesWorn(List<WornWatchesClass> watchList){
    watchesWorn(watchList);
  }

  updateManufacturersWorn(List<ManufacturersWornClass> brandList){
    brandsWorn(brandList);
  }
  
  updateCategoriesWorn(List<CategoriesWornClass> categoryList){
    categoriesWorn(categoryList);
  }
  
  updateCategoriesComplete(bool complete){
    categoriesComplete(complete);
  }

  updateWatchesBought(List<Watches> watchList){
    watchesBought(watchList);
  }

  updateWatchesSold(List<Watches> watchList){
    watchesSold(watchList);
  }

  updateEndDate(DateTime newEndDate){
    endDate(newEndDate);
    if (selectedRecapOption.value == WristRecapEnums.betweenDates) refresh();
  }

  updateStartDate(DateTime newStartDate){
    startDate(newStartDate);
    if (selectedRecapOption.value == WristRecapEnums.betweenDates) refresh();
  }

  toggleAdCard(){
    expandAdCard(!expandAdCard.value);
  }

  List<WornWatchesClass> _getWornList() {
    final allNonArchived = Boxes.getAllNonArchivedWatches();
    switch (selectedRecapOption.value) {
      case WristRecapEnums.monthly:
        return Boxes.getWatchesWornFilter(allNonArchived, month.value, year.value);
      case WristRecapEnums.annually:
        return Boxes.getWatchesWornFilter(allNonArchived, null, year.value);
      case WristRecapEnums.allData:
        return Boxes.getWatchesWornFilter(allNonArchived, null, null);
      case WristRecapEnums.last30days:
        return Boxes.getRollingWatchesWornFilter(allNonArchived, 30);
      case WristRecapEnums.last90days:
        return Boxes.getRollingWatchesWornFilter(allNonArchived, 90);
      case WristRecapEnums.last365days:
        return Boxes.getRollingWatchesWornFilter(allNonArchived, 365);
      case WristRecapEnums.sinceLastPurchase:
        DateTime? lastPurchaseDate = Boxes.getLastPurchaseDate(List.from(allNonArchived));
        if (lastPurchaseDate != null) {
          return Boxes.getWatchesWornBetweenTwoDates(allNonArchived, lastPurchaseDate, DateTime.now().add(const Duration(days: 1)));
        }
        return [];
      case WristRecapEnums.betweenDates:
        return Boxes.getWatchesWornBetweenTwoDates(allNonArchived, startDate.value, endDate.value);
    }
  }

  generateWornWatchesDate(int wearMonth, int wearYear){
    //Get all watches worn during period
    List<WornWatchesClass> wearList = _getWornList();

    //Order the list - descending count
    if(wearList.isNotEmpty) wearList.sort((a, b) => b.count.compareTo(a.count));
    //Get total count
    int totalCount = 0;
    for(WornWatchesClass watch in wearList){
      totalCount = totalCount + watch.count;
    }
    //Set percentage for each watch
    for(WornWatchesClass watch in wearList){
      watch.setPercentage("${((watch.count / totalCount)*100).toStringAsFixed(1)} %");
    }
    //Update the controller value
    watchesWorn(wearList);
    
  }

  generateBrandsWornData(int wearMonth, int wearYear){
    duplicateBrand(false);
    Map<String, int> brandMap = {};
    Map<String, int> watchesPerBrandCount = {};
    List<WornWatchesClass> wornList = _getWornList();

    for(WornWatchesClass worn in wornList){
        brandMap[worn.watch.manufacturer] = (brandMap[worn.watch.manufacturer] ?? 0) + worn.count;
        watchesPerBrandCount[worn.watch.manufacturer] = (watchesPerBrandCount[worn.watch.manufacturer] ?? 0) + 1;
    }

    if (watchesPerBrandCount.values.any((c) => c > 1)) {
      duplicateBrand(true);
    }

    List<ManufacturersWornClass> brandList = [];
    int totalCount = 0;
    brandMap.forEach((brand, count) {
      brandList.add(ManufacturersWornClass(brand, count));
      totalCount += count;
    });

    //Order the list - descending count
    brandList.sort((a, b) => b.count.compareTo(a.count));

    //Set percentage for each brand
    for(ManufacturersWornClass brandData in brandList){
      brandData.setPercentage("${((brandData.count / totalCount)*100).toStringAsFixed(1)} %");
    }

    brandsWorn(brandList);
  }
  
  generateStatusWornData(int wearMonth, int wearYear){
    Map<String, int> statusMap = {};
    List<WornWatchesClass> wornList = _getWornList();

    for(WornWatchesClass worn in wornList){
        String status = WatchStatusEnumExtension.fromDbString(worn.watch.status).toLocalizedString(Get.context!);
        statusMap[status] = (statusMap[status] ?? 0) + worn.count;
    }

    List<StatusWornClass> statusList = [];
    int totalCount = 0;
    statusMap.forEach((status, count) {
      statusList.add(StatusWornClass(status, count));
      totalCount += count;
    });

    //Order the list - descending count
    if(statusList.isNotEmpty) statusList.sort((a, b) => b.count.compareTo(a.count));

    //Set percentage for each status
    for(StatusWornClass statusData in statusList){
      statusData.setPercentage("${((statusData.count / totalCount)*100).toStringAsFixed(1)} %");
    }

    statusWorn(statusList);
  }
  
  
  generateCategoriesWornData(int wearMonth, int wearYear){
    Map<String, int> categoryMap = {};
    List<WornWatchesClass> wornList = _getWornList();
    bool complete = true;

    for(WornWatchesClass worn in wornList){
        String categoryDb = worn.watch.category ?? "";
        String category;
        if (categoryDb.isEmpty) {
          category = AppLocalizations.of(Get.context!)!.unknown;
          complete = false;
        } else {
          category = CategoryEnumLocalization.fromDbString(categoryDb).toLocalizedString(Get.context!);
        }
        categoryMap[category] = (categoryMap[category] ?? 0) + worn.count;
    }

    List<CategoriesWornClass> categoryList = [];
    int totalCount = 0;
    categoryMap.forEach((category, count) {
      categoryList.add(CategoriesWornClass(category, count));
      totalCount += count;
    });

    //Order the list - descending count
    if(categoryList.isNotEmpty) categoryList.sort((a, b) => b.count.compareTo(a.count));

    //Set percentage for each category
    for(CategoriesWornClass categoryData in categoryList){
      categoryData.setPercentage("${((categoryData.count / totalCount)*100).toStringAsFixed(1)} %");
    }

    categoriesComplete(complete);
    categoriesWorn(categoryList);
  }

  generateTopWatchMonthlyData() {
    if (selectedRecapOption.value != WristRecapEnums.annually) {
      topWatchMonthly([]);
      return;
    }

    List<TopWatchMonthlyClass> topWatchesList = [];
    List<Watches> allWatches = Boxes.getAllNonArchivedWatches();

    for (int m = 1; m <= 12; m++) {
      Watches? topWatch;
      int maxCount = 0;

      for (Watches watch in allWatches) {
        int count = watch.wearList
            .where((date) => date.month == m && date.year == year.value)
            .length;

        if (count > maxCount) {
          maxCount = count;
          topWatch = watch;
        }
      }
      topWatchesList.add(TopWatchMonthlyClass(m, topWatch, maxCount));
    }
    topWatchMonthly(topWatchesList);
  }

  generateTopBrandMonthlyData() {
    if (selectedRecapOption.value != WristRecapEnums.annually) {
      topBrandMonthly([]);
      return;
    }

    List<TopBrandMonthlyClass> topBrandsList = [];
    List<Watches> allWatches = Boxes.getAllNonArchivedWatches();

    for (int m = 1; m <= 12; m++) {
      Map<String, int> brandCountMap = {};
      for (Watches watch in allWatches) {
        int count = watch.wearList
            .where((date) => date.month == m && date.year == year.value)
            .length;

        if (count > 0) {
          brandCountMap[watch.manufacturer] = (brandCountMap[watch.manufacturer] ?? 0) + count;
        }
      }

      String? topBrand;
      int maxCount = 0;
      brandCountMap.forEach((brand, count) {
        if (count > maxCount) {
          maxCount = count;
          topBrand = brand;
        }
      });

      topBrandsList.add(TopBrandMonthlyClass(m, topBrand, maxCount));
    }
    topBrandMonthly(topBrandsList);
  }

  generateTopCategoryMonthlyData() {
    if (selectedRecapOption.value != WristRecapEnums.annually) {
      topCategoryMonthly([]);
      return;
    }

    List<TopCategoryMonthlyClass> topCategoriesList = [];
    List<Watches> allWatches = Boxes.getAllNonArchivedWatches();

    for (int m = 1; m <= 12; m++) {
      Map<String, int> categoryCountMap = {};
      for (Watches watch in allWatches) {
        int count = watch.wearList
            .where((date) => date.month == m && date.year == year.value)
            .length;

        if (count > 0) {
          String categoryDb = watch.category ?? "";
          String category;
          if (categoryDb.isEmpty) {
            category = AppLocalizations.of(Get.context!)!.unknown;
          } else {
            category = CategoryEnumLocalization.fromDbString(categoryDb)
                .toLocalizedString(Get.context!);
          }
          categoryCountMap[category] =
              (categoryCountMap[category] ?? 0) + count;
        }
      }

      String? topCategory;
      int maxCount = 0;
      categoryCountMap.forEach((category, count) {
        if (count > maxCount) {
          maxCount = count;
          topCategory = category;
        }
      });

      topCategoriesList.add(TopCategoryMonthlyClass(m, topCategory, maxCount));
    }
    topCategoryMonthly(topCategoriesList);
  }

  bool _isInPeriod(DateTime? date) {
    if (date == null) return false;
    switch (selectedRecapOption.value) {
      case WristRecapEnums.monthly:
        return date.month == month.value && date.year == year.value;
      case WristRecapEnums.annually:
        return date.year == year.value;
      case WristRecapEnums.allData:
        return true;
      case WristRecapEnums.last30days:
        return DateTime.now().difference(date).inDays < 30;
      case WristRecapEnums.last90days:
        return DateTime.now().difference(date).inDays < 90;
      case WristRecapEnums.last365days:
        return DateTime.now().difference(date).inDays < 365;
      case WristRecapEnums.sinceLastPurchase:
        DateTime? lastPurchaseDate = Boxes.getLastPurchaseDate(List.from(Boxes.getAllNonArchivedWatches()));
        if (lastPurchaseDate != null) {
          return date.isAtSameMomentAs(lastPurchaseDate) || date.isAfter(lastPurchaseDate);
        }
        return false;
      case WristRecapEnums.betweenDates:
        return (date.isAtSameMomentAs(startDate.value) || date.isAfter(startDate.value)) &&
               (date.isAtSameMomentAs(endDate.value) || date.isBefore(endDate.value));
    }
  }

  generateWatchesSold() async {
    List<Watches> soldWatches = Boxes.getSoldWatches();
    soldWatches = soldWatches.where((watch) => _isInPeriod(watch.soldDate)).toList();
    watchesSold(soldWatches);
  }

  generateWatchesPurchased() async{
    List<Watches> purchasedWatches = Boxes.getAllNonArchivedWatches();
    purchasedWatches = purchasedWatches.where((watch) => _isInPeriod(watch.purchaseDate)).toList();
    watchesBought(purchasedWatches);
  }

  checkIsLastMonth() async {
    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month-1);
    isLastMonth(lastMonth.month == month.value && lastMonth.year == year.value);
  }

  incrementMonth() {
    DateTime newDate;
    if (selectedRecapOption.value == WristRecapEnums.monthly) {
      newDate = DateTime(year.value, month.value + 1);
    } else if (selectedRecapOption.value == WristRecapEnums.annually) {
      newDate = DateTime(year.value + 1, month.value);
    } else {
      return;
    }
    month(newDate.month);
    year(newDate.year);
    //Retrigger the data generation and check if this is 'last month'
    refresh();
  }

  decrementMonth() {
    DateTime newDate;
    if (selectedRecapOption.value == WristRecapEnums.monthly) {
      newDate = DateTime(year.value, month.value - 1);
    } else if (selectedRecapOption.value == WristRecapEnums.annually) {
      newDate = DateTime(year.value - 1, month.value);
    } else {
      return;
    }
    month(newDate.month);
    year(newDate.year);
    //Retrigger the data generation and check if this is 'last month'
    refresh();
  }

  decideShowOptionalAdSpace(){
    DateTime lastAdShownTimestamp = WristCheckPreferences.getLastRecordedAdTimestamp();
    Duration difference = DateTime.now().difference(lastAdShownTimestamp);
    if(difference.inHours < 48){
      showOptionalAdCard(false);
    }
  }

  updateShowOptionalAdCard(bool showCard){
    showOptionalAdCard(showCard);
  }

  String getRecapHeaderText(BuildContext context) {
    switch (selectedRecapOption.value) {
      case WristRecapEnums.monthly:
        return "${WristCheckFormatter.getMonthFullName(month.value)} ${year.value}";
      case WristRecapEnums.annually:
        return "${year.value}";
      case WristRecapEnums.allData:
        return AppLocalizations.of(context)!.allData;
      case WristRecapEnums.last30days:
        return AppLocalizations.of(context)!.last30days;
      case WristRecapEnums.last90days:
        return AppLocalizations.of(context)!.last90days;
      case WristRecapEnums.last365days:
        return AppLocalizations.of(context)!.last365days;
      case WristRecapEnums.sinceLastPurchase:
        return AppLocalizations.of(context)!.sinceLastPurchase;
      case WristRecapEnums.betweenDates:
        return "${WristCheckFormatter.getFormattedDate(startDate.value)} - ${WristCheckFormatter.getFormattedDate(endDate.value)}";
    }
  }

  int getDaysInPeriod() {
    switch (selectedRecapOption.value) {
      case WristRecapEnums.monthly:
        return DateUtils.getDaysInMonth(year.value, month.value);
      case WristRecapEnums.annually:
        bool isLeapYear = (year.value % 4 == 0 && year.value % 100 != 0) || (year.value % 400 == 0);
        return isLeapYear ? 366 : 365;
      case WristRecapEnums.allData:
        // Use difference between first wear and now
        List<Watches> all = Boxes.getAllWatches();
        DateTime earliest = DateTime.now();
        for (var w in all) {
          if (w.wearList.isNotEmpty && w.wearList.first.isBefore(earliest)) earliest = w.wearList.first;
        }
        return DateTime.now().difference(earliest).inDays.clamp(1, 99999);
      case WristRecapEnums.last30days:
        return 30;
      case WristRecapEnums.last90days:
        return 90;
      case WristRecapEnums.last365days:
        return 365;
      case WristRecapEnums.sinceLastPurchase:
        DateTime? lastPurchaseDate = Boxes.getLastPurchaseDate(List.from(Boxes.getAllNonArchivedWatches()));
        if (lastPurchaseDate != null) {
          return DateTime.now().difference(lastPurchaseDate).inDays.clamp(1, 99999);
        }
        return 1;
      case WristRecapEnums.betweenDates:
        return endDate.value.difference(startDate.value).inDays.clamp(1, 99999);
    }
  }

  refresh() async {
    await generateWornWatchesDate(month.value, year.value);
    await generateBrandsWornData(month.value, year.value);
    await generateCategoriesWornData(month.value, year.value);
    await generateStatusWornData(month.value, year.value);
    await generateTopWatchMonthlyData();
    await generateTopBrandMonthlyData();
    await generateTopCategoryMonthlyData();
    await checkIsLastMonth();
    await generateWatchesSold();
    await generateWatchesPurchased();
    await decideShowOptionalAdSpace();
  }

}