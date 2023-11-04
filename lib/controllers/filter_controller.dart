import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/model/enums/month_list.dart';

class FilterController extends GetxController{

  final basicWearFilter = WristCheckPreferences.getWearChartOptions().obs;

  final selectedMonth = MonthList.all.obs;
  final selectedYear = "All".obs;
  final includeSold = false.obs;
  final includeArchived = false.obs;

  List<String> yearList = ["All"];

  updateFilterName(WearChartOptions filter){
    basicWearFilter(filter);
  }

  updateSelectedMonth(MonthList month){
    selectedMonth(month);
  }

  updateSelectedYear(String year){
    selectedYear(year);
  }

  updateIncludeSold(bool showSold){
    includeSold(showSold);
  }

  updateIncludeArchived(bool showArchived){
    includeArchived(showArchived);
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