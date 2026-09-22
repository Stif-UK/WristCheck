import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:collection/collection.dart';

class CaseDiameterChart extends StatefulWidget {
  const CaseDiameterChart({Key? key}) : super(key: key);

  @override
  State<CaseDiameterChart> createState() => _CaseDiameterChartState();
}

class _CaseDiameterChartState extends State<CaseDiameterChart> {
  final List<Watches> data = Boxes.getCollectionWatches();


  @override
  Widget build(BuildContext context) {

    //Calculate the chart data - generate a map of case diameters and counts
    Map<String,int> chartData = <String,int>{};

    //Start by removing nulls and sorting based on case diameter
    data.removeWhere((watch) => watch.caseDiameter == null);
    data.sort((a, b) => b.caseDiameter!.compareTo(a.caseDiameter!));

    for(var watch in data){
      if(watch.caseDiameter != null){
        chartData.update(
          watch.caseDiameter.toString(),
              (value) => ++value,
          ifAbsent: () => 1,
        );
      }
    }
    //TODO: Consider adding an optional count of zero values
    //remove zero values
    if(chartData.containsKey("0.0")){
      chartData.remove("0.0");
    }

    List<DiameterData> getChartData = [];

    for(var item in chartData.entries){
      getChartData.add(DiameterData(item.key, item.value));
    }

    return Column(
      children: [
        SfCartesianChart(
          series: <CartesianSeries>[
            BarSeries<DiameterData, String>(
              dataSource: getChartData,
              xValueMapper: (DiameterData mvmt, _) => mvmt.diameter,
              yValueMapper: (DiameterData mvmt, _) => mvmt.count,
              dataLabelMapper: (moov, _)=> "${WristCheckFormatter.getLocalizedDecimal(double.tryParse(moov.diameter))}mm: ${moov.count}",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
          primaryXAxis: CategoryAxis(isVisible: false),
        ),
        Text(_calculateAverageCaseDiameter(context, data)),
      ],
    );
  }
}

String _calculateAverageCaseDiameter(BuildContext context, List<Watches> data) {
  String returnString = "";
  if(data.isNotEmpty){
    data.removeWhere((watch) => watch.caseDiameter == null || watch.caseDiameter == 0.0);
    double average = data.map((m) => m.caseDiameter!).average;
    returnString = AppLocalizations.of(context)!.averageCaseDiameter(WristCheckFormatter.getLocalizedDecimal(average, 2));
  }

  return returnString;

}


class DiameterData{
  DiameterData(this.diameter, this.count);
  final String diameter;
  final int count;
}

