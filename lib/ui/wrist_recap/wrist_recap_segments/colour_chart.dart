import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_completeness_indicator.dart';
import 'package:wristcheck/util/helper_classes.dart';

class WristRecapColourChart extends StatefulWidget {
  const WristRecapColourChart({super.key});

  @override
  State<WristRecapColourChart> createState() => _WristRecapColourChartState();
}

class _WristRecapColourChartState extends State<WristRecapColourChart> {
  ColourChartEnum _chartType = ColourChartEnum.stackedBar;
  bool isExpanded = false;

  void _cycleChartType() {
    setState(() {
      switch (_chartType) {
        case ColourChartEnum.stackedBar:
          _chartType = ColourChartEnum.pie;
          break;
        case ColourChartEnum.pie:
          _chartType = ColourChartEnum.donut;
          break;
        case ColourChartEnum.donut:
          _chartType = ColourChartEnum.stackedBar;
          break;
      }
    });
  }

  Widget _buildChartTypeIcon(ColourChartEnum chartType) {
    switch (chartType) {
      case ColourChartEnum.pie:
        return const FaIcon(FontAwesomeIcons.chartPie, size: 16);
      case ColourChartEnum.donut:
        return const Icon(Icons.donut_large, size: 20);
      case ColourChartEnum.stackedBar:
        return const FaIcon(FontAwesomeIcons.layerGroup, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(() => RecapCompletenessIndicator(
                                isComplete: Get.find<WristRecapController>()
                                    .coloursComplete
                                    .value,
                              )),
                          Expanded(
                            child: Text(
                              l.colourChartTitle,
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (_chartType == ColourChartEnum.pie ||
                          _chartType == ColourChartEnum.donut)
                        Text(
                          l.primaryColourOnlySubHeader,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('colour_chart_expand_button'),
                      icon: FaIcon(
                        isExpanded
                            ? FontAwesomeIcons.compress
                            : FontAwesomeIcons.expand,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      key: const Key('colour_chart_type_button'),
                      icon: _buildChartTypeIcon(_chartType),
                      onPressed: _cycleChartType,
                    ),
                  ],
                ),
              ],
            ),
            Obx(() {
              final recapController = Get.find<WristRecapController>();
              final List<ColourData> chartData =
                  recapController.coloursWorn.toList();

              final double baseHeight =
                  MediaQuery.of(context).size.height * 0.35;
              final int count = chartData.length;
              double heightMultiplier = (count / 10).ceilToDouble();
              if (heightMultiplier < 1.0) heightMultiplier = 1.0;

              double chartHeight = baseHeight * heightMultiplier;
              if (isExpanded) {
                chartHeight *= 1.5;
              }

              final List<ColourData> primaryOnlyData = chartData
                  .where((item) => item.primaryCount > 0)
                  .toList()
                ..sort((a, b) => a.primaryCount.compareTo(b.primaryCount));

              Widget chartWidget;
              if (_chartType == ColourChartEnum.pie) {
                chartWidget = primaryOnlyData.isEmpty
                    ? Center(child: Text(l.noColourDataRecorded))
                    : SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: <CircularSeries<ColourData, String>>[
                          PieSeries<ColourData, String>(
                            dataSource: primaryOnlyData,
                            xValueMapper: (ColourData item, _) => item.colour,
                            yValueMapper: (ColourData item, _) =>
                                item.primaryCount,
                            dataLabelMapper: (ColourData item, _) =>
                                "${item.colour}: ${item.primaryCount}",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            enableTooltip: true,
                          ),
                        ],
                      );
              } else if (_chartType == ColourChartEnum.donut) {
                chartWidget = primaryOnlyData.isEmpty
                    ? Center(child: Text(l.noColourDataRecorded))
                    : SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: <CircularSeries<ColourData, String>>[
                          DoughnutSeries<ColourData, String>(
                            dataSource: primaryOnlyData,
                            xValueMapper: (ColourData item, _) => item.colour,
                            yValueMapper: (ColourData item, _) =>
                                item.primaryCount,
                            dataLabelMapper: (ColourData item, _) =>
                                "${item.colour}: ${item.primaryCount}",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            enableTooltip: true,
                          ),
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
                      name: l.primaryColourLabel,
                      dataSource: chartData,
                      xValueMapper: (ColourData item, _) => item.colour,
                      yValueMapper: (ColourData item, _) => item.primaryCount,
                      dataLabelMapper: (ColourData item, _) =>
                          item.primaryCount > 0 ? "${item.primaryCount}" : "",
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                    StackedBarSeries<ColourData, String>(
                      name: l.secondaryColourLabel,
                      dataSource: chartData,
                      xValueMapper: (ColourData item, _) => item.colour,
                      yValueMapper: (ColourData item, _) => item.secondaryCount,
                      dataLabelMapper: (ColourData item, _) =>
                          item.secondaryCount > 0
                              ? "${item.secondaryCount}"
                              : "",
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              }

              return SizedBox(
                height: chartHeight,
                child: chartWidget,
              );
            }),
          ],
        ),
      ),
    );
  }
}
