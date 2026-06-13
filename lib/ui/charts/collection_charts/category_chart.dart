import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CategoryChart extends StatefulWidget {
  const CategoryChart({Key? key}) : super(key: key);

  @override
  State<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of categories and counts
    Map<CategoryEnum,int> chartData = <CategoryEnum,int>{};
    for(var watch in data){
      if(watch.category != null){
        CategoryEnum category = WristCheckFormatter.getCategoryEnum(watch.category);
        chartData.update(
          category,
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    
    //remove blank entries
    if (chartData.containsKey(CategoryEnum.blank)){
      chartData.remove(CategoryEnum.blank);
    }

    //sort map
    var sortedChartData = Map.fromEntries(
        chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<CategoryData> getChartData = [];

    for(var item in sortedChartData.entries){
      getChartData.add(CategoryData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <CartesianSeries>[
        BarSeries<CategoryData, String>(
          dataSource: getChartData,
          xValueMapper: (CategoryData cat, _) => cat.category.toLocalizedString(context),
          yValueMapper: (CategoryData cat, _) => cat.count,
          dataLabelMapper: (cat, _)=> "${cat.category.toLocalizedString(context)}: ${cat.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class CategoryData{
  CategoryData(this.category, this.count);
  final CategoryEnum category;
  final int count;
}

