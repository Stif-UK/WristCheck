import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/util/helper_classes.dart';

class ChartClass{
  ChartClass(this.count);
  late final int count;
}
class CategoryClass extends ChartClass{
  CategoryClass(this.category,int count) : super(count);

  late final CategoryEnum category;
}

class MovementClass extends ChartClass{
  MovementClass(this.movement, int count) : super(count);

  late final MovementEnum movement;
}

class ManufacturerClass extends ChartClass{
  ManufacturerClass(this.manufacturer, int count) : super(count);

  late final String manufacturer;
}

class MaterialClass extends ChartClass{
  MaterialClass(this.material, int count) : super(count);

  late final CaseMaterialEnum material;
}

class DateComplicationClass extends ChartClass{
  DateComplicationClass(this.dateComplication, int count) : super(count);

  late final DateComplicationEnum dateComplication;
}

class DimensionsClass extends ChartClass{
  DimensionsClass(this.dimension, int count) : super(count);

  late final String dimension;

  @override
  String toString() {
    return 'DimensionsClass{dimension: $dimension, count: $count}';
  }
}

class ChartHelper{

  static List<CategoryClass> calculateCategoryList(List<WornWatchesClass> data){
    List<CategoryClass> returnSeries = [];
    for(CategoryEnum category in CategoryEnum.values){
      int count = 0;
      if(category != CategoryEnum.blank){
        List<WornWatchesClass> categoryList = data.where((worn) => worn.watch.category == WristCheckFormatter.getCategoryText(category)).toList();
        for(WornWatchesClass worn in categoryList){
          count += worn.count;
        }
        returnSeries.add(CategoryClass(category, count));
      }else{
        //TODO: Why did I add this else clause here?
        List<WornWatchesClass> categoryList = data.where((worn) => worn.watch.category == null).toList();
        for(WornWatchesClass worn in categoryList){
          count += worn.count;
        }
        returnSeries.add(CategoryClass(CategoryEnum.blank, count));
      }

    }
    returnSeries.removeWhere((category) => category.count == 0);
    //TODO: This can be made optional
    returnSeries.removeWhere((category) => category.category == CategoryEnum.blank);
    returnSeries = sortChartData(returnSeries) as List<CategoryClass>;
    return returnSeries;
  }

  static List<MovementClass> calculateMovementList(List<WornWatchesClass> data){
    List<MovementClass> returnSeries = [];
    for(MovementEnum movement in MovementEnum.values){
      int count = 0;
      if(movement != MovementEnum.blank){
        List<WornWatchesClass> movementList = data.where((worn) => worn.watch.movement == WristCheckFormatter.getMovementText(movement)).toList();
        for(WornWatchesClass worn in movementList){
          count += worn.count;
        }
        returnSeries.add(MovementClass(movement, count));
      }else{
        List<WornWatchesClass> movementList = data.where((worn) => worn.watch.movement == null || worn.watch.movement == "").toList();
        for(WornWatchesClass worn in movementList){
          count += worn.count;
        }
        returnSeries.add(MovementClass(MovementEnum.blank, count));
      }

    }

    returnSeries.removeWhere((movement) => movement.count == 0);
    //TODO: This can be made optional
    returnSeries.removeWhere((movement) => movement.movement == MovementEnum.blank);
    returnSeries = sortChartData(returnSeries) as List<MovementClass>;
    return returnSeries;
  }

  static List<ManufacturerClass> calculateManufacturerList(List<WornWatchesClass> data){
    List<ManufacturerClass> returnSeries = [];
    //Get set of manufacturers (to ensure all unique)
    Set<String> manufacturers = {};
    for(WornWatchesClass worn in data){
      manufacturers.add(worn.watch.manufacturer);
    }
    for(String manufacturer in manufacturers) {
      int count = 0;
      List<WornWatchesClass> manList = data.where((worn) => worn.watch.manufacturer == manufacturer).toList();
      for(WornWatchesClass worn in manList){
        count += worn.count;
      }
      returnSeries.add(ManufacturerClass(manufacturer, count));

    }
    returnSeries = sortChartData(returnSeries) as List<ManufacturerClass>;
    return returnSeries;
  }

  static List<MaterialClass> calculateCaseMaterialList(List<WornWatchesClass> data){
    List<MaterialClass> returnSeries = [];
    //Get set of materials (to ensure all unique)
    Set<String> caseMaterials = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.caseMaterial != null && worn.watch.caseMaterial != "Not Entered" && worn.watch.caseMaterial != "") {
        caseMaterials.add(worn.watch.caseMaterial!);
      }
    }
    for(String material in caseMaterials) {
      int count = 0;
      List<WornWatchesClass> matList = data.where((worn) => worn.watch.caseMaterial == material).toList();
      for(WornWatchesClass worn in matList){
        count += worn.count;
      }

      returnSeries.add(MaterialClass(WristCheckFormatter.getCaseMaterialEnum(material), count));

    }
    returnSeries = sortChartData(returnSeries) as List<MaterialClass>;
    return returnSeries;
  }

  static List<DateComplicationClass> calculateDateComplicationList(List<WornWatchesClass> data){
    List<DateComplicationClass> returnSeries = [];
    //Get set of materials (to ensure all unique)
    Set<String> dateComplication = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.dateComplication != null && worn.watch.dateComplication != "Not Entered" && worn.watch.dateComplication != "") {
        dateComplication.add(worn.watch.dateComplication!);
      }
    }
    for(String date in dateComplication) {
      int count = 0;
      List<WornWatchesClass> dateTypeList = data.where((worn) => worn.watch.dateComplication == date).toList();
      for(WornWatchesClass worn in dateTypeList){
        count += worn.count;
      }
      returnSeries.add(DateComplicationClass(WristCheckFormatter.getDateComplicationEnum(date)!, count));

    }
    returnSeries = sortChartData(returnSeries) as List<DateComplicationClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateCaseDiameterList(List<WornWatchesClass> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of case diameters (to ensure all unique)
    Set<double> caseDiameters = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.caseDiameter != null && worn.watch.caseDiameter != 0.0) {
        caseDiameters.add(worn.watch.caseDiameter!);
      }
    }
    for(double caseDiameter in caseDiameters) {
      int count = 0;
      List<WornWatchesClass> cdList = data.where((worn) => worn.watch.caseDiameter == caseDiameter).toList();
      for(WornWatchesClass worn in cdList){
        count += worn.count;
      }
      returnSeries.add(DimensionsClass(caseDiameter.toString(), count));

    }

    returnSeries = sortChartData(returnSeries) as List<DimensionsClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateLugWidthList(List<WornWatchesClass> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of lugWidths (to ensure all unique)
    Set<int> lugWidths = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.lugWidth != null && worn.watch.lugWidth != 0) {
        lugWidths.add(worn.watch.lugWidth!);
      }
    }
    for(int lugWidth in lugWidths) {
      int count = 0;
      List<WornWatchesClass> watchList = data.where((worn) => worn.watch.lugWidth == lugWidth).toList();
      for(WornWatchesClass worn in watchList){
        count += worn.count;
      }

      //Only add records where the wear count is > 0;
      if (count > 0) {
        returnSeries.add(DimensionsClass(lugWidth.toString(), count));
      }
    }

    returnSeries = sortChartData(returnSeries) as List<DimensionsClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateLugToLugList(List<WornWatchesClass> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of lugWidths (to ensure all unique)
    Set<double> lug2lugs = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.lug2lug != null && worn.watch.lug2lug != 0.0) {
        lug2lugs.add(worn.watch.lug2lug!);
      }
    }
    for(double lug2lug in lug2lugs) {
      int count = 0;
      List<WornWatchesClass> watchList = data.where((worn) => worn.watch.lug2lug == lug2lug).toList();
      for(WornWatchesClass worn in watchList){
        count += worn.count;
      }
      //Only add records where the wear count is > 0;
      if (count > 0) {
        returnSeries.add(DimensionsClass(lug2lug.toString(), count));
      }

    }
    returnSeries = sortChartData(returnSeries) as List<DimensionsClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateCaseThicknessList(List<WornWatchesClass> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of case thicknesses (to ensure all unique)
    Set<double> caseThicknesses = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.caseThickness != null && worn.watch.caseThickness != 0.0) {
        caseThicknesses.add(worn.watch.caseThickness!);
      }
    }
    for(double caseThickness in caseThicknesses) {
      int count = 0;
      List<WornWatchesClass> watchList = data.where((worn) => worn.watch.caseThickness == caseThickness).toList();
      for(WornWatchesClass worn in watchList){
        count += worn.count;
      }
      //Only add records where the wear count is > 0;
      if (count > 0) {
        returnSeries.add(DimensionsClass(caseThickness.toString(), count));
      }

    }
    returnSeries = sortChartData(returnSeries) as List<DimensionsClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateWaterResistanceList(List<WornWatchesClass> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of water resistance values (to ensure all unique)
    Set<int> waterResistanceList = {};
    for(WornWatchesClass worn in data){
      if(worn.watch.waterResistance != null && worn.watch.waterResistance != 0) {
        waterResistanceList.add(worn.watch.waterResistance!);
      }
    }
    for(int wr in waterResistanceList) {
      int count = 0;
      List<WornWatchesClass> watchList = data.where((worn) => worn.watch.waterResistance == wr).toList();
      for(WornWatchesClass worn in watchList){
        count += worn.count;
      }

      //Only add records where the wear count is > 0;
      if (count > 0) {
        returnSeries.add(DimensionsClass(wr.toString(), count));
      }
    }

    returnSeries = sortChartData(returnSeries) as List<DimensionsClass>;
    return returnSeries;
  }
  
  static List<ChartClass> sortChartData(List<ChartClass> series){
    ChartOrdering order = WristCheckPreferences.getWearChartOrder() ?? ChartOrdering.watchbox;
    if(order == ChartOrdering.ascending){
      series.sort((a,b) => b.count.compareTo(a.count));

    }

    if(order == ChartOrdering.descending){
      series.sort((a,b) => a.count.compareTo(b.count));
    }

    return series;
  }

  static int getCostPerWearChartSize(){
    int returnSize = 0;
    List<Watches> collection = Boxes.getCollectionWatches();
    for(Watches watch in collection){
      if(watch.purchasePrice != null){
        if(watch.purchasePrice! > 0){
          if(watch.wearList.length > 0){
            returnSize++;
          }
        }
      }
    }
    return returnSize;
  }

  static Widget getWatchMonthChartIcon(WatchMonthChartEnum type){
    Widget returnIcon;

    switch(type) {
      case WatchMonthChartEnum.bar:
        returnIcon = const FaIcon(FontAwesomeIcons.chartBar);
        break;
      case WatchMonthChartEnum.pie:
        returnIcon = const FaIcon(FontAwesomeIcons.chartPie);
        break;
      case WatchMonthChartEnum.grouped:
        returnIcon = const FaIcon(FontAwesomeIcons.magnifyingGlassChart);
        break;
      case WatchMonthChartEnum.line:
        returnIcon = const FaIcon(FontAwesomeIcons.chartLine);
        break;
      default:
        returnIcon = const FaIcon(FontAwesomeIcons.chartBar);
        break;
    }

    return returnIcon;

  }

  static getNextMonthChart(WatchMonthChartEnum type){
    final wristCheckController = Get.put(WristCheckController());
    List<WatchMonthChartEnum> values = WatchMonthChartEnum.values;
    int index = 0;
    int max = values.length;
    index = values.indexOf(type);
    index++;
    if(index >= max){
      index = 0;
    }
    wristCheckController.updateMonthChartPreference(values[index]);
  }

  //TODO: Merge this and MonthChartIcon method to take either type
  static Widget getWatchDayChartIcon(WatchDayChartEnum type){
    Widget returnIcon;

    switch(type) {
      case WatchDayChartEnum.bar:
        returnIcon = const FaIcon(FontAwesomeIcons.chartBar);
        break;
      case WatchDayChartEnum.pie:
        returnIcon = const FaIcon(FontAwesomeIcons.chartPie);
        break;
      case WatchDayChartEnum.grouped:
        returnIcon = const FaIcon(FontAwesomeIcons.magnifyingGlassChart);
        break;
      case WatchDayChartEnum.line:
        returnIcon = const FaIcon(FontAwesomeIcons.chartLine);
        break;
      default:
        returnIcon = const FaIcon(FontAwesomeIcons.chartBar);
        break;
    }

    return returnIcon;

  }

  static getNextDayChart(WatchDayChartEnum type){
    final wristCheckController = Get.put(WristCheckController());
    List<WatchDayChartEnum> values = WatchDayChartEnum.values;
    int index = 0;
    int max = values.length;
    index = values.indexOf(type);
    index++;
    if(index >= max){
      index = 0;
    }
    wristCheckController.updateDayChartPreference(values[index]);
  }

  static String getMedianAsString(List<int> data, String units){
    num median;
    String returnString = "";

    //check that the list isn't empty before continuing - as null and zero has already been removed, this confirms
    //we have a valid list to perform operations on.
    if(data.isNotEmpty) {
      int middle = data.length ~/ 2;
      if (data.length % 2 == 1) {
        median = data[middle];
      } else {
        median =
            ((data[middle - 1] + data[middle]) / 2.0).round();
      }
      returnString = "$median $units";
    }
  return returnString;
  }

}