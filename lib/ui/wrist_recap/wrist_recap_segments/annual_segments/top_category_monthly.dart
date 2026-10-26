import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TopCategoryMonthly extends StatefulWidget {
  const TopCategoryMonthly({super.key});

  @override
  State<TopCategoryMonthly> createState() => _TopCategoryMonthlyState();
}

class _TopCategoryMonthlyState extends State<TopCategoryMonthly> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final recapController = Get.find<WristRecapController>();

    return Obx(() {
      if (recapController.selectedRecapOption.value != WristRecapEnums.annually || recapController.topCategoryMonthly.isEmpty) {
        return const SizedBox.shrink();
      }

      if (recapController.categoriesWorn.length <= 1) return const SizedBox.shrink();

      // Check if there are actually any categories worn in any month
      bool hasData = recapController.topCategoryMonthly.any((element) => element.count > 0);
      if (!hasData) return const SizedBox.shrink();

      double baseHeight = MediaQuery.of(context).size.height * 0.35;
      int count = recapController.topCategoryMonthly.length;
      double heightMultiplier = (count / 10).ceilToDouble();
      if (heightMultiplier < 1.0) heightMultiplier = 1.0;

      double chartHeight = baseHeight * heightMultiplier;
      if (isExpanded) {
        chartHeight *= 1.5;
      }

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
                  Text(
                    AppLocalizations.of(context)!.topCategoryMonthlyTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: FaIcon(
                      isExpanded ? FontAwesomeIcons.compress : FontAwesomeIcons.expand,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: chartHeight,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                    // Reverse to show Jan at the top
                    isInversed: true,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    interval: 5,
                  ),
                  series: <CartesianSeries<TopCategoryMonthlyClass, String>>[
                    BarSeries<TopCategoryMonthlyClass, String>(
                      dataSource: recapController.topCategoryMonthly,
                      xValueMapper: (TopCategoryMonthlyClass data, _) =>
                          WristCheckFormatter.getMonthName(data.month),
                      yValueMapper: (TopCategoryMonthlyClass data, _) => data.count,
                      dataLabelMapper: (TopCategoryMonthlyClass data, _) =>
                          data.category ?? "",
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.outer,
                        overflowMode: OverflowMode.none,
                        textStyle: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
