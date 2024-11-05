import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_filter_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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

  Map<int, String> shortDayMap = <int, String>{
    1 : "Mon",
    2 : "Tue",
    3 : "Wed",
    4 : "Thu",
    5 : "Fri",
    6 : "Sat",
    7 : "Sun"
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
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch, widget.wristCheckController.dayChartFilter.value), widget.dayMap);
        break;
      case WatchDayChartEnum.pie:
        returnChart =_buildPieChart(_getBasicChartData(widget.currentWatch, widget.wristCheckController.dayChartFilter.value), _tooltipBehavior, widget.dayMap);
        break;
      case WatchDayChartEnum.grouped:
        returnChart =_buildGroupedChart(_getSplitChartData(widget.currentWatch, widget.wristCheckController.dayChartFilter.value), widget.shortDayMap);
        break;
      case WatchDayChartEnum.line:
        returnChart = _buildLineChart(_getSplitChartData(widget.currentWatch, widget.wristCheckController.dayChartFilter.value), widget.shortDayMap);
        break;
      default:
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch, widget.wristCheckController.dayChartFilter.value), widget.dayMap);
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

Widget _buildGroupedChart(Map<int, List<DayWearData>> data, Map<int, String> dayMap){
  var chartSeries = <StackedBarSeries>[];
  for(int month in data.keys){

    StackedBarSeries yearSeries = StackedBarSeries<DayWearData, String>(
      name: WristCheckFormatter.getMonthName(month),
      dataSource: data[month]!.reversed.toList(), //reverse list to show January first
      xValueMapper: (DayWearData value, _) => dayMap[value.day],
      yValueMapper: (DayWearData value, _) => value.count,
    );
    chartSeries.add(yearSeries);
  }

  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: chartSeries,
    legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        title: LegendTitle(text: "Month")
    ),
  );
}

Widget _buildLineChart(Map<int, List<DayWearData>> data, Map<int, String> dayMap){
  var chartSeries = <StackedLineSeries>[];
  for(int month in data.keys){
    StackedLineSeries yearSeries = StackedLineSeries<DayWearData, String>(
      groupName: month.toString(),
      name: WristCheckFormatter.getMonthName(month),
      dataSource: data[month]!,
      xValueMapper: (DayWearData data, _) => dayMap[data.day],
      yValueMapper: (DayWearData data, _) => data.count,
    );
    chartSeries.add(yearSeries);
  }

  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: chartSeries,
    legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        title: LegendTitle(text: "Month")
    ),

  );
}



List<DayWearData> _getBasicChartData(Watches currentWatch, WatchDayChartFilterEnum filter){
  //Calculate the chart data - generate a map of days and counts
  Map<int,int> chartData = <int,int>{};

  //Populate Days
  for(int i = 7 ; i >= 1; i--){
    chartData[i] = 0;
  }

  //apply filter
  List<DateTime> dateList = filterList(currentWatch.wearList, filter);

  //Populate Counts
  for(DateTime wearDate in dateList){
    int day = wearDate.weekday;
    chartData.update(day, (value) => ++value);
  }

  List<DayWearData> returnList = [];
  for(var item in chartData.entries){
    returnList.add(DayWearData(item.key, item.value));
    }
    return returnList;
}

Map<int, List<DayWearData>> _getSplitChartData(Watches watch, WatchDayChartFilterEnum filter){
  //First create a list of months
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  //apply filter
  List<DateTime> dateList = filterList(watch.wearList, filter);

  //Create a map of months with sub-map for days to capture counts
  Map<int, Map<int, int>> dataMap = {};
  for(int selectedMonth in months){
    Map<int,int> chartData = <int,int>{};
    //Populate Days
    for(int i = 1 ; i <= 7; i++){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in dateList){
      if(wearDate.month == selectedMonth) {
        int day = wearDate.weekday;
        chartData.update(day, (value) => ++value);
      }
    }
    //Update Map
    dataMap[selectedMonth] = chartData;
  }

  //Create return list of data objects
  Map<int, List<DayWearData>> returnMap = {};

  //Convert to objects and populate list
  for(var currentMonth in dataMap.entries){
    List<DayWearData> monthList = [];
    //we're in the first map, iterate over the second
    for(var currentDay in dataMap[currentMonth.key]!.entries){
      monthList.add(DayWearData(currentDay.key, currentDay.value));
    }
    returnMap[currentMonth.key]= monthList;
  }
  //return the data
  return returnMap;
}

List<DateTime> filterList(List<DateTime> input, WatchDayChartFilterEnum filter){

  List<DateTime> returnList = input;
  switch(filter) {
    case WatchDayChartFilterEnum.all:
      returnList = returnList;
      break;
    case WatchDayChartFilterEnum.thisYear:
      returnList = returnList.where((i) => i.year == DateTime.now().year).toList();
      break;
    case WatchDayChartFilterEnum.lastYear:
      returnList = returnList.where((i) => i.year == DateTime.now().year-1).toList();
      break;
    case WatchDayChartFilterEnum.last12months:
      returnList = returnList.where((i) => DateTime.now().difference(i).inDays < 365).toList();
      break;
    case WatchDayChartFilterEnum.last90days:
      returnList = returnList.where((i) => DateTime.now().difference(i).inDays < 90).toList();
      break;
    default:
      returnList = returnList;
  }

  return returnList;
}

class DayWearData{
  DayWearData(this.day, this.count);
  final int day;
  final int count;
}
