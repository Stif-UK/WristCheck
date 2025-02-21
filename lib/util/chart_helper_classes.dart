import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class DimensionsClass extends ChartClass{
  DimensionsClass(this.dimension, int count) : super(count);

  late final String dimension;
}

class ChartHelper{

  static List<CategoryClass> calculateCategoryList(List<Watches> data){
    List<CategoryClass> returnSeries = [];
    for(CategoryEnum category in CategoryEnum.values){
      int count = 0;
      if(category != CategoryEnum.blank){
        List<Watches> categoryList = data.where((watch) => watch.category == WristCheckFormatter.getCategoryText(category)).toList();
        for(Watches watch in categoryList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(CategoryClass(category, count));
      }else{
        List<Watches> categoryList = data.where((watch) => watch.category == null || watch.category == "").toList();
        for(Watches watch in categoryList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(CategoryClass(CategoryEnum.blank, count));
      }

    }
    returnSeries = sortChartData(returnSeries) as List<CategoryClass>;
    return returnSeries;
  }

  static List<MovementClass> calculateMovementList(List<Watches> data){
    List<MovementClass> returnSeries = [];
    for(MovementEnum movement in MovementEnum.values){
      int count = 0;
      if(movement != MovementEnum.blank){
        List<Watches> movementList = data.where((watch) => watch.movement == WristCheckFormatter.getMovementText(movement)).toList();
        for(Watches watch in movementList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(MovementClass(movement, count));
      }else{
        List<Watches> movementList = data.where((watch) => watch.movement == null || watch.movement == "").toList();
        for(Watches watch in movementList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(MovementClass(MovementEnum.blank, count));
      }

    }
    returnSeries = sortChartData(returnSeries) as List<MovementClass>;
    return returnSeries;
  }

  static List<ManufacturerClass> calculateManufacturerList(List<Watches> data){
    List<ManufacturerClass> returnSeries = [];
    //Get set of manufacturers (to ensure all unique)
    Set<String> manufacturers = {};
    for(Watches watch in data){
      manufacturers.add(watch.manufacturer);
    }
    for(String manufacturer in manufacturers) {
      int count = 0;
      List<Watches> manList = data.where((watch) => watch.manufacturer == manufacturer).toList();
      for(Watches watch in manList){
        if(watch.filteredWearList != null){
          count += watch.filteredWearList!.length;
        }
      }
      returnSeries.add(ManufacturerClass(manufacturer, count));

    }
    returnSeries = sortChartData(returnSeries) as List<ManufacturerClass>;
    return returnSeries;
  }

  static List<DimensionsClass> calculateCaseDiameterList(List<Watches> data){
    List<DimensionsClass> returnSeries = [];
    //Get set of case diameters (to ensure all unique)
    Set<double> caseDiameters = {};
    for(Watches watch in data){
      if(watch.caseDiameter != null) {
        caseDiameters.add(watch.caseDiameter!);
      }
    }
    for(double caseDiameter in caseDiameters) {
      int count = 0;
      List<Watches> cdList = data.where((watch) => watch.caseDiameter == caseDiameter).toList();
      for(Watches watch in cdList){
        if(watch.filteredWearList != null){
          count += watch.filteredWearList!.length;
        }
      }
      returnSeries.add(DimensionsClass(caseDiameter.toString(), count));

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

  static Icon getWatchMonthChartIcon(WatchMonthChartEnum type){
    Icon returnIcon;

    switch(type) {
      case WatchMonthChartEnum.bar:
        returnIcon = Icon(FontAwesomeIcons.chartBar);
        break;
      case WatchMonthChartEnum.pie:
        returnIcon = Icon(FontAwesomeIcons.chartPie);
        break;
      case WatchMonthChartEnum.grouped:
        returnIcon = Icon(FontAwesomeIcons.magnifyingGlassChart);
        break;
      case WatchMonthChartEnum.line:
        returnIcon = Icon(FontAwesomeIcons.chartLine);
        break;
      default:
        returnIcon = Icon(FontAwesomeIcons.chartBar);
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
  static Icon getWatchDayChartIcon(WatchDayChartEnum type){
    Icon returnIcon;

    switch(type) {
      case WatchDayChartEnum.bar:
        returnIcon = Icon(FontAwesomeIcons.chartBar);
        break;
      case WatchDayChartEnum.pie:
        returnIcon = Icon(FontAwesomeIcons.chartPie);
        break;
      case WatchDayChartEnum.grouped:
        returnIcon = Icon(FontAwesomeIcons.magnifyingGlassChart);
        break;
      case WatchDayChartEnum.line:
        returnIcon = Icon(FontAwesomeIcons.chartLine);
        break;
      default:
        returnIcon = Icon(FontAwesomeIcons.chartBar);
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

}