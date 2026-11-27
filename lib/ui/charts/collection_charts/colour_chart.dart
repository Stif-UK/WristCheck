import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';
import 'package:wristcheck/util/helper_classes.dart';

class ColourChart extends StatefulWidget {
  const ColourChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  static int getLinesToDraw(ColourChartEnum chartType, int colourCount) {
    return chartType == ColourChartEnum.stackedBar ? colourCount : 0;
  }

  @override
  State<ColourChart> createState() => _ColourChartState();
}

class _ColourChartState extends State<ColourChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();

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
      final int linesToDraw = ColourChart.getLinesToDraw(
        chartType,
        getChartData.length,
      );
      final double chartHeight =
          ChartHelper.calculateChartSpace(context, linesToDraw);

      Widget chartWidget;
      if (chartType == ColourChartEnum.pie) {
        chartWidget = SfCircularChart(
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
        chartWidget = SfCircularChart(
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
        chartWidget = SfCartesianChart(
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

      return SizedBox(
        key: const Key('colour_chart_sized_box'),
        height: chartHeight,
        child: chartWidget,
      );
    });
  }
}

class _ColourCounts {
  int primaryCount = 0;
  int secondaryCount = 0;
}
