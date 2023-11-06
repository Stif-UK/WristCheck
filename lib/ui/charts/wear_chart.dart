import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WearChart extends StatefulWidget {

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;
  final ChartGrouping grouping;



  WearChart({required this.data, required this.animate, required this.grouping});

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  @override
  Widget build(BuildContext context) {
    int dataSize = widget.data.length;


    return dataSize == 0? Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No data available for the chosen filter",
          style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,),
      ),
    ): SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(),
      series: _getBarSeries(widget.grouping)
    );
  }
  
  List<BarSeries<dynamic, dynamic>> _getBarSeries(ChartGrouping grouping){
    
    List<BarSeries<dynamic, dynamic>> returnSeries = [];
    
    switch(grouping) {
      case ChartGrouping.watch:
        returnSeries =  <BarSeries<Watches, String>>[
          BarSeries(
            dataSource: widget.data,
            xValueMapper: (Watches series, _) => series.filteredWearList!.isEmpty? null: (series.manufacturer+series.model),
            yValueMapper: (Watches series, _) => series.filteredWearList == null? series.wearList.length :series.filteredWearList!.length,
            dataLabelMapper: (watch, _) => watch.filteredWearList == null? "${watch.manufacturer} ${watch.model}: ${watch.wearList.length}":"${watch.manufacturer} ${watch.model}: ${watch.filteredWearList!.length}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself

            // animationDuration: 0 Set to zero to stop it animating!
          )

        ];
        break;
      case ChartGrouping.movement:
        List<MovementClass> movementList = _calculateMovementList();
        returnSeries =  <BarSeries<MovementClass, String>>[
          BarSeries(
            dataSource: movementList,
            xValueMapper: (MovementClass series, _) =>  (series.movement.name),
            yValueMapper: (MovementClass series, _) => series.count,
            dataLabelMapper: (mvmt, _) => "${WristCheckFormatter.getMovementText(mvmt.movement)}: ${mvmt.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself

            // animationDuration: 0 Set to zero to stop it animating!
          )

        ];
        break;
      case ChartGrouping.category:
        List<CategoryClass> categoryList = _calculateCategoryList();
        returnSeries =  <BarSeries<CategoryClass, String>>[
          BarSeries(
            dataSource: categoryList,
            xValueMapper: (CategoryClass series, _) =>  (series.category.name),
            yValueMapper: (CategoryClass series, _) => series.count,
            dataLabelMapper: (category, _) => "${WristCheckFormatter.getCategoryText(category.category)}: ${category.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself

            // animationDuration: 0 Set to zero to stop it animating!
          )

        ];
        break;
    }
    
    return returnSeries;
    
    
  }

  List<CategoryClass> _calculateCategoryList(){
    List<CategoryClass> returnSeries = [];
    for(CategoryEnum category in CategoryEnum.values){
      int count = 0;
      if(category != CategoryEnum.blank){
        List<Watches> categoryList = widget.data.where((watch) => watch.category == WristCheckFormatter.getCategoryText(category)).toList();
        for(Watches watch in categoryList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(CategoryClass(category, count));
      }else{
        List<Watches> categoryList = widget.data.where((watch) => watch.category == null || watch.category == "").toList();
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

  List<MovementClass> _calculateMovementList(){
    List<MovementClass> returnSeries = [];
    for(MovementEnum movement in MovementEnum.values){
      int count = 0;
      if(movement != MovementEnum.blank){
        List<Watches> movementList = widget.data.where((watch) => watch.movement == WristCheckFormatter.getMovementText(movement)).toList();
        for(Watches watch in movementList){
          if (watch.filteredWearList != null) {
            count += watch.filteredWearList!.length;
          }
        }
        returnSeries.add(MovementClass(movement, count));
      }else{
        List<Watches> movementList = widget.data.where((watch) => watch.movement == null || watch.movement == "").toList();
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

}

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

