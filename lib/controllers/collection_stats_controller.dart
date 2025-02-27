import 'package:get/get.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';

class CollectionStatsController extends GetxController{
  final caseThicknessChartType = CaseThicknessChartEnum.line.obs;
  final lug2lugChartType = Lug2lugChartEnum.line.obs;

  updateCaseThicknessChartType(type){
    caseThicknessChartType(type);
  }

  updateLug2LugChartType(type){
    lug2lugChartType(type);
  }
}
