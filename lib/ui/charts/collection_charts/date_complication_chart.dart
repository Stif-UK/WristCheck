import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

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
    Map<DateComplicationEnum,int> chartData = <DateComplicationEnum,int>{};
    for(var watch in data){
      if(watch.dateComplication != null){
        DateComplicationEnum complication = WristCheckFormatter.getDateComplicationEnum(watch.dateComplication);
        chartData.update(
          complication,
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    
    //remove blank entries
    if (chartData.containsKey(DateComplicationEnum.blank)){
      chartData.remove(DateComplicationEnum.blank);
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
          xValueMapper: (DateComplicationData dcd, _) => dcd.dateComplication.toLocalizedString(context),
          yValueMapper: (DateComplicationData dcd, _) => dcd.count,
          dataLabelMapper: (dcd, _)=> "${dcd.dateComplication.toLocalizedString(context)}: ${dcd.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class DateComplicationData{
  DateComplicationData(this.dateComplication, this.count);
  final DateComplicationEnum dateComplication;
  final int count;
}

