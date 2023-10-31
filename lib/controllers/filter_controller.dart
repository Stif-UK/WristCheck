import 'package:get/get.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class FilterController extends GetxController{
  
  final basicWearFilter = WristCheckPreferences.getWearChartOptions().obs;

updateFilterName(WearChartOptions filter){
    basicWearFilter(filter);
    
  }

}