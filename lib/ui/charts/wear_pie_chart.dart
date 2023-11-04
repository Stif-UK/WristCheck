import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WearPieChart extends StatelessWidget {

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;


  const WearPieChart({required this.data, required this.animate});

  @override
  Widget build(BuildContext context) {
    int dataSize = data.length;

    return dataSize == 0? Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No data available for the chosen filter",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,),
      ),
    ): SfCircularChart(
        series: <PieSeries<Watches, String>>[
          PieSeries<Watches, String>(
              dataSource:  data,
              explode: true,
              explodeIndex: 0,
              xValueMapper: (Watches series, _) => (series.manufacturer+series.model),
              yValueMapper: (Watches series, _) => series.filteredWearList == null? series.wearList.length :series.filteredWearList!.length,
        dataLabelMapper: (watch, _) => watch.filteredWearList == null? "${watch.manufacturer} ${watch.model}: ${watch.wearList.length}":"${watch.manufacturer} ${watch.model}: ${watch.filteredWearList!.length}",
        dataLabelSettings: const DataLabelSettings(isVisible: true, showZeroValue: false)),
        ]
    );
  }
}
