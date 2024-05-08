import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of months and counts
    Map<int,int> chartData = <int,int>{};
    //Populate Months
    for(int i = 12 ; i >= 1; i--){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in widget.currentWatch.wearList){
      int month = wearDate.month;
      chartData.update(month, (value) => ++value);
    }



    List<CategoryData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(CategoryData(item.key.toString(), item.value));
    }


    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<CategoryData, String>(
          dataSource: getChartData,
          xValueMapper: (CategoryData value, _) => value.category,
          yValueMapper: (CategoryData value, _) => value.count,
          dataLabelMapper: (value, _)=> "${DateFormat('MMMM').format(DateTime(0, int.parse(value.category)))

          }: ${value.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true, showZeroValue: false),
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

