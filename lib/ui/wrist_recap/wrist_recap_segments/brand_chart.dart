import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';

class BrandChart extends StatefulWidget {
  const BrandChart({super.key});

  @override
  State<BrandChart> createState() => _BrandChartState();
}

class _BrandChartState extends State<BrandChart> {
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
                Text(AppLocalizations.of(context)!.brandChartTitle, style: Theme.of(context).textTheme.bodyLarge),
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
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  primaryYAxis: NumericAxis(),
                  series: _getBarSeries(),
                ),
              );
            }),
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
