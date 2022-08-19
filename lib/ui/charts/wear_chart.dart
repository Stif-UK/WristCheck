import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class WearChart extends StatefulWidget {
  // const WearChart({Key? key}) : super(key: key);

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;



  WearChart({required this.data, required this.animate});

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  @override
  Widget build(BuildContext context) {


      // List<charts.Series<Watches, String>> series =[
      //   charts.Series(
      //       id: "Watches",
      //       data: data,
      //       domainFn: (Watches series, _) => series.model,
      //       measureFn: (Watches series, _) => series.wearList.length,
      //       // Set a label accessor to control the text of the bar label.
      //       labelAccessorFn: (Watches series, _) =>
      //       // '${series.model}: \$${sales.sales.toString()}',
      //       "${series.manufacturer} ${series.model}: ${series.wearList.length}"
      //   )
      // ];




    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(),
      series: <BarSeries<Watches, String>>[
        BarSeries(
            dataSource: widget.data,
          xValueMapper: (Watches series, _) => series.model,
          yValueMapper: (Watches series, _) => series.filteredWearList == null? series.wearList.length :series.filteredWearList!.length,
          dataLabelMapper: (watch, _) => watch.filteredWearList == null? "${watch.model}: ${watch.wearList.length}":"${watch.model}: ${watch.filteredWearList!.length}",
          dataLabelSettings: const DataLabelSettings(isVisible: true)
      )

      ],
    );

    //   charts.BarChart(series,
    // vertical: false,
    //   // Set a bar label decorator.
    //   // Example configuring different styles for inside/outside:
    //         barRendererDecorator: charts.BarLabelDecorator(
    //           outsideLabelStyleSpec: Get.isDarkMode? const charts.TextStyleSpec(fontSize: 12, color: charts.Color.white):const charts.TextStyleSpec(fontSize: 12, color: charts.Color.black)) ,
    //            // insideLabelStyleSpec: Get.isDarkMode? const charts.TextStyleSpec(fontSize: 12, color: charts.Color.white):const charts.TextStyleSpec(fontSize: 12, color: charts.Color.black)) ,
    //   //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
    //   // barRendererDecorator: charts.BarLabelDecorator<String>(),
    //   // Hide domain axis.
    //   domainAxis:
    //   const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    // );



  }
}

