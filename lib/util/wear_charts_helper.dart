import 'package:wristcheck/model/enums/wear_chart_options.dart';

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
    }

    return returnString;
  }
}