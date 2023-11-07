import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class WearPieChart extends StatelessWidget {

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;
  final ChartGrouping grouping;


  const WearPieChart({required this.data, required this.animate, required this.grouping});

  @override
  Widget build(BuildContext context) {
    int dataSize = data.length;

    return dataSize == 0? Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No data available for the chosen filter",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,),
      ),
    ): SfCircularChart(
        series: _getChartData(grouping)
    );
  }

  List<PieSeries<dynamic, dynamic>> _getChartData(ChartGrouping grouping) {

    List<PieSeries<dynamic, dynamic>> returnSeries = [];

    switch(grouping) {
      case ChartGrouping.watch:
        returnSeries = <PieSeries<Watches, String>>[PieSeries<Watches, String>(
            dataSource: data,
            explode: true,
            explodeIndex: 0,
            xValueMapper: (Watches series, _) =>
            (series.manufacturer + series.model),
            yValueMapper: (Watches series, _) =>
            series.filteredWearList == null
                ? series.wearList.length
                : series.filteredWearList!.length,
            dataLabelMapper: (watch, _) =>
            watch.filteredWearList == null ? "${watch.manufacturer} ${watch
                .model}: ${watch.wearList.length}" : "${watch.manufacturer} ${watch
                .model}: ${watch.filteredWearList!.length}",
            dataLabelSettings: const DataLabelSettings(
                isVisible: true, showZeroValue: false))];
        break;
      case ChartGrouping.movement:
        returnSeries = <PieSeries<MovementClass, String>>[PieSeries<MovementClass, String>(
            dataSource: ChartHelper.calculateMovementList(data),
            explode: true,
            explodeIndex: 0,
            xValueMapper: (MovementClass series, _) =>
            (WristCheckFormatter.getMovementText(series.movement)),
            yValueMapper: (MovementClass series, _) =>
            series.count == 0
                ? null
                : series.count,
            dataLabelMapper: (mvmt, _) =>
            mvmt.count == 0 ? "" : "${WristCheckFormatter.getMovementText(mvmt.movement)}: ${mvmt.count}",
            dataLabelSettings: const DataLabelSettings(
                isVisible: true, showZeroValue: false))];

        break;
      case ChartGrouping.category:
        returnSeries = <PieSeries<CategoryClass, String>>[PieSeries<CategoryClass, String>(
            dataSource: ChartHelper.calculateCategoryList(data),
            explode: true,
            explodeIndex: 0,
            xValueMapper: (CategoryClass series, _) =>
            (WristCheckFormatter.getCategoryText(series.category)),
            yValueMapper: (CategoryClass series, _) =>
            series.count == 0
                ? null
                : series.count,
            dataLabelMapper: (cat, _) =>
            cat.count == 0 ? "" : "${WristCheckFormatter.getCategoryText(cat.category)}: ${cat.count}",
            dataLabelSettings: const DataLabelSettings(
                isVisible: true, showZeroValue: false))];
        break;
    }

    return returnSeries;

  }

}
