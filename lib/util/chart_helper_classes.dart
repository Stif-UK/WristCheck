import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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

}