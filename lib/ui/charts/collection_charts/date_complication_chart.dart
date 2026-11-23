import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class DateComplicationChart extends StatefulWidget {
  const DateComplicationChart({Key? key, this.watchesOverride})
      : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<DateComplicationChart> createState() => _DateComplicationChartState();
}

class _DateComplicationChartState extends State<DateComplicationChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();

    // Calculate the chart data - generate a map of date complications and counts
    final Map<DateComplicationEnum, int> chartData =
        <DateComplicationEnum, int>{};
    for (var watch in data) {
      if (watch.dateComplication != null) {
        final DateComplicationEnum complication =
            WristCheckFormatter.getDateComplicationEnum(watch.dateComplication);
        chartData.update(
          complication,
          (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }

    // Remove blank entries
    chartData.remove(DateComplicationEnum.blank);

    // Sort descending by count
    final sortedEntries = chartData.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final List<DateComplicationData> getChartData = sortedEntries
        .map((item) => DateComplicationData(item.key, item.value))
        .toList();

    return Obx(
      () => buildRecapCategoricalChart<DateComplicationData>(
        chartType: collectionStatsController.dateComplicationChartType.value,
        items: getChartData,
        labelOf: (DateComplicationData item) =>
            item.dateComplication.toLocalizedString(context),
        countOf: (DateComplicationData item) => item.count,
        barDataLabelOf: (DateComplicationData item) =>
            "${item.dateComplication.toLocalizedString(context)}: ${item.count}",
        circularDataLabelOf: (DateComplicationData item) =>
            "${item.dateComplication.toLocalizedString(context)}: ${item.count}",
        radialDataLabelOf: (DateComplicationData item) => "${item.count}",
      ),
    );
  }
}

class DateComplicationData {
  DateComplicationData(this.dateComplication, this.count);
  final DateComplicationEnum dateComplication;
  final int count;
}

