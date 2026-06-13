import 'package:get/get.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

import '../boxes.dart';

class WearChartsHelper {

  static String getBasicFilterHeaderText(WearChartOptions option){
    String returnString = "";
    switch(option) {
      case WearChartOptions.all:
        returnString = AppLocalizations.of(Get.context!)!.allData;
        break;
      case WearChartOptions.thisYear:
        returnString = AppLocalizations.of(Get.context!)!.wornThisYear;
        break;
      case WearChartOptions.thisMonth:
        returnString = AppLocalizations.of(Get.context!)!.wornThisMonth;
        break;
      case WearChartOptions.lastMonth:
        returnString = AppLocalizations.of(Get.context!)!.wornLastMonth;
        break;
      case WearChartOptions.lastYear:
        returnString = AppLocalizations.of(Get.context!)!.wornLastYear;
        break;
      case WearChartOptions.last30days:
        returnString = AppLocalizations.of(Get.context!)!.wornInLast30Days;
        break;
      case WearChartOptions.last90days:
        returnString = AppLocalizations.of(Get.context!)!.wornInLast90Days;
        break;
      case WearChartOptions.manual:
        var controller = Get.put(FilterController());
        var monthValue = WristCheckFormatter.getMonthText(controller.selectedMonth.value);
        var yearValue = controller.selectedYear.value;
        if(monthValue != AppLocalizations.of(Get.context!)!.all && yearValue != AppLocalizations.of(Get.context!)!.all){
          returnString = "$monthValue $yearValue";
        } else if(monthValue == AppLocalizations.of(Get.context!)!.all && yearValue == AppLocalizations.of(Get.context!)!.all){
          returnString = AppLocalizations.of(Get.context!)!.allData;
        }else if(monthValue == AppLocalizations.of(Get.context!)!.all){
          returnString = AppLocalizations.of(Get.context!)!.yearSelected(yearValue);
        } else {
          returnString = AppLocalizations.of(Get.context!)!.monthSelected(monthValue);
        }
        break;
      case WearChartOptions.lastPurchase:
        returnString = AppLocalizations.of(Get.context!)!.sinceLastPurchase;
        break;
      case WearChartOptions.last365days:
        returnString = AppLocalizations.of(Get.context!)!.wornInLast365Days;
        break;
      case WearChartOptions.betweenDates:
        var controller = Get.put(FilterController());
        returnString = AppLocalizations.of(Get.context!)!.wornBetweenDates(WristCheckFormatter.getFormattedDate(controller.startDate.value), WristCheckFormatter.getFormattedDate(controller.endDate.value));
        break;
    }

    return returnString;
  }

  static String getAdvancedFilterHeaderText(bool showCollection, bool showSold, bool showRetired, bool showArchived, bool showGrouping, ChartGrouping grouping, bool filterCategories, List<CategoryEnum> selectedCategories, bool filterMovements, List<MovementEnum> selectedMovements){

    final filterController = Get.put(FilterController());
    String returnText = "";
    //If filter
    if(filterController.basicWearFilter.value == WearChartOptions.lastPurchase && filterController.lastPurchaseTracked.value){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderLastPurchase(returnText, WristCheckFormatter.getFormattedDate(filterController.lastPurchaseDate.value));
    }
    //Text for grouping
    if(showGrouping){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderGrouping(WristCheckFormatter.getChartGroupingText(grouping), returnText);
    }
    //Text for category filter
    if(filterCategories){
      String catString = "";
      for(CategoryEnum category in selectedCategories){
        catString = "$catString ${category.toLocalizedString(Get.context!)},";
      }
      if(catString.length != 0){
        catString = catString.substring(1, catString.length-1);
      }
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderCategories(catString, returnText);
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
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderMovements(mvmtString, returnText);
    }
    //Text for hide collection
    if(!showCollection){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderHideCollection(returnText);
    }
    //Text for including sold watches
    if(showSold){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderIncSold(returnText);
    }
    //Text for including retired watches
    if(showRetired){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderIncRetired(returnText);
    }
    //Text for including archived watches
    if(showArchived){
      returnText = AppLocalizations.of(Get.context!)!.advancedFilterHeaderIncArchived(returnText);
    }
    returnText = returnText.trim();
    if(returnText.length > 2){
      returnText = returnText.substring(0, returnText.length-1);
    }

    return returnText;
  }

  static String getLabelSuffix(Watches watch){
    String returnString = "";

    switch(watch.status){
      case "Sold":
        returnString = AppLocalizations.of(Get.context!)!.soldSuffix;
        break;
      case "Retired":
        returnString = AppLocalizations.of(Get.context!)!.retiredSuffix;
        break;
      case "Archived":
        returnString = AppLocalizations.of(Get.context!)!.archivedSuffix;
        break;
      default:
        returnString = "";
        break;
    }

    return returnString;
  }
}