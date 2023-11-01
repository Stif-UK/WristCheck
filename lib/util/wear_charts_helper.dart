import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WearChartsHelper {

  static String getBasicFilterHeaderText(WearChartOptions option){
    String returnString = "";
    switch(option) {
      case WearChartOptions.all:
        returnString = "All Data";
        break;
      case WearChartOptions.thisYear:
        returnString = "Worn This Year";
        break;
      case WearChartOptions.thisMonth:
        returnString = "Worn This Month";
        break;
      case WearChartOptions.lastMonth:
        returnString = "Worn Last Month";
        break;
      case WearChartOptions.lastYear:
        returnString = "Worn Last Year";
        break;
      case WearChartOptions.last30days:
        returnString = "Worn in last 30 days";
        break;
      case WearChartOptions.last90days:
        returnString = "Worn in last 90 days";
        break;
      case WearChartOptions.manual:
        var controller = Get.put(FilterController());

        returnString = "Month: ${WristCheckFormatter.getMonthText(controller.selectedMonth.value)}";
        break;
    }

    return returnString;
  }
}