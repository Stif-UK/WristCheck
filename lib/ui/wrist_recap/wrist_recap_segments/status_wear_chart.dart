import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_completeness_indicator.dart';
import 'package:wristcheck/util/helper_classes.dart';

class StatusWearChart extends StatefulWidget {
  StatusWearChart({super.key});

  @override
  State<StatusWearChart> createState() => _StatusWearChartState();
}

class _StatusWearChartState extends State<StatusWearChart> {
  RecapCategoryChartType _chartType = RecapCategoryChartType.bar;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    children: [
                      Obx(() => RecapCompletenessIndicator(
                            isComplete: Get.find<WristRecapController>()
                                .statusComplete
                                .value,
                          )),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.statusChartTitle,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('status_chart_expand_button'),
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
                      key: const Key('status_chart_type_button'),
                      icon: buildCategoryChartTypeIcon(_chartType),
                      onPressed: () {
                        setState(() {
                          _chartType = nextCategoryChartType(
                            _chartType,
                            includeRadialBar: true,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Obx(() {
              final recapController = Get.find<WristRecapController>();
              double baseHeight = MediaQuery.of(context).size.height * 0.35;
              int count = recapController.statusWorn.length;
              double heightMultiplier = (count / 10).ceilToDouble();
              if (heightMultiplier < 1.0) heightMultiplier = 1.0;

              double chartHeight = baseHeight * heightMultiplier;
              if (isExpanded) {
                chartHeight *= 1.5;
              }

              return SizedBox(
                height: chartHeight,
                child: buildRecapCategoricalChart<StatusWornClass>(
                  chartType: _chartType,
                  items: recapController.statusWorn.toList(),
                  labelOf: (StatusWornClass item) => item.status,
                  countOf: (StatusWornClass item) => item.count,
                  barDataLabelOf: (StatusWornClass item) =>
                      item.percentage != null
                          ? "${item.status} : ${item.count} (${item.percentage})"
                          : "${item.status} : ${item.count}",
                  circularDataLabelOf: (StatusWornClass item) =>
                      item.percentage != null
                          ? "${item.status}: ${item.percentage}"
                          : "${item.status}: ${item.count}",
                  radialDataLabelOf: (StatusWornClass item) =>
                      item.percentage ?? "${item.count}",
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
