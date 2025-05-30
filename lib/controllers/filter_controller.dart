import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/model/enums/month_list.dart';

class FilterController extends GetxController{

  final basicWearFilter = WristCheckPreferences.getWearChartOptions().obs;
  final lastFilterTabIndex = 0.obs;

  final shrinkText = false.obs;
  final selectedMonth = MonthList.all.obs;
  final selectedYear = "All".obs;
  final includeCollection = true.obs;
  final includeSold = false.obs;
  final includeRetired = false.obs;
  final includeArchived = false.obs;
  final filterByCategory = false.obs;
  final filterByMovement = false.obs;
  final pickGrouping = false.obs;
  final selectedCategories = <CategoryEnum>[].obs;
  final selectedMovements = <MovementEnum>[].obs;
  final chartGrouping = ChartGrouping.watch.obs;
  final lastPurchaseDate = DateTime.now().obs;
  final lastPurchaseTracked = false.obs;

  List<String> yearList = ["All"];

  resetToDefaults(){
    includeCollection(true);
    includeRetired(false);
    includeSold(false);
    includeArchived(false);
    filterByCategory(false);
    selectedCategories([]);
    chartGrouping(ChartGrouping.watch);
    pickGrouping(false);
    filterByMovement(false);
    selectedMovements([]);
  }

  resetCategoryFilter(){
    selectedCategories(<CategoryEnum>[]);
  }

  resetMovementFilter(){
    selectedMovements(<MovementEnum>[]);
  }

  updateLastFilterTabIndex(int index){
    lastFilterTabIndex(index);
  }

  updateChartGrouping(ChartGrouping grouping){
    chartGrouping(grouping);
  }

  updatePickGrouping(bool pick){
    pickGrouping(pick);
  }

  updateShrinkText(bool shrink){
    shrinkText(shrink);
  }

  updateSelectedCategories(List<CategoryEnum> pickedCategories){
    selectedCategories(pickedCategories);
  }

  updateSelectedMovements(List<MovementEnum> pickedMovements){
    selectedMovements(pickedMovements);
  }

  updateFilterName(WearChartOptions filter){
    basicWearFilter(filter);
  }

  updateSelectedMonth(MonthList month){
    selectedMonth(month);
  }

  updateSelectedYear(String year){
    selectedYear(year);
  }

  updateIncludeCollection(bool showCollection){
    includeCollection(showCollection);
  }

  updateIncludeSold(bool showSold){
    includeSold(showSold);
  }

  updateIncludeRetired(bool showRetired){
    includeRetired(showRetired);
  }

  updateIncludeArchived(bool showArchived){
    includeArchived(showArchived);
  }

  updateFilterByCategory(bool byCategory){
    filterByCategory(byCategory);
  }

  updateFilterByMovement(bool byMovement){
    filterByMovement(byMovement);
  }

  updateLastPurchaseDate(DateTime? lastPurchase){
    if(lastPurchase != null){
      lastPurchaseDate(lastPurchase);
      lastPurchaseTracked(true);
    } else {
      lastPurchaseDate(DateTime.now());
    }
  }

  populateYearList(){
    List<Watches> watches = Boxes.getAllWatches();
    List<String> calculatedYearList = ["All"];
    for(Watches watch in watches){
      for(DateTime date in watch.wearList){
        if(!calculatedYearList.contains(date.year.toString())) {
          calculatedYearList.add(date.year.toString());
        };
      }
    }
    calculatedYearList.sort();
    this.yearList = calculatedYearList;
  }


}