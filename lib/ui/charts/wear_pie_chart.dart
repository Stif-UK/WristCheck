import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WearPieChart extends StatelessWidget {
  // const WearChart({Key? key}) : super(key: key);

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;


  const WearPieChart({required this.data, required this.animate});

  @override
  Widget build(BuildContext context) {

    return SfCircularChart(
        series: <PieSeries<Watches, String>>[
          PieSeries<Watches, String>(
              dataSource:  data,
              explode: true,
              explodeIndex: 0,
              xValueMapper: (Watches series, _) => series.model,
              yValueMapper: (Watches series, _) => series.wearList.length,
        dataLabelMapper: (watch, _) => "${watch.model}: ${watch.wearList.length}",
        dataLabelSettings: const DataLabelSettings(isVisible: true)),
        ]
    );
  }
}
