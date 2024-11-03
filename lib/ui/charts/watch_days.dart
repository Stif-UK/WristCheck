import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WatchDayChart extends StatefulWidget {
  WatchDayChart({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());

  Map<int, String> dayMap = <int, String>{
    1 : "Monday",
    2 : "Tuesday",
    3 : "Wednesday",
    4 : "Thursday",
    5 : "Friday",
    6 : "Saturday",
    7 : "Sunday"
  };


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

    return Obx( () => Container(
      child: _getChart(widget.wristCheckController.dayChartPreference.value)
    ));
  }

  Widget _getChart(WatchDayChartEnum type){
    Widget returnChart;

    switch(type){
      case WatchDayChartEnum.bar:
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch), widget.dayMap);
        break;
      case WatchDayChartEnum.pie:
        returnChart =_buildPieChart(_getBasicChartData(widget.currentWatch), _tooltipBehavior, widget.dayMap);
        break;
      case WatchDayChartEnum.grouped:
        returnChart =_buildGroupedChart();
        break;
      case WatchDayChartEnum.line:
        returnChart = _buildLineChart();
        break;
      default:
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch), widget.dayMap);
        break;
    }


    return returnChart;
  }

}


Widget _buildBarChart(List<DayWearData> data, Map<int, String> dayMap){
  return SfCartesianChart(
    series: <ChartSeries>[
      BarSeries<DayWearData, String>(
        dataSource: data,
        xValueMapper: (DayWearData value, _) => value.day.toString(),
        yValueMapper: (DayWearData value, _) => value.count,
        dataLabelMapper: (value, _)=> "${dayMap[value.day]}: ${value.count}",
        dataLabelSettings: const DataLabelSettings(isVisible: true,),
      )
    ],
    primaryXAxis: CategoryAxis(isVisible: false),
  );
}


Widget _buildPieChart(List<DayWearData> data, TooltipBehavior tooltip, Map<int, String> dayMap) {
  return SfCircularChart(
      tooltipBehavior: tooltip,
      legend: Legend(isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries<DayWearData, String>>[
        DoughnutSeries<DayWearData, String>(
            dataSource: data,
            xValueMapper: (DayWearData data, _) => dayMap[data.day],//data.day.toString(),
            yValueMapper: (DayWearData data, _) => data.count,
            dataLabelSettings: DataLabelSettings(isVisible: true, showZeroValue: false),
            enableTooltip: true)
      ]);
}

Widget _buildGroupedChart(){
  return Container(
    alignment: Alignment.center,
    child: Text("Grouped Chart Here"),
  );
}

Widget _buildLineChart(){
  return Container(
    alignment: Alignment.center,
    child: Text("Line Chart Here"),
  );
}



List<DayWearData> _getBasicChartData(Watches currentWatch){
  //Calculate the chart data - generate a map of days and counts
  Map<int,int> chartData = <int,int>{};

  //Populate Days
  for(int i = 7 ; i >= 1; i--){
    chartData[i] = 0;
  }

  //Populate Counts
  for(DateTime wearDate in currentWatch.wearList){
    int day = wearDate.weekday;
    chartData.update(day, (value) => ++value);
  }

  List<DayWearData> returnList = [];
  for(var item in chartData.entries){
    returnList.add(DayWearData(item.key, item.value));
    }
    return returnList;
}

class DayWearData{
  DayWearData(this.day, this.count);
  final int day;
  final int count;
}
