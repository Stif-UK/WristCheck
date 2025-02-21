import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaseThicknessChart extends StatefulWidget {
  const CaseThicknessChart({Key? key}) : super(key: key);

  @override
  State<CaseThicknessChart> createState() => _CaseThicknessChartState();
}

class _CaseThicknessChartState extends State<CaseThicknessChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a list of all lug2lug values
    data.removeWhere((watch) => watch.caseThickness == null);
    data.removeWhere((watch) => watch.caseThickness == 0.0);


    return SfCartesianChart(
      series: <CartesianSeries>[
        LineSeries<Watches, String>(
          dataSource: data,
          xValueMapper: (Watches watch, _) => watch.toString(),
          yValueMapper: (Watches watch, _) => watch.caseThickness,
          dataLabelMapper: (watch, _)=> "${watch.caseThickness}mm",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          markerSettings: MarkerSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );

  }
}

class L2LData{
  L2LData(this.caseThickness, this.index);
  final String caseThickness;
  final int index;
}

