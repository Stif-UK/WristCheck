import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watch_month_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        returnChart =_buildGroupedChart(_getBasicChartData(widget.currentWatch));
        break;
      case WatchMonthChartEnum.line:
        returnChart = _buildLineChart(_getAdvancedChartData(widget.currentWatch));
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

Widget _buildGroupedChart(List<MonthWearData> data) {
  //TODO: Create Grouped Chart
  return Container(child: Text("Test Grouped Chart"),);
}

Widget _buildLineChart(List<MonthWearDataV2> data) {

  var chartSeries = <StackedLineSeries>[];

  // StackedLineSeries<ChartData, String>(
  //     groupName: 'Group A',
  //     dataLabelSettings: DataLabelSettings(
  //         isVisible: true,
  //         useSeriesColor: true
  //     ),
  //     dataSource: chartData,
  //     xValueMapper: (ChartData data, _) => data.x,
  //     yValueMapper: (ChartData data, _) => data.y1
  // ),

    return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: chartSeries

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

List<MonthWearDataV2> _getAdvancedChartData(Watches watch){
  //First create a list of years
  List<int> years = [];
  for(DateTime date in watch.wearList){
    if(!years.contains(date.year)){
      years.add(date.year);
    }
  }

  //Create a map of years with sub-map for months to capture counts
  Map<int, Map<int, int>> dataMap = {};
  for(int selectedYear in years){
    Map<int,int> chartData = <int,int>{};
    //Populate Months
    for(int i = 12 ; i >= 1; i--){
      chartData[i] = 0;
    }
    //Populate Counts
    for(DateTime wearDate in watch.wearList){
      if(wearDate.year == selectedYear) {
        int month = wearDate.month;
        chartData.update(month, (value) => ++value);
      }
    }
    //Update Map
    dataMap[selectedYear] = chartData;
  }

  //Create return list of data objects
  List<MonthWearDataV2> getChartData = [];

  //Convert to objects and populate list
  for(var currentYear in dataMap.entries){
    //we're in the first map, iterate over the second
    for(var currentMonth in dataMap[currentYear.key]!.entries){
      getChartData.add(MonthWearDataV2(currentYear.key, currentMonth.key.toString(), currentMonth.value));
    }
  }

  //return the data
  return getChartData;
}

class MonthWearData{
  MonthWearData(this.month, this.count);
  final String month;
  final int count;
}

class MonthWearDataV2{
  MonthWearDataV2(this.year, this.month, this.count);
  final int year;
  final String month;
  final int count;
}

