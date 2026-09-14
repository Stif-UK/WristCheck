import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';

class ColourChart extends StatefulWidget {
  const ColourChart({Key? key}) : super(key: key);

  @override
  State<ColourChart> createState() => _ColourChartState();
}

class _ColourChartState extends State<ColourChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.find<CollectionStatsController>();
    final List<Watches> data = Boxes.getCollectionWatches();

    Map<String, int> chartData = <String, int>{};
    for (var watch in data) {
      if (watch.primaryColour != null && watch.primaryColour!.trim().isNotEmpty) {
        String colour = watch.primaryColour!.trim();
        chartData.update(colour, (value) => ++value, ifAbsent: () => 1);
      }
    }

    var sortedEntries = chartData.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value));

    List<ColourData> getChartData = sortedEntries
        .map((e) => ColourData(e.key, e.value))
        .toList();

    if (getChartData.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text("No colour data recorded"),
        ),
      );
    }

    return Obx(() {
      switch (collectionStatsController.colourChartType.value) {
        case ColourChartEnum.bar:
          return SfCartesianChart(
            series: <CartesianSeries>[
              BarSeries<ColourData, String>(
                dataSource: getChartData,
                xValueMapper: (ColourData item, _) => item.colour,
                yValueMapper: (ColourData item, _) => item.count,
                dataLabelMapper: (ColourData item, _) => "${item.colour}: ${item.count}",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
            primaryXAxis: CategoryAxis(isVisible: false),
          );
        case ColourChartEnum.pie:
          return SfCircularChart(
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries<ColourData, String>>[
              PieSeries<ColourData, String>(
                dataSource: getChartData,
                xValueMapper: (ColourData item, _) => item.colour,
                yValueMapper: (ColourData item, _) => item.count,
                dataLabelMapper: (ColourData item, _) => "${item.colour}: ${item.count}",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
                enableTooltip: true,
              )
            ],
          );
        case ColourChartEnum.donut:
          return SfCircularChart(
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries<ColourData, String>>[
              DoughnutSeries<ColourData, String>(
                dataSource: getChartData,
                xValueMapper: (ColourData item, _) => item.colour,
                yValueMapper: (ColourData item, _) => item.count,
                dataLabelMapper: (ColourData item, _) => "${item.colour}: ${item.count}",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
                enableTooltip: true,
              )
            ],
          );
      }
    });
  }
}

class ColourData {
  ColourData(this.colour, this.count);
  final String colour;
  final int count;
}
