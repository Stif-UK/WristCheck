import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';

class WaterResistanceChart extends StatefulWidget {
  WaterResistanceChart({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<WaterResistanceChart> createState() => _WaterResistanceChartState();
}

class _WaterResistanceChartState extends State<WaterResistanceChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of case diameters and counts
    Map<String,int> chartData = <String,int>{};

    //Remove nulls and sort the input data based on water resistance
    data.removeWhere((watch) => watch.waterResistance == null);
    data.sort((a,b) => b.waterResistance!.compareTo(a.waterResistance!));

    for(var watch in data){
      if(watch.waterResistance != null){
        chartData.update(
          watch.waterResistance.toString(),
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    //TODO: Consider adding an optional count of zero values
    //remove zero values and empty strings
    if(chartData.containsKey("0")){
      chartData.remove("0");
    }
    if(chartData.containsKey("")){
      chartData.remove("");
    }


    List<WaterResistanceData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(WaterResistanceData(item.key, item.value));
    }

    return Column(
      children: [
        SfCartesianChart(
          series: <CartesianSeries>[
            BarSeries<WaterResistanceData, String>(
              dataSource: getChartData,
              xValueMapper: (WaterResistanceData mvmt, _) => mvmt.waterResistance,
              yValueMapper: (WaterResistanceData mvmt, _) => mvmt.count,
              dataLabelMapper: (moov, _)=> "${moov.waterResistance} ${widget.wristCheckController.waterResistanceUnit.value.name}: ${moov.count}",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
          primaryXAxis: CategoryAxis(isVisible: false),
        ),
        Text(_calculateAverageWaterResistance(data)),
      ],
    );
  }
}

//TODO: Replace with average info for WR
String _calculateAverageWaterResistance(List<Watches> data) {
  final wristcheckController = Get.put(WristCheckController());
  String returnString = "";

  if(data.length != 0){
    double average = data.map((watch) => watch.waterResistance!).average;
    returnString = "Average Water Resistance: ${double.parse(average.toStringAsFixed(2)).round()} ${wristcheckController.waterResistanceUnit.value.name}";
  }

  return returnString;

}
// String _getMedianLugWidth(List<Watches> data) {
//   String returnString = "";
//
//   if(data.length != 0){
//
//     int median;
//     //remove nulls and zeros
//     data.removeWhere((watch) => watch.lugWidth == null || watch.lugWidth == 0);
//     List<int> lugWidthList = data.map((obj) => obj.lugWidth!).toList();
//
//     int middle = lugWidthList.length ~/ 2;
//     if (lugWidthList.length % 2 == 1) {
//       median = lugWidthList[middle];
//     } else {
//       median = ((lugWidthList[middle - 1] + lugWidthList[middle]) / 2.0).round();
//     }
//     returnString = "Median Lug Width: $median mm";
//   }
//   return returnString;
// }

class WaterResistanceData{
  WaterResistanceData(this.waterResistance, this.count);
  final String waterResistance;
  final int count;
}

