import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
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
        returnChart = _buildLineChart();
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

Widget _buildLineChart() {
  //TODO: Create Line Chart
  return Container(child: Text("Test Line Chart"),);
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

class MonthWearData{
  MonthWearData(this.month, this.count);
  final String month;
  final int count;
}

class MonthWearDataV2{
  MonthWearDataV2(this.month, this.count);
  final String month;
  final int count;
}

