import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class L2LChartV2 extends StatefulWidget {
  const L2LChartV2({Key? key}) : super(key: key);

  @override
  State<L2LChartV2> createState() => _L2LChartV2State();
}

class _L2LChartV2State extends State<L2LChartV2> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a list of all lug2lug values
    data.removeWhere((watch) => watch.lug2lug == null);
    data.removeWhere((watch) => watch.lug2lug == 0.0);


    return SfCartesianChart(
      series: <CartesianSeries>[
        LineSeries<Watches, String>(
          dataSource: data,
          xValueMapper: (Watches watch, _) => watch.toString(),
          yValueMapper: (Watches watch, _) => watch.lug2lug,
          dataLabelMapper: (watch, _)=> "${watch.lug2lug}mm",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          markerSettings: MarkerSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );

  }
}

class L2LData{
  L2LData(this.lug2lug, this.index);
  final String lug2lug;
  final int index;
}

