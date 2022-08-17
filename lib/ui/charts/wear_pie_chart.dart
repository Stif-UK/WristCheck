import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wristcheck/model/watches.dart';

class WearPieChart extends StatelessWidget {
  // const WearChart({Key? key}) : super(key: key);

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;


  const WearPieChart({required this.data, required this.animate});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Watches, String>> series =[
      charts.Series(
          id: "Watches",
          data: data,
          domainFn: (Watches series, _) => series.model,
          measureFn: (Watches series, _) => series.wearList.length,
          // colorFn: code to re-colour bars - function to give random colours!
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (Watches series, _) =>
          // '${series.model}: \$${sales.sales.toString()}',
          "${series.manufacturer} ${series.model}: ${series.wearList.length}"
      )
    ];

    return charts.PieChart<String>(series,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 80,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(),
          ]
        ),

    );



  }
}
