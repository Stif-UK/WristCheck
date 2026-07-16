import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class TopBrandMonthly extends StatelessWidget {
  const TopBrandMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    final recapController = Get.find<WristRecapController>();

    return Obx(() {
      if (recapController.monthView.value || recapController.topBrandMonthly.isEmpty) {
        return const SizedBox.shrink();
      }

      if (!recapController.duplicateBrand.value) return const SizedBox.shrink();

      // Check if there are actually any brands worn in any month
      bool hasData = recapController.topBrandMonthly.any((element) => element.count > 0);
      if (!hasData) return const SizedBox.shrink();

      return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.topBrandMonthlyTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              SfCartesianChart(
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
            ],
          ),
        ),
      );
    });
  }
}
