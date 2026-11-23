import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CaseMaterialChart extends StatefulWidget {
  const CaseMaterialChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<CaseMaterialChart> createState() => _CaseMaterialChartState();
}

class _CaseMaterialChartState extends State<CaseMaterialChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();

    // Calculate the chart data - generate a map of case materials and counts
    final Map<CaseMaterialEnum, int> chartData = <CaseMaterialEnum, int>{};
    for (var watch in data) {
      if (watch.caseMaterial != null) {
        final CaseMaterialEnum material =
            WristCheckFormatter.getCaseMaterialEnum(watch.caseMaterial);
        chartData.update(
          material,
          (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }

    // Remove blank entries
    chartData.remove(CaseMaterialEnum.blank);

    // Sort descending by count
    final sortedEntries = chartData.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final List<CaseMaterialData> getChartData = sortedEntries
        .map((item) => CaseMaterialData(item.key, item.value))
        .toList();

    return Obx(
      () => buildRecapCategoricalChart<CaseMaterialData>(
        chartType: collectionStatsController.caseMaterialChartType.value,
        items: getChartData,
        labelOf: (CaseMaterialData item) =>
            item.caseMaterial.toLocalizedString(context),
        countOf: (CaseMaterialData item) => item.count,
        barDataLabelOf: (CaseMaterialData item) =>
            "${item.caseMaterial.toLocalizedString(context)}: ${item.count}",
        circularDataLabelOf: (CaseMaterialData item) =>
            "${item.caseMaterial.toLocalizedString(context)}: ${item.count}",
        radialDataLabelOf: (CaseMaterialData item) => "${item.count}",
      ),
    );
  }
}

class CaseMaterialData {
  CaseMaterialData(this.caseMaterial, this.count);
  final CaseMaterialEnum caseMaterial;
  final int count;
}

