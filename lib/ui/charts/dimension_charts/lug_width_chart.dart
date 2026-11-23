import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';

class LugWidthChart extends StatefulWidget {
  const LugWidthChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<LugWidthChart> createState() => _LugWidthChartState();
}

class _LugWidthChartState extends State<LugWidthChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data = List<Watches>.from(
      widget.watchesOverride ?? Boxes.getCollectionWatches(),
    );

    // Remove nulls and zeros, and sort based on lug width descending
    data.removeWhere((watch) => watch.lugWidth == null || watch.lugWidth == 0);
    data.sort((a, b) => b.lugWidth!.compareTo(a.lugWidth!));

    final Map<String, int> chartData = <String, int>{};
    for (var watch in data) {
      chartData.update(
        watch.lugWidth.toString(),
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    final List<LugWidthData> getChartData = chartData.entries
        .map((item) => LugWidthData(item.key, item.value))
        .toList();

    return Column(
      children: [
        Obx(
          () => buildRecapCategoricalChart<LugWidthData>(
            chartType: collectionStatsController.lugWidthChartType.value,
            items: getChartData,
            labelOf: (LugWidthData item) => "${item.lugwidth}mm",
            countOf: (LugWidthData item) => item.count,
            barDataLabelOf: (LugWidthData item) =>
                "${item.lugwidth}mm: ${item.count}",
            circularDataLabelOf: (LugWidthData item) =>
                "${item.lugwidth}mm: ${item.count}",
            reverseForBar: false,
          ),
        ),
        Text(_getMedianLugWidth(context, data)),
      ],
    );
  }
}

String _getMedianLugWidth(BuildContext context, List<Watches> data) {
  String returnString = "";

  if (data.isNotEmpty) {
    final valid =
        data.where((watch) => watch.lugWidth != null && watch.lugWidth != 0);
    final List<int> lugWidthList = valid.map((obj) => obj.lugWidth!).toList();

    final String median = ChartHelper.getMedianAsString(lugWidthList, "mm");
    if (median.length > 1) {
      returnString = AppLocalizations.of(context)!.medianLugWidth(median);
    }
  }
  return returnString;
}

class LugWidthData {
  LugWidthData(this.lugwidth, this.count);
  final String lugwidth;
  final int count;
}

