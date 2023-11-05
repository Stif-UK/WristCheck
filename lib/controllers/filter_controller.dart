import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/model/enums/month_list.dart';

class FilterController extends GetxController{

  final basicWearFilter = WristCheckPreferences.getWearChartOptions().obs;

  final selectedMonth = MonthList.all.obs;
  final selectedYear = "All".obs;
  final includeCollection = true.obs;
  final includeSold = false.obs;
  final includeArchived = false.obs;
  final filterByCategory = false.obs;
  final selectedCategories = <CategoryEnum>[].obs;

  List<String> yearList = ["All"];

  resetToDefaults(){
    includeCollection(true);
    includeSold(false);
    includeArchived(false);
    filterByCategory(false);
    selectedCategories([]);
  }

  updateSelectedCategories(List<CategoryEnum> pickedCategories){
    selectedCategories(pickedCategories);
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

  updateIncludeArchived(bool showArchived){
    includeArchived(showArchived);
  }

  updateFilterByCategory(bool byCategory){
    filterByCategory(byCategory);
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