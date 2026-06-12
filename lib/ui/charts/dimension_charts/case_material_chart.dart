import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class CaseMaterialChart extends StatefulWidget {
  const CaseMaterialChart({Key? key}) : super(key: key);

  @override
  State<CaseMaterialChart> createState() => _CaseMaterialChartState();
}

class _CaseMaterialChartState extends State<CaseMaterialChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of case materials and counts
    Map<CaseMaterialEnum,int> chartData = <CaseMaterialEnum,int>{};
    for(var watch in data){
      if(watch.caseMaterial != null){
        CaseMaterialEnum material = WristCheckFormatter.getCaseMaterialEnum(watch.caseMaterial);
        chartData.update(
          material,
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    
    //remove blank entries
    if (chartData.containsKey(CaseMaterialEnum.blank)){
      chartData.remove(CaseMaterialEnum.blank);
    }

    //sort map
    var sortedChartData = Map.fromEntries(
        chartData.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));


    List<CaseMaterialData> getChartData = [];

    for(var item in sortedChartData.entries){
      getChartData.add(CaseMaterialData(item.key, item.value));
    }

    return SfCartesianChart(
      series: <CartesianSeries>[
        BarSeries<CaseMaterialData, String>(
          dataSource: getChartData,
          xValueMapper: (CaseMaterialData mvmt, _) => mvmt.caseMaterial.toLocalizedString(context),
          yValueMapper: (CaseMaterialData mvmt, _) => mvmt.count,
          dataLabelMapper: (moov, _)=> "${moov.caseMaterial.toLocalizedString(context)}: ${moov.count}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
      primaryXAxis: CategoryAxis(isVisible: false),
    );
  }
}

class CaseMaterialData{
  CaseMaterialData(this.caseMaterial, this.count);
  final CaseMaterialEnum caseMaterial;
  final int count;
}

