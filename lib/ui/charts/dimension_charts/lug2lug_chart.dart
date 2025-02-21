import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class L2LChart extends StatefulWidget {
  const L2LChart({Key? key}) : super(key: key);

  @override
  State<L2LChart> createState() => _L2LChartState();
}

class _L2LChartState extends State<L2LChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of case diameters and counts
    Map<String,int> chartData = <String,int>{};
    for(var watch in data){
      if(watch.lug2lug != null){
        chartData.update(
          watch.lug2lug.toString(),
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    //TODO: Consider adding an optional count of zero values
    //remove zero values
    if(chartData.containsKey("0.0")){
      chartData.remove("0.0");
    }

    //sort map
    var sortedChartData = Map.fromEntries(
        chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<L2LData> getChartData = [];

    for(var item in sortedChartData.entries){
      getChartData.add(L2LData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <CartesianSeries>[
        BarSeries<L2LData, String>(
          dataSource: getChartData,
          xValueMapper: (L2LData mvmt, _) => mvmt.lug2lug,
          yValueMapper: (L2LData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> "${WristCheckFormatter.trimDecimalZero(moov.lug2lug)}mm: ${moov.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class L2LData{
  L2LData(this.lug2lug, this.count);
  final String lug2lug;
  final int count;
}

