import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:get/get.dart';

class CostPerWearChart extends StatefulWidget {
  const CostPerWearChart({Key? key}) : super(key: key);

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
      //map will be one pair long
      getChartData.add(CostPerWearData(currentData.keys.first, currentData.values.first));
    }

    getChartData.sort((e1, e2) => e1.costPerWear.compareTo(e2.costPerWear));

    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<CostPerWearData, String>(
          dataSource: getChartData,
          xValueMapper: (CostPerWearData mvmt, _) => mvmt.watch,
          yValueMapper: (CostPerWearData mvmt, _) => mvmt.costPerWear,
          dataLabelMapper: (moov, _)=> "${moov.watch}: ${NumberFormat.simpleCurrency(locale: locale, decimalDigits: null).format(moov.costPerWear)}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class CostPerWearData{
  CostPerWearData(this.watch, this.costPerWear);
  final String watch;
  final double costPerWear;
}

