import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/power_reserve_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class PowerReserveChart extends StatefulWidget {
  PowerReserveChart({Key? key}) : super(key: key);
  final collectionStatsController = Get.put(CollectionStatsController());

  @override
  State<PowerReserveChart> createState() => _PowerReserveChartState();
}

class _PowerReserveChartState extends State<PowerReserveChart> {
  final List<Watches> data = Boxes.getCollectionWatches();

  @override
  Widget build(BuildContext context) {
    // Calculate the chart data - remove nulls and zeroes
    data.removeWhere((watch) => watch.powerReserve == null);
    data.removeWhere((watch) => watch.powerReserve == 0);

    // Create the chart and footer text
    return Obx(() => Column(
        children: [
          _getChart(widget.collectionStatsController.powerReserveChartType.value, data),
          Text(_calculateAveragePowerReserve(data))
        ],
      ),
    );
  }
}

Widget _getChart(PowerReserveChartEnum type, List<Watches> data) {
  switch (type) {
    case PowerReserveChartEnum.line:
      return SfCartesianChart(
        series: <CartesianSeries>[
          LineSeries<Watches, String>(
            dataSource: data,
            xValueMapper: (Watches watch, _) => watch.toString(),
            yValueMapper: (Watches watch, _) => watch.powerReserve,
            dataLabelMapper: (watch, _) => "${watch.powerReserve} hrs",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            markerSettings: const MarkerSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
      );
    case PowerReserveChartEnum.bar:
      return SfCartesianChart(
        series: <CartesianSeries>[
          BarSeries<PowerReserveData, String>(
            dataSource: _getChartData(data),
            xValueMapper: (PowerReserveData item, _) => item.powerReserve,
            yValueMapper: (PowerReserveData item, _) => item.count,
            dataLabelMapper: (item, _) => "${item.powerReserve} hrs",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
      );
  }
}

List<PowerReserveData> _getChartData(List<Watches> data) {
  // Start by sorting the watches based on their power reserve (we have already removed nulls)
  data.sort((a, b) => b.powerReserve!.compareTo(a.powerReserve!));

  Map<String, int> chartData = <String, int>{};
  for (var watch in data) {
    if (watch.powerReserve != null) {
      chartData.update(
        watch.powerReserve.toString(),
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }
  }

  // Remove zero values
  if (chartData.containsKey("0")) {
    chartData.remove("0");
  }

  List<PowerReserveData> getChartData = [];
  for (var item in chartData.entries) {
    getChartData.add(PowerReserveData(item.key, item.value));
  }
  return getChartData;
}

String _calculateAveragePowerReserve(List<Watches> data) {
  String returnString = "";

  if (data.isNotEmpty) {
    double average = data.map((m) => m.powerReserve!).average;
    returnString = "Average Power Reserve: ${WristCheckFormatter.getLocalizedDecimal(average, 1)} hours";
  }

  return returnString;
}

class PowerReserveData {
  PowerReserveData(this.powerReserve, this.count);
  final String powerReserve;
  final int count;
}
