import 'package:get/get.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';

class FilterController extends GetxController{
  
  final basicWearFilter = WearChartOptions.all.obs;

updateFilterName(WearChartOptions filter){
    basicWearFilter(filter);
    
  }

}