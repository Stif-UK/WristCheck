import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DateComplicationChart extends StatefulWidget {
  const DateComplicationChart({Key? key}) : super(key: key);

  @override
  State<DateComplicationChart> createState() => _DateComplicationChartState();
}

class _DateComplicationChartState extends State<DateComplicationChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of date complications and counts
    Map<String,int> chartData = <String,int>{};
    for(var watch in data){
      if(watch.dateComplication != null){
        chartData.update(
          watch.dateComplication!,
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    //remove 'not selected' and empty string if it exists
    if (chartData.containsKey("Not Entered")) {
      chartData.remove("Not Entered");
    }
    if (chartData.containsKey("")) {
      chartData.remove("");
    }

    //sort map
    var sortedChartData = Map.fromEntries(
        chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<DateComplicationData> getChartData = [];

    for(var item in sortedChartData.entries){
      getChartData.add(DateComplicationData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <CartesianSeries>[
        BarSeries<DateComplicationData, String>(
          dataSource: getChartData,
          xValueMapper: (DateComplicationData dcd, _) => dcd.dateComplication,
          yValueMapper: (DateComplicationData dcd, _) => dcd.count,
          dataLabelMapper: (dcd, _)=> "${dcd.dateComplication}: ${dcd.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class DateComplicationData{
  DateComplicationData(this.dateComplication, this.count);
  final String dateComplication;
  final int count;
}

