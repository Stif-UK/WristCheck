import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/helper_classes.dart';

class BrandChart extends StatefulWidget {
  const BrandChart({super.key});

  @override
  State<BrandChart> createState() => _BrandChartState();
}

class _BrandChartState extends State<BrandChart> {
  bool isExpanded = false;
  RecapCategoryChartType _chartType = RecapCategoryChartType.bar;

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
                  child: Text(
                    AppLocalizations.of(context)!.brandChartTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('brand_chart_expand_button'),
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
                      key: const Key('brand_chart_type_button'),
                      icon: buildCategoryChartTypeIcon(_chartType),
                      onPressed: () {
                        setState(() {
                          _chartType = nextCategoryChartType(_chartType);
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
              // Linear scaling: height increases every 10 brands from the base height
              int count = recapController.brandsWorn.length;
              double heightMultiplier = (count / 10).ceilToDouble();
              if (heightMultiplier < 1.0) heightMultiplier = 1.0;

              double chartHeight = baseHeight * heightMultiplier;
              if (isExpanded) {
                chartHeight *= 1.5;
              }

              return SizedBox(
                height: chartHeight,
                child: buildRecapCategoricalChart<ManufacturersWornClass>(
                  chartType: _chartType,
                  items: recapController.brandsWorn.toList(),
                  labelOf: (ManufacturersWornClass item) => item.manufacturer,
                  countOf: (ManufacturersWornClass item) => item.count,
                  barDataLabelOf: (ManufacturersWornClass item) =>
                      item.percentage != null
                          ? "${item.manufacturer} : ${item.count} (${item.percentage})"
                          : "${item.manufacturer} : ${item.count}",
                  circularDataLabelOf: (ManufacturersWornClass item) =>
                      "${item.manufacturer}: ${item.count}",
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
