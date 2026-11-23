import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/model_year_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';

class ModelYearChart extends StatelessWidget {
  const ModelYearChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        watchesOverride ?? Boxes.getCollectionWatches();

    return Obx(() {
      final groupDecade = collectionStatsController.groupWatchYearByDecade.value;
      final chartType = collectionStatsController.modelYearChartType.value;
      final chartData = _getChartData(data, groupDecade);

      if (chartData.isEmpty) {
        return const SizedBox(height: 0);
      }

      switch (chartType) {
        case ModelYearChartEnum.bar:
          return SfCartesianChart(
            series: <CartesianSeries>[
              BarSeries<YearData, String>(
                dataSource: chartData,
                xValueMapper: (YearData item, _) => item.label,
                yValueMapper: (YearData item, _) => item.count,
                dataLabelMapper: (YearData item, _) =>
                    "${item.label}: ${item.count}",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
            primaryXAxis: CategoryAxis(isVisible: false),
          );
        case ModelYearChartEnum.column:
          return SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(interval: 1),
            primaryYAxis: NumericAxis(interval: 1),
            series: <CartesianSeries>[
              ColumnSeries<YearData, String>(
                dataSource: chartData,
                xValueMapper: (YearData item, _) => item.label,
                yValueMapper: (YearData item, _) => item.count,
                dataLabelMapper: (YearData item, _) => "${item.count}",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true,
              ),
            ],
          );
        case ModelYearChartEnum.splineArea:
          final Color primaryColor = Theme.of(context).colorScheme.primary;
          return SfCartesianChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(interval: 1),
            primaryYAxis: NumericAxis(interval: 1),
            series: <CartesianSeries>[
              SplineAreaSeries<YearData, String>(
                dataSource: chartData,
                xValueMapper: (YearData item, _) => item.label,
                yValueMapper: (YearData item, _) => item.count,
                dataLabelMapper: (YearData item, _) => "${item.count}",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                splineType: SplineType.monotonic,
                color: primaryColor.withValues(alpha: 0.3),
                borderColor: primaryColor,
                borderWidth: 2,
                markerSettings: const MarkerSettings(isVisible: true),
                enableTooltip: true,
              ),
            ],
          );
      }
    });
  }
}

List<YearData> _getChartData(List<Watches> watches, bool groupDecade) {
  final filtered = watches.where((w) => w.year != null && w.year! > 0).toList();

  if (groupDecade) {
    final Map<int, int> decadeCounts = {};
    for (var w in filtered) {
      final int decade = (w.year! ~/ 10) * 10;
      decadeCounts.update(decade, (val) => val + 1, ifAbsent: () => 1);
    }
    final sortedEntries = decadeCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries.map((e) => YearData("${e.key}s", e.value)).toList();
  } else {
    final Map<int, int> yearCounts = {};
    for (var w in filtered) {
      yearCounts.update(w.year!, (val) => val + 1, ifAbsent: () => 1);
    }
    final sortedEntries = yearCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries
        .map((e) => YearData(e.key.toString(), e.value))
        .toList();
  }
}

class YearData {
  YearData(this.label, this.count);
  final String label;
  final int count;
}
