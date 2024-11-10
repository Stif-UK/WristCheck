import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_filter_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WatchMonthChart extends StatefulWidget {
  WatchMonthChart({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<WatchMonthChart> createState() => _WatchMonthChartState();
}

class _WatchMonthChartState extends State<WatchMonthChart> {

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return Obx(() => Container(
      child: _getChart(widget.wristCheckController.monthChartPreference.value)

    ));
  }

  Widget _getChart(WatchMonthChartEnum type){
    Widget returnChart;

    switch(type){
      case WatchMonthChartEnum.bar:
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch));
        break;
      case WatchMonthChartEnum.pie:
        returnChart =_buildPieChart(_getBasicChartData(widget.currentWatch), _tooltipBehavior);
        break;
      case WatchMonthChartEnum.grouped:
        returnChart =_buildGroupedChart(_getSplitChartData(widget.currentWatch, widget.wristCheckController.monthChartFilter.value));
        break;
      case WatchMonthChartEnum.line:
        returnChart = _buildLineChart(_getSplitChartData(widget.currentWatch, widget.wristCheckController.monthChartFilter.value));
        break;
      default:
        returnChart = _buildBarChart(_getBasicChartData(widget.currentWatch));
        break;
    }


    return returnChart;
  }
}

Widget _buildPieChart(List<MonthWearData> data, TooltipBehavior tooltip) {

  return SfCircularChart(
      tooltipBehavior: tooltip,
      legend: Legend(isVisible: true,
          overflowMode: LegendItemOverflowMode.scroll),
      series: <CircularSeries<MonthWearData, String>>[
        DoughnutSeries<MonthWearData, String>(
            dataSource: data,
            xValueMapper: (MonthWearData data, _) => "${DateFormat('MMMM').format(DateTime(0, int.parse(data.month)))}" ,
            yValueMapper: (MonthWearData data, _) => data.count,
            dataLabelSettings: DataLabelSettings(isVisible: true, showZeroValue: false),
            enableTooltip: true)
      ]);
}

Widget _buildBarChart(List<MonthWearData> data) {
  return SfCartesianChart(
    series: <ChartSeries>[
      BarSeries<MonthWearData, String>(
        dataSource: data,
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

Widget _buildGroupedChart(Map<int, List<MonthWearData>> data) {
  var chartSeries = <StackedBarSeries>[];
  for(int year in data.keys){

    StackedBarSeries yearSeries = StackedBarSeries<MonthWearData, String>(
      //groupName: year.toString(),
      name: year.toString(),
      dataSource: data[year]!.reversed.toList(), //reverse list to show January first
      xValueMapper: (MonthWearData value, _) => WristCheckFormatter.getMonthName(int.parse(value.month)),
      yValueMapper: (MonthWearData value, _) => value.count,
    );
    chartSeries.add(yearSeries);
  }

  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: chartSeries,
    legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        title: LegendTitle(text: "Year")
    ),
  );
}

Widget _buildLineChart(Map<int, List<MonthWearData>> data) {

  var chartSeries = <StackedLineSeries>[];
  for(int year in data.keys){
    StackedLineSeries yearSeries = StackedLineSeries<MonthWearData, String>(
      groupName: year.toString(),
        name: year.toString(),
        dataSource: data[year]!,
        xValueMapper: (MonthWearData data, _) => WristCheckFormatter.getMonthName(int.parse(data.month)),
        yValueMapper: (MonthWearData data, _) => data.count,
    );
    chartSeries.add(yearSeries);
  }

    return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: chartSeries,
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      title: LegendTitle(text: "Year")
                    ),

                );

}


List<MonthWearData> _getBasicChartData(Watches watch) {
  //Calculate the chart data - generate a map of months and counts for basic pie and bar charts
  Map<int,int> chartData = <int,int>{};
  //Populate Months
  for(int i = 12 ; i >= 1; i--){
    chartData[i] = 0;
  }
  //Populate Counts
  for(DateTime wearDate in watch.wearList){
    int month = wearDate.month;
    chartData.update(month, (value) => ++value);
  }

  List<MonthWearData> getChartData = [];

  for(var item in chartData.entries){
    getChartData.add(MonthWearData(item.key.toString(), item.value));
  }

  return getChartData;
}

Map<int, List<MonthWearData>> _getSplitChartData(Watches watch, WatchMonthChartFilterEnum filter){
  //Implement filter
  List<DateTime> dateList = filterList(watch.wearList, filter);

  //First create a list of years
  List<int> years = [];
  for(DateTime date in dateList){
    if(!years.contains(date.year)){
      years.add(date.year);
    }
  }

  //Create a map of years with sub-map for months to capture counts
  Map<int, Map<int, int>> dataMap = {};
  for(int selectedYear in years){
    Map<int,int> chartData = <int,int>{};
    //Populate Months
    for(int i = 1 ; i <= 12; i++){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in dateList){
      if(wearDate.year == selectedYear) {
        int month = wearDate.month;
        chartData.update(month, (value) => ++value);
      }
    }
    //Update Map
    dataMap[selectedYear] = chartData;
  }

  //Create return list of data objects
  Map<int, List<MonthWearData>> returnMap = {};

  //Convert to objects and populate list
  for(var currentYear in dataMap.entries){
    List<MonthWearData> yearList = [];
    //we're in the first map, iterate over the second
    for(var currentMonth in dataMap[currentYear.key]!.entries){
      // returnMap.add(MonthWearDataV2(currentYear.key, currentMonth.key.toString(), currentMonth.value));
      yearList.add(MonthWearData(currentMonth.key.toString(), currentMonth.value));
    }
    returnMap[currentYear.key]= yearList;
  }
  //return the data
  return returnMap;
}

List<DateTime> filterList(List<DateTime> input, WatchMonthChartFilterEnum filter){

  List<DateTime> returnList = input;
  switch(filter) {
    case WatchMonthChartFilterEnum.all:
      returnList = returnList;
      break;
    case WatchMonthChartFilterEnum.thisYear:
      returnList = returnList.where((i) => i.year == DateTime.now().year).toList();
      break;
    case WatchMonthChartFilterEnum.lastYear:
      returnList = returnList.where((i) => i.year == DateTime.now().year-1).toList();
      break;
    case WatchMonthChartFilterEnum.last12months:
      returnList = returnList.where((i) => DateTime.now().difference(i).inDays < 365).toList();
      break;
  }

  return returnList;
}

class MonthWearData{
  MonthWearData(this.month, this.count);
  final String month;
  final int count;

  @override
  String toString() {
    return "$month : $count";
  }
}


