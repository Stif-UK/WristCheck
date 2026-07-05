import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

class MonthlyWearChart extends StatelessWidget {
  MonthlyWearChart({super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monthly wear chart"),
        SfCartesianChart(
        primaryXAxis: CategoryAxis(
        isVisible: false,
        ),
        primaryYAxis: NumericAxis(),
        series: _getBarSeries()
        )
          ],
        ),
      ),
    );
  }
}

List<BarSeries<dynamic, dynamic>> _getBarSeries() {
  List<BarSeries<dynamic, dynamic>> returnSeries = [];
  final recapController = Get.put(WristRecapMonthlyController());

  returnSeries = <BarSeries<WornWatchesClass, String>>[
    BarSeries(
      dataSource: recapController.watchesWorn.reversed.toList(),
      xValueMapper: (WornWatchesClass series, _) =>
      (series.watch.toString()),
      yValueMapper: (WornWatchesClass series, _) =>
      series.count,
      dataLabelMapper: (wornWatch, _) =>
      "${wornWatch.watch
          .toString()} ${WearChartsHelper.getLabelSuffix(wornWatch.watch)}: ${wornWatch.count}",
      dataLabelSettings: const DataLabelSettings(
          isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
      // animationDuration: 0 Set to zero to stop it animating!
    )
  ];

  return returnSeries;
}
