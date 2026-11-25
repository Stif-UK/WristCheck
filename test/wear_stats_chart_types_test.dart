import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/charts/wear_charts/wear_chart.dart';
import 'package:wristcheck/util/helper_classes.dart';

Watches _makeWatch({
  required String manufacturer,
  required String model,
  String? category = 'Diver',
  String? movement = 'Automatic',
  double? caseDiameter = 40.0,
  int? waterResistance = 200,
  int? year = 2020,
  String? status = 'In Collection',
}) {
  return Watches()
    ..manufacturer = manufacturer
    ..model = model
    ..category = category
    ..movement = movement
    ..caseDiameter = caseDiameter
    ..waterResistance = waterResistance
    ..year = year
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..status = status;
}

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  group('WristCheckPreferences DefaultChartType persistence & migration', () {
    test('defaults to bar when no preference is stored', () {
      expect(WristCheckPreferences.getDefaultChartType(), DefaultChartType.bar);
    });

    test('migrates legacy bool defaultChartType without crashing', () async {
      SharedPreferences.setMockInitialValues({'defaultChartType': true});
      await WristCheckPreferences.init();
      expect(WristCheckPreferences.getDefaultChartType(), DefaultChartType.bar);

      SharedPreferences.setMockInitialValues({'defaultChartType': false});
      await WristCheckPreferences.init();
      expect(WristCheckPreferences.getDefaultChartType(), DefaultChartType.pie);
    });

    test('persists and restores all 7 DefaultChartType values over legacy bool', () async {
      SharedPreferences.setMockInitialValues({'defaultChartType': false});
      await WristCheckPreferences.init();

      for (final type in DefaultChartType.values) {
        await WristCheckPreferences.setDefaultChartType(type);
        expect(WristCheckPreferences.getDefaultChartType(), type);
      }
    });

    test('falls back safely to bar if removed radialBar value was previously stored', () async {
      SharedPreferences.setMockInitialValues({'defaultChartTypeV2': 'radialBar'});
      await WristCheckPreferences.init();
      expect(WristCheckPreferences.getDefaultChartType(), DefaultChartType.bar);
    });
  });

  group('DefaultChartType grouping options, resolution & cycling', () {
    test('general groupings expose 4 chart types and resolve line/splineArea to bar', () {
      const generalGroupings = [
        ChartGrouping.watch,
        ChartGrouping.manufacturer,
        ChartGrouping.movement,
        ChartGrouping.category,
        ChartGrouping.colour,
        ChartGrouping.caseMaterial,
        ChartGrouping.dateComplication,
        ChartGrouping.caseDiameter,
        ChartGrouping.lugWidth,
        ChartGrouping.lug2lug,
        ChartGrouping.caseThickness,
        ChartGrouping.waterResistance,
      ];

      for (final grouping in generalGroupings) {
        expect(
          DefaultChartTypeExtension.optionsForGrouping(grouping),
          const [
            DefaultChartType.bar,
            DefaultChartType.pie,
            DefaultChartType.donut,
            DefaultChartType.column,
          ],
        );
        expect(DefaultChartType.line.resolveForGrouping(grouping), DefaultChartType.bar);
        expect(DefaultChartType.splineArea.resolveForGrouping(grouping), DefaultChartType.bar);

        var current = DefaultChartType.bar;
        final visited = <DefaultChartType>[];
        for (int i = 0; i < 4; i++) {
          visited.add(current);
          current = current.nextForGrouping(grouping);
        }
        expect(visited, [
          DefaultChartType.bar,
          DefaultChartType.pie,
          DefaultChartType.donut,
          DefaultChartType.column,
        ]);
        expect(current, DefaultChartType.bar);
      }
    });

    test('year and decade groupings expose and cycle all 6 chart types', () {
      for (final grouping in [ChartGrouping.year, ChartGrouping.decade]) {
        expect(
          DefaultChartTypeExtension.optionsForGrouping(grouping),
          DefaultChartType.values,
        );
        expect(DefaultChartType.line.resolveForGrouping(grouping), DefaultChartType.line);
        expect(
          DefaultChartType.splineArea.resolveForGrouping(grouping),
          DefaultChartType.splineArea,
        );

        var current = DefaultChartType.bar;
        final visited = <DefaultChartType>[];
        for (int i = 0; i < 6; i++) {
          visited.add(current);
          current = current.nextForGrouping(grouping);
        }
        expect(visited, [
          DefaultChartType.bar,
          DefaultChartType.pie,
          DefaultChartType.donut,
          DefaultChartType.column,
          DefaultChartType.line,
          DefaultChartType.splineArea,
        ]);
        expect(current, DefaultChartType.bar);
      }
    });
  });

  group('WearChart rendering across all chart types and groupings', () {
    void Function(FlutterErrorDetails)? _originalOnError;
    bool _errorFilterInstalled = false;

    Future<void> pumpWearChart(
      WidgetTester tester, {
      required WearChart chart,
    }) async {
      if (!_errorFilterInstalled) {
        _errorFilterInstalled = true;
        _originalOnError = FlutterError.onError;
        // Filter Syncfusion 28.2.4+1 unmount assertion on Flutter 3.32+
        FlutterError.onError = (FlutterErrorDetails details) {
          final full = details.toString();
          final stack = details.stack?.toString() ?? '';
          if (full.contains('A disposed RenderObject was mutated') &&
              full.contains('RenderChartFadeTransition') &&
              stack.contains('syncfusion_flutter_charts')) {
            return;
          }
          _originalOnError?.call(details);
        };
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          FlutterError.onError = _originalOnError;
          _errorFilterInstalled = false;
        });
      }

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 500,
              child: chart,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows empty background text when no data or no matching grouped points', (tester) async {
      await pumpWearChart(
        tester,
        chart: const WearChart(
          data: [],
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.column,
        ),
      );
      expect(find.byType(SfCartesianChart), findsNothing);
      expect(find.byType(SfCircularChart), findsNothing);
      expect(find.text('No data available for the chosen filter'), findsOneWidget);

      final noYearWatch = _makeWatch(manufacturer: 'Casio', model: 'F-91W', year: null);
      await pumpWearChart(
        tester,
        chart: WearChart(
          data: [WornWatchesClass(noYearWatch, 5, '100%')],
          animate: false,
          grouping: ChartGrouping.year,
          chartType: DefaultChartType.line,
        ),
      );
      expect(find.byType(SfCartesianChart), findsNothing);
      expect(find.text('No data available for the chosen filter'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('cycles bar -> pie -> donut -> column -> bar cleanly on general grouping and falls back line -> bar', (tester) async {
      final data = [
        WornWatchesClass(
          _makeWatch(manufacturer: 'Omega', model: 'Speedmaster', status: 'In Collection'),
          10,
          '66.7%',
        ),
        WornWatchesClass(
          _makeWatch(manufacturer: 'Seiko', model: 'Alpinist', status: 'Sold'),
          5,
          '33.3%',
        ),
      ];

      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.bar,
        ),
      );
      final barChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(barChart.series.first, isA<BarSeries<dynamic, String>>());

      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.pie,
        ),
      );
      final pieChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      expect(pieChart.series.first, isA<PieSeries<dynamic, String>>());

      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.donut,
        ),
      );
      final donutChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      expect(donutChart.series.first, isA<DoughnutSeries<dynamic, String>>());

      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.column,
        ),
      );
      final columnChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(columnChart.series.first, isA<ColumnSeries<dynamic, String>>());

      // Cycling column -> bar must not fail Syncfusion CategoryAxis assertions
      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.bar,
        ),
      );
      final backToBarChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(backToBarChart.series.first, isA<BarSeries<dynamic, String>>());

      // Line on non-year/decade grouping falls back cleanly to BarSeries
      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.watch,
          chartType: DefaultChartType.line,
        ),
      );
      final fallbackChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(fallbackChart.series.first, isA<BarSeries<dynamic, String>>());
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('renders line and splineArea sorted chronologically for year and decade groupings', (tester) async {
      await WristCheckPreferences.setWearChartOrder(ChartOrdering.ascending);

      final data = [
        WornWatchesClass(_makeWatch(manufacturer: 'Omega', model: 'New', year: 2022), 20, '50%'),
        WornWatchesClass(_makeWatch(manufacturer: 'Seiko', model: 'Vintage', year: 1995), 5, '12.5%'),
        WornWatchesClass(_makeWatch(manufacturer: 'Rolex', model: 'Mid', year: 2008), 15, '37.5%'),
      ];

      await pumpWearChart(
        tester,
        chart: WearChart(
          key: const ValueKey('year_line'),
          data: data,
          animate: false,
          grouping: ChartGrouping.year,
          chartType: DefaultChartType.line,
        ),
      );
      final lineChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(lineChart.series.first, isA<LineSeries<dynamic, String>>());
      final dynamic lineSeries = lineChart.series.first;
      final List<dynamic> lineData = lineSeries.dataSource as List<dynamic>;
      final lineLabels = [
        for (int i = 0; i < lineData.length; i++)
          (lineSeries.xValueMapper as Function)(lineData[i], i),
      ];
      expect(lineLabels, ['1995', '2008', '2022']);

      await pumpWearChart(
        tester,
        chart: WearChart(
          key: const ValueKey('decade_area'),
          data: data,
          animate: false,
          grouping: ChartGrouping.decade,
          chartType: DefaultChartType.splineArea,
        ),
      );
      final areaChart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(areaChart.series.first, isA<SplineAreaSeries<dynamic, String>>());
      final dynamic areaSeries = areaChart.series.first;
      final List<dynamic> areaData = areaSeries.dataSource as List<dynamic>;
      final areaLabels = [
        for (int i = 0; i < areaData.length; i++)
          (areaSeries.xValueMapper as Function)(areaData[i], i),
      ];
      expect(areaLabels, ['1990s', '2000s', '2020s']);
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('waterResistance grouping uses waterResistance values and wrUnitOverride', (tester) async {
      final data = [
        WornWatchesClass(
          _makeWatch(manufacturer: 'Omega', model: 'Seamaster', caseDiameter: 42.0, waterResistance: 300),
          12,
          '100%',
        ),
      ];

      await pumpWearChart(
        tester,
        chart: WearChart(
          data: data,
          animate: false,
          grouping: ChartGrouping.waterResistance,
          chartType: DefaultChartType.column,
          wrUnitOverride: WRUnitsEnum.feet,
        ),
      );

      final chart = tester.widget<SfCartesianChart>(find.byType(SfCartesianChart));
      expect(chart.series.first, isA<ColumnSeries<dynamic, String>>());
      final dynamic colSeries = chart.series.first;
      final List<dynamic> colData = colSeries.dataSource as List<dynamic>;
      expect((colSeries.xValueMapper as Function)(colData.first, 0), '300 feet');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
