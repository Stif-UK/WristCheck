import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class MovementChart extends StatefulWidget {
  const MovementChart({Key? key}) : super(key: key);

  @override
  State<MovementChart> createState() => _MovementChartState();
}

class _MovementChartState extends State<MovementChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of movements and counts
    Map<String,int> chartData = <String,int>{};
    for(var watch in data){
      if(watch.movement != null){
        chartData.update(
          watch.movement!,
              (value) => ++value,
          ifAbsent: () => 1,
        );
        }
      }
    List<MovementData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(MovementData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<MovementData, String>(
          dataSource: getChartData,
          xValueMapper: (MovementData mvmt, _) => mvmt.movement,
          yValueMapper: (MovementData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> moov.movement,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class MovementData{
  MovementData(this.movement, this.count);
  final String movement;
  final int count;
}

