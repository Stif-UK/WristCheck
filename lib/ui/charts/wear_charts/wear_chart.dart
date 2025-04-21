import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';


class WearChart extends StatefulWidget {

  //Create data for the chart - we need a list of watch objects and wear counts
  final List<Watches> data;
  final bool animate;
  final ChartGrouping grouping;
  final wristCheckController = Get.put(WristCheckController());



  WearChart({required this.data, required this.animate, required this.grouping});

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  @override
  Widget build(BuildContext context) {
    int dataSize = widget.data.length;


    return dataSize == 0? Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text("No data available for the chosen filter",
          style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,),
      ),
    ): SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(),
      series: _getBarSeries(widget.grouping)
    );
  }
  
  List<BarSeries<dynamic, dynamic>> _getBarSeries(ChartGrouping grouping){
    
    List<BarSeries<dynamic, dynamic>> returnSeries = [];
    
    switch(grouping) {
      case ChartGrouping.watch:
        returnSeries =  <BarSeries<Watches, String>>[
          BarSeries(
            dataSource: widget.data,
            xValueMapper: (Watches series, _) => series.filteredWearList!.isEmpty? null: (series.manufacturer+series.model),
            yValueMapper: (Watches series, _) => series.filteredWearList == null? series.wearList.length :series.filteredWearList!.length,
            dataLabelMapper: (watch, _) => watch.filteredWearList == null? "${watch.manufacturer} ${watch.model}: ${watch.wearList.length}":"${watch.manufacturer} ${watch.model} ${WearChartsHelper.getLabelSuffix(watch)}: ${watch.filteredWearList!.length}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
            // animationDuration: 0 Set to zero to stop it animating!
          )
        ];
        break;
      case ChartGrouping.movement:
        List<MovementClass> movementList = ChartHelper.calculateMovementList(widget.data);
        returnSeries =  <BarSeries<MovementClass, String>>[
          BarSeries(
            dataSource: movementList,
            xValueMapper: (MovementClass series, _) =>  series.count == 0? null: (series.movement.name),
            yValueMapper: (MovementClass series, _) => series.count == 0? null: series.count,
            dataLabelMapper: (mvmt, _) => "${WristCheckFormatter.getMovementText(mvmt.movement)}: ${mvmt.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
            // animationDuration: 0 Set to zero to stop it animating!
          )
        ];
        break;
      case ChartGrouping.category:
        List<CategoryClass> categoryList = ChartHelper.calculateCategoryList(widget.data);
        returnSeries =  <BarSeries<CategoryClass, String>>[
          BarSeries(
            dataSource: categoryList,
            xValueMapper: (CategoryClass series, _) =>  series.count == 0? null: (series.category.name),
            yValueMapper: (CategoryClass series, _) => series.count == 0? null: series.count,
            dataLabelMapper: (category, _) => "${WristCheckFormatter.getCategoryText(category.category)}: ${category.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself

            // animationDuration: 0 Set to zero to stop it animating!
          )

        ];
        break;
      case ChartGrouping.manufacturer:
        returnSeries =  <BarSeries<ManufacturerClass, String>>[
          BarSeries(
            dataSource: ChartHelper.calculateManufacturerList(widget.data),
            xValueMapper: (ManufacturerClass series, _) => series.count == 0? null: series.manufacturer,
            yValueMapper: (ManufacturerClass series, _) => series.count == 0? null : series.count,
            dataLabelMapper: (manu, _) => manu.count == 0? "":"${manu.manufacturer}: ${manu.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
            // animationDuration: 0 Set to zero to stop it animating!
          )
        ];
        break;
      case ChartGrouping.caseDiameter:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateCaseDiameterList(widget.data), "mm");
        break;
      case ChartGrouping.lugWidth:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateLugWidthList(widget.data), "mm");
        break;
      case ChartGrouping.lug2lug:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateLugToLugList(widget.data), "mm");
        break;
      case ChartGrouping.caseThickness:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateCaseThicknessList(widget.data), "mm");
        break;
      case ChartGrouping.waterResistance:
        returnSeries = _calculateDimensionReturn(ChartHelper.calculateWaterResistanceList(widget.data), widget.wristCheckController.waterResistanceUnit.value.name);
        break;
      case ChartGrouping.caseMaterial:
        returnSeries =  <BarSeries<MaterialClass, String>>[
          BarSeries(
            dataSource: ChartHelper.calculateCaseMaterialList(widget.data),
            xValueMapper: (MaterialClass series, _) => series.count == 0? null: WristCheckFormatter.getCaseMaterialText(series.material),
            yValueMapper: (MaterialClass series, _) => series.count == 0? null : series.count,
            dataLabelMapper: (watch, _) => watch.count == 0? "":"${WristCheckFormatter.getCaseMaterialText(watch.material)}: ${watch.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
            // animationDuration: 0 Set to zero to stop it animating!
          )
        ];
        break;
      case ChartGrouping.dateComplication:
        returnSeries =  <BarSeries<DateComplicationClass, String>>[
          BarSeries(
            dataSource: ChartHelper.calculateDateComplicationList(widget.data),
            xValueMapper: (DateComplicationClass series, _) => series.count == 0? null: WristCheckFormatter.getDateComplicationName(series.dateComplication),
            yValueMapper: (DateComplicationClass series, _) => series.count == 0? null : series.count,
            dataLabelMapper: (watch, _) => watch.count == 0? "":"${WristCheckFormatter.getDateComplicationName(watch.dateComplication)}: ${watch.count}",
            dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
            // animationDuration: 0 Set to zero to stop it animating!
          )
        ];
        break;
    }
    return returnSeries;
  }
}

List<BarSeries> _calculateDimensionReturn(List<DimensionsClass> dataSource, String units) {
  return  <BarSeries<DimensionsClass, String>>[
    BarSeries(
      dataSource: dataSource,
      xValueMapper: (DimensionsClass series, _) => series.count == 0? null: series.dimension,
      yValueMapper: (DimensionsClass series, _) => series.count == 0? null : series.count,
      dataLabelMapper: (caseDiameter, _) => caseDiameter.count == 0? "":"${caseDiameter.dimension}$units: ${caseDiameter.count}",
      dataLabelSettings: const DataLabelSettings(isVisible: true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
      // animationDuration: 0 Set to zero to stop it animating!
    )
  ];
}

