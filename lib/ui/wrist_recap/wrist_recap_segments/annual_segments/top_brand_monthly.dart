import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TopBrandMonthly extends StatefulWidget {
  const TopBrandMonthly({super.key});

  @override
  State<TopBrandMonthly> createState() => _TopBrandMonthlyState();
}

class _TopBrandMonthlyState extends State<TopBrandMonthly> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final recapController = Get.find<WristRecapController>();

    return Obx(() {
      if (recapController.selectedRecapOption.value != WristRecapEnums.annually || recapController.topBrandMonthly.isEmpty) {
        return const SizedBox.shrink();
      }

      if (!recapController.duplicateBrand.value) return const SizedBox.shrink();

      // Check if there are actually any brands worn in any month
      bool hasData = recapController.topBrandMonthly.any((element) => element.count > 0);
      if (!hasData) return const SizedBox.shrink();

      double baseHeight = MediaQuery.of(context).size.height * 0.35;
      int count = recapController.topBrandMonthly.length;
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
                    AppLocalizations.of(context)!.topBrandMonthlyTitle,
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
                  series: <CartesianSeries<TopBrandMonthlyClass, String>>[
                    BarSeries<TopBrandMonthlyClass, String>(
                      dataSource: recapController.topBrandMonthly,
                      xValueMapper: (TopBrandMonthlyClass data, _) =>
                          WristCheckFormatter.getMonthName(data.month),
                      yValueMapper: (TopBrandMonthlyClass data, _) => data.count,
                      dataLabelMapper: (TopBrandMonthlyClass data, _) =>
                          data.brand ?? "",
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
