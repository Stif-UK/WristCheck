import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
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
  final wristCheckController = Get.put(WristCheckController());



  WearPieChart({required this.data, required this.animate, required this.grouping});

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
      case ChartGrouping.manufacturer:
        returnSeries = <PieSeries<ManufacturerClass, String>>[PieSeries<ManufacturerClass, String>(
            dataSource: ChartHelper.calculateManufacturerList(data),
            explode: true,
            explodeIndex: 0,
            xValueMapper: (ManufacturerClass series, _) =>
            series.manufacturer,
            yValueMapper: (ManufacturerClass series, _) =>
            series.count == 0
                ? null
                : series.count,
            dataLabelMapper: (man, _) =>
            man.count == 0 ? "" : "${man.manufacturer}: ${man.count}",
            dataLabelSettings: const DataLabelSettings(
                isVisible: true, showZeroValue: false))];
        break;
      case ChartGrouping.caseDiameter:
        returnSeries = <PieSeries<DimensionsClass, String>>[PieSeries<DimensionsClass, String>(
            dataSource: ChartHelper.calculateCaseDiameterList(data),
            explode: true,
            explodeIndex: 0,
            xValueMapper: (DimensionsClass series, _) =>
            series.dimension,
            yValueMapper: (DimensionsClass series, _) =>
            series.count == 0
                ? null
                : series.count,
            dataLabelMapper: (man, _) =>
            man.count == 0 ? "" : "${man.dimension}mm: ${man.count}",
            dataLabelSettings: const DataLabelSettings(
                isVisible: true, showZeroValue: false))];
        break;
      case ChartGrouping.lugWidth:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateLugWidthList(data), "mm");
        break;
      case ChartGrouping.lug2lug:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateLugToLugList(data), "mm");
        break;
      case ChartGrouping.caseThickness:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateCaseThicknessList(data), "mm");
        break;
      case ChartGrouping.waterResistance:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateCaseDiameterList(data), wristCheckController.waterResistanceUnit.value.name);
        break;
      case ChartGrouping.caseMaterial:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateCaseDiameterList(data), "mm");
        break;
    }

    return returnSeries;

  }

  List<PieSeries> _calculateDimensionReturn(List<DimensionsClass> dataSource, String units){
     return <PieSeries<DimensionsClass, String>>[PieSeries<DimensionsClass, String>(
        dataSource: dataSource,
        explode: true,
        explodeIndex: 0,
        xValueMapper: (DimensionsClass series, _) =>
        series.dimension,
        yValueMapper: (DimensionsClass series, _) =>
        series.count == 0
            ? null
            : series.count,
        dataLabelMapper: (man, _) =>
        man.count == 0 ? "" : "${man.dimension} $units: ${man.count}",
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, showZeroValue: false))];
  }

}
