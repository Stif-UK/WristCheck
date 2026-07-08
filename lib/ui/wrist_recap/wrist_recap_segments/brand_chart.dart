import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';

class BrandChart extends StatelessWidget {
  const BrandChart({super.key});

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
            Text(AppLocalizations.of(context)!.brandChartTitle, style: Theme.of(context).textTheme.bodyLarge),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                isVisible: false,
              ),
              primaryYAxis: NumericAxis(),
              series: _getBarSeries()
            )
          ],
        ),
      ),
    );
  }

  List<BarSeries<dynamic, dynamic>> _getBarSeries() {
    final recapController = Get.put(WristRecapController());

    return <BarSeries<ManufacturersWornClass, String>>[
      BarSeries(
        dataSource: recapController.brandsWorn.reversed.toList(),
        xValueMapper: (ManufacturersWornClass series, _) => series.manufacturer,
        yValueMapper: (ManufacturersWornClass series, _) => series.count,
        dataLabelMapper: (series, _) => "${series.manufacturer} : ${series.count} (${series.percentage})",
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ];
  }
}
