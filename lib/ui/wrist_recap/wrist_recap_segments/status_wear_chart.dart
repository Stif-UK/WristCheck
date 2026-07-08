import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/util/helper_classes.dart';

class StatusWearChart extends StatefulWidget {
  StatusWearChart({super.key});

  @override
  State<StatusWearChart> createState() => _StatusWearChartState();
}

class _StatusWearChartState extends State<StatusWearChart> {
  bool isDonut = false;

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
                Text(AppLocalizations.of(context)!.statusChartTitle,
                    style: Theme.of(context).textTheme.bodyLarge),
                IconButton(
                  icon: Icon(
                    isDonut ? FontAwesomeIcons.chartSimple : FontAwesomeIcons.chartPie,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      isDonut = !isDonut;
                    });
                  },
                ),
              ],
            ),
            isDonut
                ? SfCircularChart(
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    series: _getDonutSeries(),
                  )
                : SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      isVisible: false,
                    ),
                    primaryYAxis: NumericAxis(),
                    series: _getBarSeries()),
          ],
        ),
      ),
    );
  }

  List<BarSeries<StatusWornClass, String>> _getBarSeries() {
    final recapController = Get.find<WristRecapController>();

    return <BarSeries<StatusWornClass, String>>[
      BarSeries(
        dataSource: recapController.statusWorn.reversed.toList(),
        xValueMapper: (StatusWornClass series, _) => series.status,
        yValueMapper: (StatusWornClass series, _) => series.count,
        dataLabelMapper: (series, _) =>
            "${series.status} : ${series.count} (${series.percentage})",
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ];
  }

  List<DoughnutSeries<StatusWornClass, String>> _getDonutSeries() {
    final recapController = Get.find<WristRecapController>();

    return <DoughnutSeries<StatusWornClass, String>>[
      DoughnutSeries<StatusWornClass, String>(
        dataSource: recapController.statusWorn.toList(),
        xValueMapper: (StatusWornClass series, _) => series.status,
        yValueMapper: (StatusWornClass series, _) => series.count,
        dataLabelMapper: (series, _) => "${series.percentage}",
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelPosition: ChartDataLabelPosition.outside),
        enableTooltip: true,
      )
    ];
  }
}
