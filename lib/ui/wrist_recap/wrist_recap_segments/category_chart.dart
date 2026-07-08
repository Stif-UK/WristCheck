import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';

class CategoryChart extends StatelessWidget {
  CategoryChart({super.key});

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
            Text(AppLocalizations.of(context)!.categoryChartTitle, style: Theme.of(context).textTheme.bodyLarge),
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
}

List<BarSeries<dynamic, dynamic>> _getBarSeries() {
  final recapController = Get.put(WristRecapController());

  return <BarSeries<CategoriesWornClass, String>>[
    BarSeries(
      dataSource: recapController.categoriesWorn.reversed.toList(),
      xValueMapper: (CategoriesWornClass series, _) => series.category,
      yValueMapper: (CategoriesWornClass series, _) => series.count,
      dataLabelMapper: (series, _) => "${series.category} : ${series.count} (${series.percentage})",
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    )
  ];
}
