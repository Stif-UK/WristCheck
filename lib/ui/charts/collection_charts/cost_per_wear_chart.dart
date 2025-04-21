import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:get/get.dart';

class CostPerWearChart extends StatefulWidget {
  CostPerWearChart({Key? key, required this.showData}) : super(key: key);
  final collectionController = Get.put(CollectionStatsController());
  final showData;

  @override
  State<CostPerWearChart> createState() => _CostPerWearChartState();
}

class _CostPerWearChartState extends State<CostPerWearChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {
    final wristCheckController = Get.put(WristCheckController());
    String locale = WristCheckFormatter.getLocaleString(wristCheckController.locale.value);
    //Calculate the chart data - generate a map of movements and counts
    Map<dynamic,Map<String,double>> chartData = {};

    
    for(var watch in data){
      dynamic key = watch.key;
      String title = "${watch.manufacturer} ${watch.model}";
      double cPW = WatchMethods.calculateCostPerWear(watch);
      chartData[key] = {title : cPW};
      
    }
    

    //sort map
    // var sortedChartData = Map.fromEntries(
    //     chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<CostPerWearData> getChartData = [];

    for(var item in chartData.entries){
      Map<String, double> currentData = item.value;
      if(currentData.values.first != 0.0){
        //map will be one pair long
        getChartData.add(
            CostPerWearData(currentData.keys.first, currentData.values.first));
      }
    }

    getChartData.sort((e1, e2) => e1.costPerWear.compareTo(e2.costPerWear));

    return SfCartesianChart(
        series: <CartesianSeries>[
          BarSeries<CostPerWearData, String>(
            dataSource: getChartData,
            xValueMapper: (CostPerWearData mvmt, _) => mvmt.watch,
            yValueMapper: (CostPerWearData mvmt, _) => mvmt.costPerWear,
            dataLabelMapper: (moov, _)=> "${moov.watch}${_getLabelSuffix(moov, locale)}",
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        primaryXAxis: CategoryAxis(isVisible: false),
    );
  }

  String _getLabelSuffix(CostPerWearData data, String locale){
    return widget.showData ? ": ${NumberFormat.simpleCurrency(locale: locale, decimalDigits: null).format(data.costPerWear)}":
    "";
  }
}

class CostPerWearData{
  CostPerWearData(this.watch, this.costPerWear);
  final String watch;
  final double costPerWear;
}

