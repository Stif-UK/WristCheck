import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:wristcheck/model/enums/movement_enum.dart';
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
    Map<MovementEnum,int> chartData = <MovementEnum,int>{};
    for(var watch in data){
      if(watch.movement != null){
        MovementEnum movement = WristCheckFormatter.getMovementEnum(watch.movement);
        chartData.update(
          movement,
              (value) => ++value,
          ifAbsent: () => 1,
        );
        }
      }
    
    //remove blank entries
    if (chartData.containsKey(MovementEnum.blank)){
      chartData.remove(MovementEnum.blank);
    }

    //sort map
    var sortedChartData = Map.fromEntries(
        chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<MovementData> getChartData = [];

    for(var item in sortedChartData.entries){
      getChartData.add(MovementData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <CartesianSeries>[
        BarSeries<MovementData, String>(
          dataSource: getChartData,
          xValueMapper: (MovementData mvmt, _) => mvmt.movement.toLocalizedString(context),
          yValueMapper: (MovementData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> "${moov.movement.toLocalizedString(context)}: ${moov.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class MovementData{
  MovementData(this.movement, this.count);
  final MovementEnum movement;
  final int count;
}

