import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';

class WaterResistanceChart extends StatefulWidget {
  WaterResistanceChart({
    Key? key,
    this.watchesOverride,
    this.unitOverride,
  }) : super(key: key);

  final List<Watches>? watchesOverride;
  final WRUnitsEnum? unitOverride;

  @override
  State<WaterResistanceChart> createState() => _WaterResistanceChartState();
}

class _WaterResistanceChartState extends State<WaterResistanceChart> {
  WRUnitsEnum get _unit =>
      widget.unitOverride ??
      Get.put(WristCheckController()).waterResistanceUnit.value;

  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data = List<Watches>.from(
      widget.watchesOverride ?? Boxes.getCollectionWatches(),
    );

    // Remove nulls and zeros and sort descending based on water resistance
    data.removeWhere(
      (watch) => watch.waterResistance == null || watch.waterResistance == 0,
    );
    data.sort((a, b) => b.waterResistance!.compareTo(a.waterResistance!));

    final Map<String, int> chartData = <String, int>{};
    for (var watch in data) {
      chartData.update(
        watch.waterResistance.toString(),
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    chartData.remove("0");
    chartData.remove("");

    final List<WaterResistanceData> getChartData = chartData.entries
        .map((item) => WaterResistanceData(item.key, item.value))
        .toList();

    final String unitLabel = _unit.toLocalizedString(context);

    return Column(
      children: [
        Obx(
          () => buildRecapCategoricalChart<WaterResistanceData>(
            chartType: collectionStatsController.waterResistanceChartType.value,
            items: getChartData,
            labelOf: (WaterResistanceData item) =>
                "${item.waterResistance} $unitLabel",
            countOf: (WaterResistanceData item) => item.count,
            barDataLabelOf: (WaterResistanceData item) =>
                "${item.waterResistance} $unitLabel: ${item.count}",
            circularDataLabelOf: (WaterResistanceData item) =>
                "${item.waterResistance} $unitLabel: ${item.count}",
            reverseForBar: false,
          ),
        ),
        Text(_calculateAverageWaterResistance(context, data, unitLabel)),
      ],
    );
  }
}

String _calculateAverageWaterResistance(
  BuildContext context,
  List<Watches> data,
  String unitStr,
) {
  String returnString = "";

  if (data.isNotEmpty) {
    final double average = data.map((watch) => watch.waterResistance!).average;
    final String valueStr =
        double.parse(average.toStringAsFixed(2)).round().toString();
    returnString =
        AppLocalizations.of(context)!.averageWaterResistance(valueStr, unitStr);
  }

  return returnString;
}

class WaterResistanceData {
  WaterResistanceData(this.waterResistance, this.count);
  final String waterResistance;
  final int count;
}

