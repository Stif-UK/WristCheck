import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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



    List<MonthWearData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(MonthWearData(item.key.toString(), item.value));
    }


    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<MonthWearData, String>(
          dataSource: getChartData,
          xValueMapper: (MonthWearData value, _) => value.month,
          yValueMapper: (MonthWearData value, _) => value.count,
          dataLabelMapper: (value, _)=> "${DateFormat('MMMM').format(DateTime(0, int.parse(value.month)))

          }: ${value.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true,),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class MonthWearData{
  MonthWearData(this.month, this.count);
  final String month;
  final int count;
}

