import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wristcheck/model/watches.dart';

class WearChart extends StatelessWidget {
  // const WearChart({Key? key}) : super(key: key);

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;


  const WearChart({required this.data, required this.animate});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Watches, String>> series =[
      charts.Series(
        id: "Watches",
        data: data,
        domainFn: (Watches series, _) => series.model,
        measureFn: (Watches series, _) => series.wearList.length
        // colorFn: code to re-colour bars - function to give random colours!
      )
    ];

    return charts.BarChart(series);


    // List<charts.Series<DeveloperSeries, String>> series = [
    //   charts.Series(
    //       id: "developers",
    //       data: data,
    //       domainFn: (DeveloperSeries series, _) => series.year,
    //       measureFn: (DeveloperSeries series, _) => series.developers,
    //       colorFn: (DeveloperSeries series, _) => series.barColor
    //   )
    // ];
    //
    // Return charts.Barchart(series, animate: true);
  }
}
