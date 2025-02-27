import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class L2LChart extends StatefulWidget {
  L2LChart({Key? key}) : super(key: key);
  final collectionStatsController = Get.put(CollectionStatsController());

  @override
  State<L2LChart> createState() => _L2LChartState();
}

class _L2LChartState extends State<L2LChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a list of all lug2lug values
    data.removeWhere((watch) => watch.lug2lug == null);
    data.removeWhere((watch) => watch.lug2lug == 0.0);


    return Obx(()=> Column(
        children: [
          _getChart(widget.collectionStatsController.lug2lugChartType.value, data),
          Text(_calculateAverageLug2Lug(data)),
        ],
      ),
    );

  }
}

Widget _getChart(Lug2lugChartEnum type, List<Watches> data){
  switch(type) {
    case Lug2lugChartEnum.line:
      return SfCartesianChart(
        series: <CartesianSeries>[
          LineSeries<Watches, String>(
            dataSource: data,
            xValueMapper: (Watches watch, _) => watch.toString(),
            yValueMapper: (Watches watch, _) => watch.lug2lug,
            dataLabelMapper: (watch, _)=> "${watch.lug2lug}mm",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            markerSettings: MarkerSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
      );
    case Lug2lugChartEnum.bar:
      return SfCartesianChart(
        series: <CartesianSeries>[
          BarSeries<L2LData, String>(
            dataSource: _getChartData(data),
            xValueMapper: (L2LData mvmt, _) => mvmt.lug2lug,
            yValueMapper: (L2LData mvmt, _) => mvmt.count,
            dataLabelMapper: (moov, _)=> "${WristCheckFormatter.trimDecimalZero(moov.lug2lug)}mm",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
      );
  }

}

String _calculateAverageLug2Lug(List<Watches> data) {
  String returnString = "";

  if(data.length != 0){
    double average = data.map((m) => m.lug2lug!).average;
    returnString = "Average Lug to Lug: ${double.parse(average.toStringAsFixed(2))} mm";
  }

  return returnString;

}

List<L2LData> _getChartData(List<Watches> data) {
  //start by sorting the watches based on their lug to lug (we have already removed nulls)
  data.sort((a,b) => b.lug2lug!.compareTo(a.lug2lug!));

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
  //remove zero values
  if(chartData.containsKey("0.0")){
    chartData.remove("0.0");
  }

  List<L2LData> getChartData = [];

  for(var item in chartData.entries){
    getChartData.add(L2LData(item.key, item.value));
  }
  return getChartData;

}

class L2LData{
  L2LData(this.lug2lug, this.count);
  final String lug2lug;
  final int count;
}

