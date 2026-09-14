import 'package:get/get.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class CollectionStatsController extends GetxController{
  final caseThicknessChartType = CaseThicknessChartEnum.line.obs;
  final lug2lugChartType = Lug2lugChartEnum.line.obs;
  final colourChartType = ColourChartEnum.bar.obs;
  final showPrice = WristCheckPreferences.getCostPerWearValuePref().obs;//
  final groupWatchYearByDecade = WristCheckPreferences.getGroupWatchYearByDecade().obs;

  updateCaseThicknessChartType(type){
    caseThicknessChartType(type);
  }

  updateLug2LugChartType(type){
    lug2lugChartType(type);
  }

  updateColourChartType(ColourChartEnum type){
    colourChartType(type);
  }

  cycleColourChartType(){
    switch (colourChartType.value) {
      case ColourChartEnum.bar:
        colourChartType(ColourChartEnum.pie);
        break;
      case ColourChartEnum.pie:
        colourChartType(ColourChartEnum.donut);
        break;
      case ColourChartEnum.donut:
        colourChartType(ColourChartEnum.bar);
        break;
    }
  }

  updateShowPrice(price){
    showPrice(price);
    WristCheckPreferences.setCostPerWearValuePref(price);
  }

  updateGroupWatchYearByDecade(bool value){
    groupWatchYearByDecade(value);
    WristCheckPreferences.setGroupWatchYearByDecade(value);
  }
}
