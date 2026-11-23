import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CategoryChart extends StatefulWidget {
  const CategoryChart({Key? key, this.watchesOverride}) : super(key: key);

  final List<Watches>? watchesOverride;

  @override
  State<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();

    // Calculate the chart data - generate a map of categories and counts
    final Map<CategoryEnum, int> chartData = <CategoryEnum, int>{};
    for (var watch in data) {
      if (watch.category != null) {
        final CategoryEnum category =
            WristCheckFormatter.getCategoryEnum(watch.category);
        chartData.update(
          category,
          (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }

    // Remove blank entries
    chartData.remove(CategoryEnum.blank);

    // Sort descending by count
    final sortedEntries = chartData.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value));

    final List<CategoryData> getChartData = sortedEntries
        .map((item) => CategoryData(item.key, item.value))
        .toList();

    return Obx(
      () => buildRecapCategoricalChart<CategoryData>(
        chartType: collectionStatsController.categoryChartType.value,
        items: getChartData,
        labelOf: (CategoryData item) => item.category.toLocalizedString(context),
        countOf: (CategoryData item) => item.count,
        barDataLabelOf: (CategoryData item) =>
            "${item.category.toLocalizedString(context)}: ${item.count}",
        circularDataLabelOf: (CategoryData item) =>
            "${item.category.toLocalizedString(context)}: ${item.count}",
        radialDataLabelOf: (CategoryData item) => "${item.count}",
      ),
    );
  }
}

class CategoryData {
  CategoryData(this.category, this.count);
  final CategoryEnum category;
  final int count;
}

