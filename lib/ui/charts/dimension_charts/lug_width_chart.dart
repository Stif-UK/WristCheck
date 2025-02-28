import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:collection/collection.dart';

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

    //Remove nulls and sort the input data based on lug width
    data.removeWhere((watch) => watch.lugWidth == null);
    data.sort((a,b) => b.lugWidth!.compareTo(a.lugWidth!));

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


    List<LugWidthData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(LugWidthData(item.key, item.value));
    }

    return Column(
      children: [
        SfCartesianChart(
          series: <CartesianSeries>[
            BarSeries<LugWidthData, String>(
              dataSource: getChartData,
              xValueMapper: (LugWidthData mvmt, _) => mvmt.lugwidth,
              yValueMapper: (LugWidthData mvmt, _) => mvmt.count,
              dataLabelMapper: (moov, _)=> "${moov.lugwidth}mm: ${moov.count}",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
          primaryXAxis: CategoryAxis(isVisible: false),
        ),
        Text(_getMedianLugWidth(data)),
      ],
    );
  }
}

String _getMedianLugWidth(List<Watches> data) {
  String returnString = "";

  if(data.length != 0){

    int median;
    //remove nulls and zeros
    data.removeWhere((watch) => watch.lugWidth == null || watch.lugWidth == 0);
    List<int> lugWidthList = data.map((obj) => obj.lugWidth!).toList();

    int middle = lugWidthList.length ~/ 2;
    if (lugWidthList.length % 2 == 1) {
      median = lugWidthList[middle];
    } else {
      median = ((lugWidthList[middle - 1] + lugWidthList[middle]) / 2.0).round();
    }
     returnString = "Median Lug Width: $median mm";
  }
  return returnString;
}

class LugWidthData{
  LugWidthData(this.lugwidth, this.count);
  final String lugwidth;
  final int count;
}

