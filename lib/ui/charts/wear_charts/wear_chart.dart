import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

class WearChart extends StatefulWidget {
  // Create data for the chart - we need a list of watch objects and wear counts
  final List<WornWatchesClass> data;
  final bool animate;
  final ChartGrouping grouping;
  final DefaultChartType chartType;
  final WRUnitsEnum? wrUnitOverride;

  const WearChart({
    Key? key,
    required this.data,
    required this.animate,
    required this.grouping,
    this.chartType = DefaultChartType.bar,
    this.wrUnitOverride,
  }) : super(key: key);

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  WRUnitsEnum _resolveWrUnit() {
    if (widget.wrUnitOverride != null) {
      return widget.wrUnitOverride!;
    }
    if (Get.isRegistered<WristCheckController>()) {
      return Get.find<WristCheckController>().waterResistanceUnit.value;
    }
    return WRUnitsEnum.metres;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveType = widget.chartType.resolveForGrouping(widget.grouping);
    final points = _buildChartPoints(context, effectiveType);

    if (points.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.chartsEmptyBackgroundText,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final double animDuration = widget.animate ? 1500 : 0;

    switch (effectiveType) {
      case DefaultChartType.bar:
        return SfCartesianChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.bar),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(),
          series: <BarSeries<_WearChartPoint, String>>[
            BarSeries<_WearChartPoint, String>(
              dataSource: points,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.label}: ${point.count}',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              animationDuration: animDuration,
            ),
          ],
        );

      case DefaultChartType.column:
        return SfCartesianChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.column),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(
            isVisible: true,
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          primaryYAxis: NumericAxis(),
          series: <ColumnSeries<_WearChartPoint, String>>[
            ColumnSeries<_WearChartPoint, String>(
              dataSource: points,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.count}',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
              animationDuration: animDuration,
            ),
          ],
        );

      case DefaultChartType.pie:
        return SfCircularChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.pie),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries<_WearChartPoint, String>>[
            PieSeries<_WearChartPoint, String>(
              dataSource: points,
              explode: true,
              explodeIndex: 0,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.label}: ${point.count}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
              animationDuration: animDuration,
            ),
          ],
        );

      case DefaultChartType.donut:
        return SfCircularChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.donut),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <CircularSeries<_WearChartPoint, String>>[
            DoughnutSeries<_WearChartPoint, String>(
              dataSource: points,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.label}: ${point.count}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                labelPosition: ChartDataLabelPosition.outside,
              ),
              enableTooltip: true,
              animationDuration: animDuration,
            ),
          ],
        );

      case DefaultChartType.line:
        return SfCartesianChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.line),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(
            interval: 1,
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          primaryYAxis: NumericAxis(),
          series: <CartesianSeries<_WearChartPoint, String>>[
            LineSeries<_WearChartPoint, String>(
              dataSource: points,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.count}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
              ),
              markerSettings: const MarkerSettings(isVisible: true),
              enableTooltip: true,
              animationDuration: animDuration,
            ),
          ],
        );

      case DefaultChartType.splineArea:
        final Color primaryColor = Theme.of(context).colorScheme.primary;
        return SfCartesianChart(
          key: const ValueKey<DefaultChartType>(DefaultChartType.splineArea),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(
            interval: 1,
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          primaryYAxis: NumericAxis(),
          series: <CartesianSeries<_WearChartPoint, String>>[
            SplineAreaSeries<_WearChartPoint, String>(
              dataSource: points,
              xValueMapper: (point, _) => point.label,
              yValueMapper: (point, _) => point.count,
              dataLabelMapper: (point, _) => '${point.count}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
              ),
              splineType: SplineType.monotonic,
              color: primaryColor.withValues(alpha: 0.3),
              borderColor: primaryColor,
              borderWidth: 2,
              markerSettings: const MarkerSettings(isVisible: true),
              enableTooltip: true,
              animationDuration: animDuration,
            ),
          ],
        );
    }
  }

  List<_WearChartPoint> _buildChartPoints(
    BuildContext context,
    DefaultChartType effectiveType,
  ) {
    switch (widget.grouping) {
      case ChartGrouping.watch:
        return widget.data
            .where((worn) => worn.count > 0)
            .map((worn) {
              final suffix = WearChartsHelper.getLabelSuffix(
                worn.watch,
                context: context,
              );
              final label = suffix.isEmpty
                  ? worn.watch.toString()
                  : '${worn.watch.toString()} $suffix';
              return _WearChartPoint(label: label, count: worn.count);
            })
            .toList();

      case ChartGrouping.movement:
        return ChartHelper.calculateMovementList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.movement.toLocalizedString(context),
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.category:
        return ChartHelper.calculateCategoryList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.category.toLocalizedString(context),
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.manufacturer:
        return ChartHelper.calculateManufacturerList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.manufacturer,
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.colour:
        return ChartHelper.calculateColourList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.colour,
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.caseDiameter:
        return _dimensionPoints(
          ChartHelper.calculateCaseDiameterList(widget.data),
          'mm',
        );

      case ChartGrouping.lugWidth:
        return _dimensionPoints(
          ChartHelper.calculateLugWidthList(widget.data),
          'mm',
        );

      case ChartGrouping.lug2lug:
        return _dimensionPoints(
          ChartHelper.calculateLugToLugList(widget.data),
          'mm',
        );

      case ChartGrouping.caseThickness:
        return _dimensionPoints(
          ChartHelper.calculateCaseThicknessList(widget.data),
          'mm',
        );

      case ChartGrouping.waterResistance:
        return _dimensionPoints(
          ChartHelper.calculateWaterResistanceList(widget.data),
          ' ${_resolveWrUnit().name}',
        );

      case ChartGrouping.caseMaterial:
        return ChartHelper.calculateCaseMaterialList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.material.toLocalizedString(context),
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.dateComplication:
        return ChartHelper.calculateDateComplicationList(widget.data)
            .where((item) => item.count > 0)
            .map(
              (item) => _WearChartPoint(
                label: item.dateComplication.toLocalizedString(context),
                count: item.count,
              ),
            )
            .toList();

      case ChartGrouping.year:
        return _yearOrDecadePoints(
          ChartHelper.calculateYearList(widget.data),
          effectiveType,
        );

      case ChartGrouping.decade:
        return _yearOrDecadePoints(
          ChartHelper.calculateDecadeList(widget.data),
          effectiveType,
        );
    }
  }

  List<_WearChartPoint> _dimensionPoints(
    List<DimensionsClass> items,
    String unitSuffix,
  ) {
    return items
        .where((item) => item.count > 0)
        .map(
          (item) => _WearChartPoint(
            label: '${item.dimension}$unitSuffix',
            count: item.count,
          ),
        )
        .toList();
  }

  List<_WearChartPoint> _yearOrDecadePoints(
    List<YearGroupClass> items,
    DefaultChartType effectiveType,
  ) {
    final filtered = items.where((item) => item.count > 0).toList();
    final order = WristCheckPreferences.getWearChartOrder() ?? ChartOrdering.watchbox;
    final bool sortChronologically = effectiveType == DefaultChartType.line ||
        effectiveType == DefaultChartType.splineArea ||
        (effectiveType == DefaultChartType.column &&
            order == ChartOrdering.watchbox);
    if (sortChronologically) {
      filtered.sort((a, b) {
        final int aVal = int.tryParse(a.yearLabel.replaceAll('s', '')) ?? 0;
        final int bVal = int.tryParse(b.yearLabel.replaceAll('s', '')) ?? 0;
        return aVal.compareTo(bVal);
      });
    }
    return filtered
        .map(
          (item) => _WearChartPoint(
            label: item.yearLabel,
            count: item.count,
          ),
        )
        .toList();
  }
}

class _WearChartPoint {
  final String label;
  final int count;

  const _WearChartPoint({
    required this.label,
    required this.count,
  });
}
