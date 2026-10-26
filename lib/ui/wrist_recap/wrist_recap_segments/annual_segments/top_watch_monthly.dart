import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TopWatchMonthly extends StatefulWidget {
  const TopWatchMonthly({super.key});

  @override
  State<TopWatchMonthly> createState() => _TopWatchMonthlyState();
}

class _TopWatchMonthlyState extends State<TopWatchMonthly> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final recapController = Get.find<WristRecapController>();

    return Obx(() {
      if (recapController.selectedRecapOption.value != WristRecapEnums.annually || recapController.topWatchMonthly.isEmpty) {
        return const SizedBox.shrink();
      }

      // Check if there are actually any watches worn in any month
      bool hasData = recapController.topWatchMonthly.any((element) => element.count > 0);
      if (!hasData) return const SizedBox.shrink();

      double baseHeight = MediaQuery.of(context).size.height * 0.35;
      int count = recapController.topWatchMonthly.length;
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
                    AppLocalizations.of(context)!.topWatchMonthlyTitle,
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
                  series: <CartesianSeries<TopWatchMonthlyClass, String>>[
                    BarSeries<TopWatchMonthlyClass, String>(
                      dataSource: recapController.topWatchMonthly,
                      xValueMapper: (TopWatchMonthlyClass data, _) =>
                          WristCheckFormatter.getMonthName(data.month),
                      yValueMapper: (TopWatchMonthlyClass data, _) => data.count,
                      dataLabelMapper: (TopWatchMonthlyClass data, _) =>
                          data.watch?.toString() ?? "",
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
