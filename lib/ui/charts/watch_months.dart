import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WatchMonthChart extends StatefulWidget {
  WatchMonthChart({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;

  @override
  State<WatchMonthChart> createState() => _WatchMonthChartState();
}

class _WatchMonthChartState extends State<WatchMonthChart> {
  //final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of months and counts
    Map<String,int> chartData = <String,int>{};
    //Add all months



    // for(var watch in data){
    //   if(watch.category != null){
    //     chartData.update(
    //       watch.category!,
    //           (value) => ++value,
    //       ifAbsent: () => 1,
    //     );
    //   }
    // }
    //remove 'not selected' and empty string if it exists
    // if (chartData.containsKey("Not Selected")) {
    //   chartData.remove("Not Selected");
    // }
    // if (chartData.containsKey("")) {
    //   chartData.remove("");
    // }

    // //sort map
    // var sortedChartData = Map.fromEntries(
    //     chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
    //
    //
    // List<CategoryData> getChartData = [];
    //
    // for(var item in sortedChartData.entries){
    //   getChartData.add(CategoryData(item.key, item.value));
    // }
    return Container(
      child: Text("Chart goes here"),
    );

    // return SfCartesianChart(
    //   series: <ChartSeries>[
    //     BarSeries<CategoryData, String>(
    //       dataSource: getChartData,
    //       xValueMapper: (CategoryData mvmt, _) => mvmt.category,
    //       yValueMapper: (CategoryData mvmt, _) => mvmt.count,
    //       dataLabelMapper: (moov, _)=> "${moov.category}: ${moov.count}",
    //       dataLabelSettings: const DataLabelSettings(isVisible: true),
    //     )
    //   ],
    //   primaryXAxis: CategoryAxis(isVisible: false),
    // );
  }
}

class CategoryData{
  CategoryData(this.category, this.count);
  final String category;
  final int count;
}

