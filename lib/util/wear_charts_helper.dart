import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/watches.dart';
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
        var monthValue = WristCheckFormatter.getMonthText(controller.selectedMonth.value);
        var yearValue = controller.selectedYear.value;
        if(monthValue != "All" && yearValue != "All"){
          returnString = "$monthValue $yearValue";
        } else if(monthValue == "All" && yearValue == "All"){
          returnString = "All Data";
        }else if(monthValue == "All"){
          returnString = "Year: $yearValue";
        } else {
          returnString = "Month: $monthValue";
        }
        break;
      case WearChartOptions.lastPurchase:
        returnString = "Since Last Purchase";
        break;
    }

    return returnString;
  }

  static String getAdvancedFilterHeaderText(bool showCollection, bool showSold, bool showRetired, bool showArchived, bool showGrouping, ChartGrouping grouping, bool filterCategories, List<CategoryEnum> selectedCategories, bool filterMovements, List<MovementEnum> selectedMovements){

    String returnText = "";
    //Text for grouping
    if(showGrouping){
      returnText = "$returnText Group by ${grouping.name}, ";
    }
    //Text for category filter
    if(filterCategories){
      String catString = "";
      for(CategoryEnum category in selectedCategories){
        catString = "$catString ${WristCheckFormatter.getCategoryText(category)},";
      }
      if(catString.length != 0){
        catString = catString.substring(1, catString.length-1);
      }
      returnText = "$returnText Categories($catString), ";
    }
    //Text for movement filter
    if(filterMovements){
      String mvmtString = "";
      for(MovementEnum movement in selectedMovements){
        mvmtString = "$mvmtString ${WristCheckFormatter.getMovementText(movement)},";
      }
      if(mvmtString.length != 0){
        mvmtString = mvmtString.substring(1, mvmtString.length-1);
      }
      returnText = "$returnText Movements($mvmtString), ";
    }
    //Text for hide collection
    if(!showCollection){
      returnText = "$returnText hide Collection, ";
    }
    //Text for including sold watches
    if(showSold){
      returnText = "$returnText inc. Sold, ";
    }
    //Text for including retired watches
    if(showRetired){
      returnText = "$returnText inc. Retired, ";
    }
    //Text for including archived watches
    if(showArchived){
      returnText = "$returnText inc. Archived, ";
    }
    returnText = returnText.trim();

    return returnText.substring(0, returnText.length-1);
  }

  static String getLabelSuffix(Watches watch){
    String returnString = "";

    switch(watch.status){
      case "Sold":
        returnString = "(Sold)";
        break;
      case "Retired":
        returnString = "(Retired)";
        break;
      case "Archived":
        returnString = "(Archived)";
        break;
      default:
        returnString = "";
        break;
    }

    return returnString;
  }
}