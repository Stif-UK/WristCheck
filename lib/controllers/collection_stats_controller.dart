import 'package:get/get.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class CollectionStatsController extends GetxController{
  final caseThicknessChartType = CaseThicknessChartEnum.line.obs;
  final lug2lugChartType = Lug2lugChartEnum.line.obs;
  final showPrice = WristCheckPreferences.getCostPerWearValuePref().obs;//

  updateCaseThicknessChartType(type){
    caseThicknessChartType(type);
  }

  updateLug2LugChartType(type){
    lug2lugChartType(type);
  }

  updateShowPrice(price){
    showPrice(price);
    WristCheckPreferences.setCostPerWearValuePref(price);
  }
}
