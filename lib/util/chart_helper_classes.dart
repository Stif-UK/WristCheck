import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CategoryClass{
  CategoryClass(this.category, this.count);

  late final CategoryEnum category;
  late final int count;
}

class MovementClass{
  MovementClass(this.movement, this.count);

  late final MovementEnum movement;
  late final int count;
}

class ManufacturerClass{
  ManufacturerClass(this.manufacturer, this.count);

  late final String manufacturer;
  late final int count;
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
    return returnSeries;
  }

}