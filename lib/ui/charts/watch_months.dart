import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
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


    return Obx(() => Container(
      child: widget.wristCheckController.monthChartPreference.value == DefaultChartType.bar?
     SfCartesianChart(
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
    ):

    SfCircularChart(
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(isVisible: true,
            overflowMode: LegendItemOverflowMode.scroll),
        series: <CircularSeries<MonthWearData, String>>[
          DoughnutSeries<MonthWearData, String>(
              dataSource: getChartData,
              xValueMapper: (MonthWearData data, _) => "${DateFormat('MMMM').format(DateTime(0, int.parse(data.month)))}" ,
              yValueMapper: (MonthWearData data, _) => data.count,
              dataLabelSettings: DataLabelSettings(isVisible: true, showZeroValue: false),
              enableTooltip: true)
        ])
    ));
  }
}

class MonthWearData{
  MonthWearData(this.month, this.count);
  final String month;
  final int count;
}

