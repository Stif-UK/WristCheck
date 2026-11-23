import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class MovementChart extends StatefulWidget {
  const MovementChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<MovementChart> createState() => _MovementChartState();
}

class _MovementChartState extends State<MovementChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();

    // Calculate the chart data - generate a map of movements and counts
    final Map<MovementEnum, int> chartData = <MovementEnum, int>{};
    for (var watch in data) {
      if (watch.movement != null) {
        final MovementEnum movement =
            WristCheckFormatter.getMovementEnum(watch.movement);
        chartData.update(
          movement,
          (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }

    // Remove blank entries
    chartData.remove(MovementEnum.blank);

    // Sort descending by count so Bar (reversed) puts largest at top and circular puts largest first
    final sortedEntries = chartData.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final List<MovementData> getChartData = sortedEntries
        .map((item) => MovementData(item.key, item.value))
        .toList();

    return Obx(
      () => buildRecapCategoricalChart<MovementData>(
        chartType: collectionStatsController.movementChartType.value,
        items: getChartData,
        labelOf: (MovementData item) => item.movement.toLocalizedString(context),
        countOf: (MovementData item) => item.count,
        barDataLabelOf: (MovementData item) =>
            "${item.movement.toLocalizedString(context)}: ${item.count}",
        circularDataLabelOf: (MovementData item) =>
            "${item.movement.toLocalizedString(context)}: ${item.count}",
        radialDataLabelOf: (MovementData item) => "${item.count}",
      ),
    );
  }
}

class MovementData {
  MovementData(this.movement, this.count);
  final MovementEnum movement;
  final int count;
}

