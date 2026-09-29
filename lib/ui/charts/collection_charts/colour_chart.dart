import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
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

    Map<String, _ColourCounts> colourCounts = {};

    for (var watch in data) {
      if (watch.primaryColour != null && watch.primaryColour!.trim().isNotEmpty) {
        String pCol = watch.primaryColour!.trim();
        colourCounts.putIfAbsent(pCol, () => _ColourCounts());
        colourCounts[pCol]!.primaryCount++;
      }
      if (watch.secondaryColour != null && watch.secondaryColour!.trim().isNotEmpty) {
        String sCol = watch.secondaryColour!.trim();
        colourCounts.putIfAbsent(sCol, () => _ColourCounts());
        colourCounts[sCol]!.secondaryCount++;
      }
    }

    List<ColourData> getChartData = colourCounts.entries.map((e) {
      return ColourData(e.key, e.value.primaryCount, e.value.secondaryCount);
    }).toList();

    getChartData.sort((a, b) => a.totalCount.compareTo(b.totalCount));

    if (getChartData.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(AppLocalizations.of(context)!.noColourDataRecorded),
        ),
      );
    }

    List<ColourData> primaryOnlyData = getChartData
        .where((item) => item.primaryCount > 0)
        .toList()
      ..sort((a, b) => a.primaryCount.compareTo(b.primaryCount));

    return Obx(() {
      final chartType = collectionStatsController.colourChartType.value;
      if (chartType == ColourChartEnum.pie) {
        return SfCircularChart(
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries<ColourData, String>>[
            PieSeries<ColourData, String>(
              dataSource: primaryOnlyData,
              xValueMapper: (ColourData item, _) => item.colour,
              yValueMapper: (ColourData item, _) => item.primaryCount,
              dataLabelMapper: (ColourData item, _) =>
                  "${item.colour}: ${item.primaryCount}",
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
            )
          ],
        );
      } else if (chartType == ColourChartEnum.donut) {
        return SfCircularChart(
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries<ColourData, String>>[
            DoughnutSeries<ColourData, String>(
              dataSource: primaryOnlyData,
              xValueMapper: (ColourData item, _) => item.colour,
              yValueMapper: (ColourData item, _) => item.primaryCount,
              dataLabelMapper: (ColourData item, _) =>
                  "${item.colour}: ${item.primaryCount}",
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
            )
          ],
        );
      } else {
        return SfCartesianChart(
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.top,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          primaryXAxis: CategoryAxis(isVisible: true),
          primaryYAxis: NumericAxis(),
          series: <CartesianSeries>[
            StackedBarSeries<ColourData, String>(
              name: AppLocalizations.of(context)!.primaryColourLabel,
              dataSource: getChartData,
              xValueMapper: (ColourData item, _) => item.colour,
              yValueMapper: (ColourData item, _) => item.primaryCount,
              dataLabelMapper: (ColourData item, _) =>
                  item.primaryCount > 0 ? "${item.primaryCount}" : "",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            StackedBarSeries<ColourData, String>(
              name: AppLocalizations.of(context)!.secondaryColourLabel,
              dataSource: getChartData,
              xValueMapper: (ColourData item, _) => item.colour,
              yValueMapper: (ColourData item, _) => item.secondaryCount,
              dataLabelMapper: (ColourData item, _) =>
                  item.secondaryCount > 0 ? "${item.secondaryCount}" : "",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      }
    });
  }
}

class _ColourCounts {
  int primaryCount = 0;
  int secondaryCount = 0;
}

class ColourData {
  ColourData(this.colour, this.primaryCount, this.secondaryCount);
  final String colour;
  final int primaryCount;
  final int secondaryCount;
  int get totalCount => primaryCount + secondaryCount;
}
