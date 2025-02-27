import 'package:get/get.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';

class CollectionStatsController extends GetxController{
  final caseThicknessChartType = CaseThicknessChartEnum.line.obs;

  updateCaseThicknessChartType(type){
    caseThicknessChartType(type);
  }
}
