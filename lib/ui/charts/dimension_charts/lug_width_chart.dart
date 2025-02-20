import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class LugWidthChart extends StatefulWidget {
  const LugWidthChart({Key? key}) : super(key: key);

  @override
  State<LugWidthChart> createState() => _LugWidthChartState();
}

class _LugWidthChartState extends State<LugWidthChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of case diameters and counts
    Map<String,int> chartData = <String,int>{};
    for(var watch in data){
      if(watch.lugWidth != null){
        chartData.update(
          watch.lugWidth.toString(),
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    //TODO: Consider adding an optional count of zero values
    //remove zero values
    if(chartData.containsKey("0")){
      chartData.remove("0");
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
          xValueMapper: (L2LData mvmt, _) => mvmt.lugwidth,
          yValueMapper: (L2LData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> "${moov.lugwidth}mm: ${moov.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class L2LData{
  L2LData(this.lugwidth, this.count);
  final String lugwidth;
  final int count;
}

