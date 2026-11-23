import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

enum RecapCategoryChartType { bar, pie, donut, radialBar }

enum RecapMonthlyChartType { bar, line, splineArea }

RecapCategoryChartType nextCategoryChartType(
  RecapCategoryChartType current, {
  bool includeRadialBar = false,
}) {
  final options = includeRadialBar
      ? const [
          RecapCategoryChartType.bar,
          RecapCategoryChartType.pie,
          RecapCategoryChartType.donut,
          RecapCategoryChartType.radialBar,
        ]
      : const [
          RecapCategoryChartType.bar,
          RecapCategoryChartType.pie,
          RecapCategoryChartType.donut,
        ];
  final nextIndex = (options.indexOf(current) + 1) % options.length;
  return options[nextIndex];
}

RecapMonthlyChartType nextMonthlyChartType(RecapMonthlyChartType current) {
  const options = [
    RecapMonthlyChartType.bar,
    RecapMonthlyChartType.line,
    RecapMonthlyChartType.splineArea,
  ];
  final nextIndex = (options.indexOf(current) + 1) % options.length;
  return options[nextIndex];
}

Widget buildCategoryChartTypeIcon(RecapCategoryChartType chartType) {
  switch (chartType) {
    case RecapCategoryChartType.bar:
      return const FaIcon(FontAwesomeIcons.chartSimple, size: 16);
    case RecapCategoryChartType.pie:
      return const FaIcon(FontAwesomeIcons.chartPie, size: 16);
    case RecapCategoryChartType.donut:
      return const Icon(Icons.donut_large, size: 20);
    case RecapCategoryChartType.radialBar:
      return const Icon(Icons.track_changes, size: 20);
  }
}

Widget buildMonthlyChartTypeIcon(RecapMonthlyChartType chartType) {
  switch (chartType) {
    case RecapMonthlyChartType.bar:
      return const FaIcon(FontAwesomeIcons.chartSimple, size: 16);
    case RecapMonthlyChartType.line:
      return const FaIcon(FontAwesomeIcons.chartLine, size: 16);
    case RecapMonthlyChartType.splineArea:
      return const Icon(Icons.area_chart, size: 20);
  }
}

Widget buildRecapCategoricalChart<T>({
  required RecapCategoryChartType chartType,
  required List<T> items,
  required String Function(T) labelOf,
  required int Function(T) countOf,
  required String Function(T) barDataLabelOf,
  required String Function(T) circularDataLabelOf,
  String Function(T)? radialDataLabelOf,
}) {
  switch (chartType) {
    case RecapCategoryChartType.bar:
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(isVisible: false),
        primaryYAxis: NumericAxis(),
        series: <BarSeries<T, String>>[
          BarSeries<T, String>(
            dataSource: items.reversed.toList(),
            xValueMapper: (T item, _) => labelOf(item),
            yValueMapper: (T item, _) => countOf(item),
            dataLabelMapper: (T item, _) => barDataLabelOf(item),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      );
    case RecapCategoryChartType.pie:
      return SfCircularChart(
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries<T, String>>[
          PieSeries<T, String>(
            dataSource: items,
            xValueMapper: (T item, _) => labelOf(item),
            yValueMapper: (T item, _) => countOf(item),
            dataLabelMapper: (T item, _) => circularDataLabelOf(item),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            enableTooltip: true,
          ),
        ],
      );
    case RecapCategoryChartType.donut:
      return SfCircularChart(
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries<T, String>>[
          DoughnutSeries<T, String>(
            dataSource: items,
            xValueMapper: (T item, _) => labelOf(item),
            yValueMapper: (T item, _) => countOf(item),
            dataLabelMapper: (T item, _) => circularDataLabelOf(item),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            enableTooltip: true,
          ),
        ],
      );
    case RecapCategoryChartType.radialBar:
      final int totalCount = items.fold<int>(
        0,
        (sum, item) => sum + countOf(item),
      );
      return SfCircularChart(
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries<T, String>>[
          RadialBarSeries<T, String>(
            dataSource: items,
            xValueMapper: (T item, _) => labelOf(item),
            yValueMapper: (T item, _) => countOf(item),
            dataLabelMapper: (T item, _) =>
                (radialDataLabelOf ?? circularDataLabelOf)(item),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            maximumValue: totalCount > 0 ? totalCount.toDouble() : null,
            useSeriesColor: true,
            trackOpacity: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            gap: '10%',
            enableTooltip: true,
          ),
        ],
      );
  }
}

Widget buildRecapMonthlyChart<T>({
  required BuildContext context,
  required RecapMonthlyChartType chartType,
  required List<T> items,
  required int Function(T) monthOf,
  required int Function(T) countOf,
  required String Function(T) nameOf,
}) {
  switch (chartType) {
    case RecapMonthlyChartType.bar:
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          interval: 1,
          // Reverse to show Jan at the top
          isInversed: true,
        ),
        primaryYAxis: NumericAxis(
          isVisible: true,
          interval: 5,
        ),
        series: <CartesianSeries<T, String>>[
          BarSeries<T, String>(
            dataSource: items,
            xValueMapper: (T data, _) =>
                WristCheckFormatter.getMonthName(monthOf(data)),
            yValueMapper: (T data, _) => countOf(data),
            dataLabelMapper: (T data, _) => nameOf(data),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.outer,
              overflowMode: OverflowMode.none,
              textStyle: TextStyle(fontSize: 10),
            ),
          ),
        ],
      );
    case RecapMonthlyChartType.line:
      return SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(interval: 1),
        primaryYAxis: NumericAxis(
          isVisible: true,
          interval: 5,
        ),
        series: <CartesianSeries<T, String>>[
          LineSeries<T, String>(
            dataSource: items,
            xValueMapper: (T data, _) =>
                WristCheckFormatter.getMonthName(monthOf(data)),
            yValueMapper: (T data, _) => countOf(data),
            dataLabelMapper: (T data, _) {
              final count = countOf(data);
              if (count <= 0) return '';
              final name = nameOf(data);
              return name.isNotEmpty ? name : '$count';
            },
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 9),
            ),
            markerSettings: const MarkerSettings(isVisible: true),
            enableTooltip: true,
          ),
        ],
      );
    case RecapMonthlyChartType.splineArea:
      final Color primaryColor = Theme.of(context).colorScheme.primary;
      return SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(interval: 1),
        primaryYAxis: NumericAxis(
          isVisible: true,
          interval: 5,
        ),
        series: <CartesianSeries<T, String>>[
          SplineAreaSeries<T, String>(
            dataSource: items,
            xValueMapper: (T data, _) =>
                WristCheckFormatter.getMonthName(monthOf(data)),
            yValueMapper: (T data, _) => countOf(data),
            dataLabelMapper: (T data, _) {
              final count = countOf(data);
              if (count <= 0) return '';
              final name = nameOf(data);
              return name.isNotEmpty ? name : '$count';
            },
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 9),
            ),
            splineType: SplineType.monotonic,
            color: primaryColor.withValues(alpha: 0.3),
            borderColor: primaryColor,
            borderWidth: 2,
            markerSettings: const MarkerSettings(isVisible: true),
            enableTooltip: true,
          ),
        ],
      );
  }
}
