import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class WearChart extends StatefulWidget {

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
    int dataSize = widget.data.length;

    return dataSize == 0? Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No data available for the chosen filter",
          style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,),
      ),
    ): SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(),
      series: <BarSeries<Watches, String>>[
        BarSeries(
            dataSource: widget.data,
          xValueMapper: (Watches series, _) => series.filteredWearList!.isEmpty? null: (series.manufacturer+series.model), //adding this conditional removes lines that are zero!
          yValueMapper: (Watches series, _) => series.filteredWearList == null? series.wearList.length :series.filteredWearList!.length,
          dataLabelMapper: (watch, _) => watch.filteredWearList == null? "${watch.manufacturer} ${watch.model}: ${watch.wearList.length}":"${watch.manufacturer} ${watch.model}: ${watch.filteredWearList!.length}",
          dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself

          // animationDuration: 0 Set to zero to stop it animating!
      )

      ],
    );
  }
}

