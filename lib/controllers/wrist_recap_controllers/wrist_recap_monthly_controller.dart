import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/helper_classes.dart';

class WristRecapMonthlyController extends GetxController{
  final month = 1.obs;
  final year = 2025.obs;
  final watchesWorn = <WornWatchesClass>[].obs;
  final brandsWorn = <ManufacturersWornClass>[].obs;
  final duplicateBrand = false.obs;
  final categoriesWorn = <CategoriesWornClass>[].obs;
  final statusWorn = <StatusWornClass>[].obs;
  final categoriesComplete = true.obs;
  final watchesBought = <Watches>[].obs;
  final watchesSold = <Watches>[].obs;
  final isLastMonth = false.obs;
  final expandAdCard = false.obs;
  final showOptionalAdCard = true.obs;

  
  updateMonth(int monthInt) async {
    month(monthInt);
  }
  
  updateYear(int yearInt) async {
    year(yearInt);
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

  toggleAdCard(){
    expandAdCard(!expandAdCard.value);
  }

  generateWornWatchesDate(int wearMonth, int wearYear){
    List<WornWatchesClass> wearList = [];
    //Get all watches during period
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), wearMonth, wearYear);
    //For each watch create a WornWatches object with the watch and its wear count
    for(Watches watch in watchList){
        List<DateTime> wornDates = watch.wearList
            .where(
                (date) => date.month == month.value && date.year == year.value)
            .toList();

        int count = wornDates.length;
        WornWatchesClass watchData = WornWatchesClass(watch, count);
        //Only track data for watches that have been worn
        if (count > 0) wearList.add(watchData);
    }
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
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), wearMonth, wearYear);

    for(Watches watch in watchList){
      int count = watch.wearList
          .where(
              (date) => date.month == wearMonth && date.year == wearYear)
          .length;

      if (count > 0) {
        brandMap[watch.manufacturer] = (brandMap[watch.manufacturer] ?? 0) + count;
        watchesPerBrandCount[watch.manufacturer] = (watchesPerBrandCount[watch.manufacturer] ?? 0) + 1;
      }
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
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), wearMonth, wearYear);

    for(Watches watch in watchList){
      int count = watch.wearList
          .where(
              (date) => date.month == wearMonth && date.year == wearYear)
          .length;

      if (count > 0) {
        String status = WatchStatusEnumExtension.fromDbString(watch.status).toLocalizedString(Get.context!);
        statusMap[status] = (statusMap[status] ?? 0) + count;
      }
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
    List<Watches> watchList = Boxes.getWatchesWornFilter(Boxes.getAllNonArchivedWatches(), wearMonth, wearYear);
    bool complete = true;

    for(Watches watch in watchList){
      int count = watch.wearList
          .where(
              (date) => date.month == wearMonth && date.year == wearYear)
          .length;

      if (count > 0) {
        String categoryDb = watch.category ?? "";
        String category;
        if (categoryDb.isEmpty) {
          category = AppLocalizations.of(Get.context!)!.unknown;
          complete = false;
        } else {
          category = CategoryEnumLocalization.fromDbString(categoryDb).toLocalizedString(Get.context!);
        }
        categoryMap[category] = (categoryMap[category] ?? 0) + count;
      }
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
  
  generateWatchesSold() async {
    List<Watches> soldWatches = [];
    soldWatches = Boxes.getSoldWatches();
    soldWatches.removeWhere((watch) => watch.soldDate == null );
    soldWatches = soldWatches.where((watch) => watch.soldDate!.month == month.value && watch.soldDate!.year == year.value).toList();
    watchesSold(soldWatches);
  }

  generateWatchesPurchased() async{
    List<Watches> purchasedWatches = [];
    purchasedWatches = Boxes.getAllNonArchivedWatches();
    purchasedWatches.removeWhere((watch) => watch.purchaseDate == null);
    purchasedWatches = purchasedWatches.where((watch) => watch.purchaseDate!.month == month.value && watch.purchaseDate!.year == year.value).toList();
    watchesBought(purchasedWatches);
  }

  checkIsLastMonth() async {
    DateTime now = DateTime.now();
    DateTime lastMonth = DateTime(now.year, now.month-1);
    isLastMonth(lastMonth.month == month.value && lastMonth.year == year.value);
  }

  incrementMonth() {
    DateTime newDate = DateTime(year.value, month.value + 1);
    month(newDate.month);
    year(newDate.year);
    //Retrigger the data generation and check if this is 'last month'
    refresh();
  }

  decrementMonth() {
    DateTime newDate = DateTime(year.value, month.value - 1);
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

  refresh() async {
    await generateWornWatchesDate(month.value, year.value);
    await generateBrandsWornData(month.value, year.value);
    await generateCategoriesWornData(month.value, year.value);
    await generateStatusWornData(month.value, year.value);
    await checkIsLastMonth();
    await generateWatchesSold();
    await generateWatchesPurchased();
    await decideShowOptionalAdSpace();
  }

}