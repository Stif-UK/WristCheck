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
    Map<int,int> chartData = <int,int>{};
    //Populate Months
    for(int i = 1 ; i <= 12; i++ ){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in widget.currentWatch.wearList){
      int month = wearDate.month;
      chartData.update(month, (value) => ++value);
    }
    print(chartData);



    List<CategoryData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(CategoryData(item.key.toString(), item.value));
    }


    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<CategoryData, String>(
          dataSource: getChartData,
          xValueMapper: (CategoryData mvmt, _) => mvmt.category,
          yValueMapper: (CategoryData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> "${moov.category}: ${moov.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class CategoryData{
  CategoryData(this.category, this.count);
  final String category;
  final int count;
}

