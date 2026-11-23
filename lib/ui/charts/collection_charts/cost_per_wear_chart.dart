import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:get/get.dart';

class CostPerWearChart extends StatefulWidget {
  CostPerWearChart({
    Key? key,
    required this.showData,
    this.watchesOverride,
    this.localeOverride,
  }) : super(key: key);
  final collectionController = Get.put(CollectionStatsController());
  final showData;
  final List<Watches>? watchesOverride;
  final LocationEnum? localeOverride;

  @override
  State<CostPerWearChart> createState() => _CostPerWearChartState();
}

class _CostPerWearChartState extends State<CostPerWearChart> {
  @override
  Widget build(BuildContext context) {
    final List<Watches> data =
        widget.watchesOverride ?? Boxes.getCollectionWatches();
    final LocationEnum effectiveLocale = widget.localeOverride ??
        Get.put(WristCheckController()).locale.value;
    String locale = WristCheckFormatter.getLocaleString(effectiveLocale);
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

