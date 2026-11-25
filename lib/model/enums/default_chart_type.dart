import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';

enum DefaultChartType {
  bar,
  pie,
  donut,
  column,
  line,
  splineArea,
}

extension DefaultChartTypeExtension on DefaultChartType {
  bool get isYearOrDecadeOnly =>
      this == DefaultChartType.line || this == DefaultChartType.splineArea;

  static bool supportsLineAndArea(ChartGrouping grouping) =>
      grouping == ChartGrouping.year || grouping == ChartGrouping.decade;

  static List<DefaultChartType> optionsForGrouping(ChartGrouping grouping) {
    if (supportsLineAndArea(grouping)) {
      return DefaultChartType.values;
    }
    return const [
      DefaultChartType.bar,
      DefaultChartType.pie,
      DefaultChartType.donut,
      DefaultChartType.column,
    ];
  }

  DefaultChartType resolveForGrouping(ChartGrouping grouping) {
    if (isYearOrDecadeOnly && !supportsLineAndArea(grouping)) {
      return DefaultChartType.bar;
    }
    return this;
  }

  DefaultChartType nextForGrouping(ChartGrouping grouping) {
    final options = optionsForGrouping(grouping);
    final effective = resolveForGrouping(grouping);
    final nextIndex = (options.indexOf(effective) + 1) % options.length;
    return options[nextIndex];
  }

  String toLocalizedString(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case DefaultChartType.bar:
        return l.barChart;
      case DefaultChartType.pie:
        return l.pieChart;
      case DefaultChartType.donut:
        return l.donutChart;
      case DefaultChartType.column:
        return l.columnChart;
      case DefaultChartType.line:
        return l.lineChart;
      case DefaultChartType.splineArea:
        return l.splineAreaChart;
    }
  }

  Widget toIcon({double faSize = 18, double iconSize = 22}) {
    switch (this) {
      case DefaultChartType.bar:
        return FaIcon(FontAwesomeIcons.chartSimple, size: faSize);
      case DefaultChartType.pie:
        return FaIcon(FontAwesomeIcons.chartPie, size: faSize);
      case DefaultChartType.donut:
        return Icon(Icons.donut_large, size: iconSize);
      case DefaultChartType.column:
        return Icon(Icons.bar_chart, size: iconSize);
      case DefaultChartType.line:
        return FaIcon(FontAwesomeIcons.chartLine, size: faSize);
      case DefaultChartType.splineArea:
        return Icon(Icons.area_chart, size: iconSize);
    }
  }
}
