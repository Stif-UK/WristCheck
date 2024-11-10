import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/watch_year_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';

class WatchYearChart extends StatelessWidget {
  WatchYearChart({
    required this.currentWatch,
    super.key});

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());
  TooltipBehavior _tooltipBehavior =  TooltipBehavior(enable: true);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> _getChart(wristCheckController.yearChartPreference.value));
  }

  Widget _getChart(WatchYearChartEnum chartType){
    Widget returnChart;

    switch(chartType) {
      case WatchYearChartEnum.bar:
        returnChart = _buildBarChart(_getBasicChartData(currentWatch));
        break;
      case WatchYearChartEnum.pie:
        returnChart = _buildPieChart(_getBasicChartData(currentWatch), _tooltipBehavior);
        break;
      default:
        returnChart = _buildBarChart(_getBasicChartData(currentWatch));
        break;
    }


    return returnChart;
  }

  _buildBarChart(List<YearWearData> data){
    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<YearWearData, String>(
          dataSource: data,
          xValueMapper: (YearWearData value, _) => value.year,
          yValueMapper: (YearWearData value, _) => value.count,
          dataLabelMapper: (value, _)=> "${value.year}: ${value.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true,),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }

  _buildPieChart(List<YearWearData> data, TooltipBehavior tooltip){
    return SfCircularChart(
        tooltipBehavior: tooltip,
        legend: Legend(isVisible: true,
            overflowMode: LegendItemOverflowMode.scroll),
        series: <CircularSeries<YearWearData, String>>[
          DoughnutSeries<YearWearData, String>(
              dataSource: data,
              xValueMapper: (YearWearData data, _) => data.year,
              yValueMapper: (YearWearData data, _) => data.count,
              dataLabelSettings: DataLabelSettings(isVisible: true, showZeroValue: false),
              enableTooltip: true)
        ]);
  }

  List<YearWearData> _getBasicChartData(Watches watch) {


    //Calculate the chart data - generate a map of years and counts for basic pie and bar charts
    Map<int,int> chartData = <int,int>{};
    // //Populate Years
    // for(int i = 12 ; i >= 1; i--){
    //   chartData[i] = 0;
    // }
    //Populate Counts
    for(DateTime wearDate in watch.wearList){
      int year = wearDate.year;
      //chartData.putIfAbsent(year, (value) => ++value);
      if(!chartData.containsKey(year)){
        chartData[year] = 0;
      }
      chartData.update(year, (value) => ++value);
    }

    List<YearWearData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(YearWearData(item.key.toString(), item.value));
    }

    return getChartData;
  }

}

class YearWearData{
  YearWearData(this.year, this.count);
  final String year;
  final int count;

  @override
  String toString() {
    return "$year : $count";
  }
}
