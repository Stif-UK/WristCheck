import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CaseThicknessChart extends StatefulWidget {
  CaseThicknessChart({Key? key}) : super(key: key);
  final collectionStatsController = Get.put(CollectionStatsController());

  @override
  State<CaseThicknessChart> createState() => _CaseThicknessChartState();
}

class _CaseThicknessChartState extends State<CaseThicknessChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a list of all lug2lug values
    data.removeWhere((watch) => watch.caseThickness == null);
    data.removeWhere((watch) => watch.caseThickness == 0.0);

    //Create the chart and footer text
    return Obx(()=> Column(
        children: [
          _getChart(widget.collectionStatsController.caseThicknessChartType.value, data),
          Text(_calculateAverageCaseThickness(data))
        ],
      ),
    );

  }
}

Widget _getChart(CaseThicknessChartEnum type, List<Watches> data){
  switch(type) {
    case CaseThicknessChartEnum.line:
      return SfCartesianChart(
              series: <CartesianSeries>[
              LineSeries<Watches, String>(
              dataSource: data,
              xValueMapper: (Watches watch, _) => watch.toString(),
              yValueMapper: (Watches watch, _) => watch.caseThickness,
              dataLabelMapper: (watch, _)=> "${watch.caseThickness}mm",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
              )
              ],
              primaryXAxis: CategoryAxis(isVisible: false),
              );
    case CaseThicknessChartEnum.bar:
      return SfCartesianChart(
        series: <CartesianSeries>[
          BarSeries<CaseThicknessData, String>(
            dataSource: _getChartData(data),
            xValueMapper: (CaseThicknessData mvmt, _) => mvmt.caseThickness,
            yValueMapper: (CaseThicknessData mvmt, _) => mvmt.count,
            dataLabelMapper: (moov, _)=> "${WristCheckFormatter.trimDecimalZero(moov.caseThickness)}mm",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
      );
  }

}

List<CaseThicknessData> _getChartData(List<Watches> data) {
  Map<String,int> chartData = <String,int>{};
  for(var watch in data){
    if(watch.caseThickness != null){
      chartData.update(
        watch.caseThickness.toString(),
            (value) => ++value,
        ifAbsent: () => 1,
      );
    }
  }
  //remove zero values
  if(chartData.containsKey("0.0")){
    chartData.remove("0.0");
  }

  //sort map
  var sortedChartData = Map.fromEntries(
      chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


  List<CaseThicknessData> getChartData = [];

  for(var item in sortedChartData.entries){
    getChartData.add(CaseThicknessData(item.key, item.value));
  }
  return getChartData;

}

String _calculateAverageCaseThickness(List<Watches> data) {
  String returnString = "";

  if(data.length != 0){
    double average = data.map((m) => m.caseThickness!).average;
    returnString = "Average Case Thickness: $average mm";
  }

  return returnString;
}

class CaseThicknessData{
  CaseThicknessData(this.caseThickness, this.count);
  final String caseThickness;
  final int count;
}

