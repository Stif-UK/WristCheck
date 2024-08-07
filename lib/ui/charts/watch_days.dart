import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WatchDayChart extends StatefulWidget {
  WatchDayChart({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());



  @override
  State<WatchDayChart> createState() => _WatchDayChartState();
}

class _WatchDayChartState extends State<WatchDayChart> {

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of months and counts
    Map<int,int> chartData = <int,int>{};
    //Populate Days
    for(int i = 7 ; i >= 1; i--){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in widget.currentWatch.wearList){
      int day = wearDate.weekday;
      chartData.update(day, (value) => ++value);
    }

    Map<int, String> dayMap = <int, String>{
      1 : "Monday",
      2 : "Tuesday",
      3 : "Wednesday",
      4 : "Thursday",
      5 : "Friday",
      6 : "Saturday",
      7 : "Sunday"
    };



    List<DayWearData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(DayWearData(item.key, item.value));
    }

    return Obx( () => Container(
      child: widget.wristCheckController.dayChartPreference.value == DefaultChartType.bar?
    SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<DayWearData, String>(
          dataSource: getChartData,
          xValueMapper: (DayWearData value, _) => value.day.toString(),
          yValueMapper: (DayWearData value, _) => value.count,
          dataLabelMapper: (value, _)=> "${dayMap[value.day]}: ${value.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true,),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    ):

    SfCircularChart(
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries<DayWearData, String>>[
          DoughnutSeries<DayWearData, String>(
              dataSource: getChartData,
              xValueMapper: (DayWearData data, _) => dayMap[data.day],//data.day.toString(),
              yValueMapper: (DayWearData data, _) => data.count,
              dataLabelSettings: DataLabelSettings(isVisible: true, showZeroValue: false),
          enableTooltip: true)
        ])
    ));
  }


}

class DayWearData{
  DayWearData(this.day, this.count);
  final int day;
  final int count;
}

