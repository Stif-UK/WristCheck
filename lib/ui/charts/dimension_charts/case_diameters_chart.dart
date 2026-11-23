import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_diameter_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CaseDiameterChart extends StatefulWidget {
  const CaseDiameterChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<CaseDiameterChart> createState() => _CaseDiameterChartState();
}

class _CaseDiameterChartState extends State<CaseDiameterChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data = List<Watches>.from(
      widget.watchesOverride ?? Boxes.getCollectionWatches(),
    );

    // Remove nulls and zeros and sort descending based on case diameter
    data.removeWhere(
      (watch) => watch.caseDiameter == null || watch.caseDiameter == 0.0,
    );
    data.sort((a, b) => b.caseDiameter!.compareTo(a.caseDiameter!));

    final Map<String, int> chartData = <String, int>{};
    for (var watch in data) {
      chartData.update(
        watch.caseDiameter.toString(),
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }
    chartData.remove("0.0");

    final List<DiameterData> getChartData = chartData.entries
        .map((item) => DiameterData(item.key, item.value))
        .toList();

    return Column(
      children: [
        Obx(
          () => _buildChart(
            collectionStatsController.caseDiameterChartType.value,
            data,
            getChartData,
          ),
        ),
        Text(_calculateAverageCaseDiameter(context, data)),
      ],
    );
  }

  Widget _buildChart(
    CaseDiameterChartEnum type,
    List<Watches> watches,
    List<DiameterData> groupedData,
  ) {
    switch (type) {
      case CaseDiameterChartEnum.line:
        return SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<Watches, String>(
              dataSource: watches,
              xValueMapper: (Watches watch, _) => watch.toString(),
              yValueMapper: (Watches watch, _) => watch.caseDiameter,
              dataLabelMapper: (watch, _) =>
                  "${WristCheckFormatter.getLocalizedDecimal(watch.caseDiameter)}mm",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              markerSettings: const MarkerSettings(isVisible: true),
              enableTooltip: true,
            ),
          ],
          primaryXAxis: CategoryAxis(isVisible: false),
        );
      case CaseDiameterChartEnum.bar:
        return SfCartesianChart(
          series: <CartesianSeries>[
            BarSeries<DiameterData, String>(
              dataSource: groupedData,
              xValueMapper: (DiameterData item, _) => item.diameter,
              yValueMapper: (DiameterData item, _) => item.count,
              dataLabelMapper: (item, _) =>
                  "${WristCheckFormatter.getLocalizedDecimal(double.tryParse(item.diameter))}mm: ${item.count}",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
          primaryXAxis: CategoryAxis(isVisible: false),
        );
    }
  }
}

String _calculateAverageCaseDiameter(BuildContext context, List<Watches> data) {
  String returnString = "";
  final valid = data
      .where((watch) => watch.caseDiameter != null && watch.caseDiameter != 0.0)
      .toList();
  if (valid.isNotEmpty) {
    final double average = valid.map((m) => m.caseDiameter!).average;
    returnString = AppLocalizations.of(context)!.averageCaseDiameter(
      WristCheckFormatter.getLocalizedDecimal(average, 2),
    );
  }
  return returnString;
}

class DiameterData {
  DiameterData(this.diameter, this.count);
  final String diameter;
  final int count;
}

