import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_brand_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_category_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_watch_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/brand_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/category_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/status_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/helper_classes.dart';

Watches _makeWatch(String manufacturer, String model) {
  return Watches()
    ..manufacturer = manufacturer
    ..model = model
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..status = 'In Collection';
}

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  group('Chart type cycle helpers', () {
    test('nextCategoryChartType cycles bar -> pie -> donut without radialBar', () {
      var type = RecapCategoryChartType.bar;
      type = nextCategoryChartType(type);
      expect(type, RecapCategoryChartType.pie);
      type = nextCategoryChartType(type);
      expect(type, RecapCategoryChartType.donut);
      type = nextCategoryChartType(type);
      expect(type, RecapCategoryChartType.bar);
    });

    test('nextCategoryChartType cycles bar -> pie -> donut -> radialBar with radialBar', () {
      var type = RecapCategoryChartType.bar;
      type = nextCategoryChartType(type, includeRadialBar: true);
      expect(type, RecapCategoryChartType.pie);
      type = nextCategoryChartType(type, includeRadialBar: true);
      expect(type, RecapCategoryChartType.donut);
      type = nextCategoryChartType(type, includeRadialBar: true);
      expect(type, RecapCategoryChartType.radialBar);
      type = nextCategoryChartType(type, includeRadialBar: true);
      expect(type, RecapCategoryChartType.bar);
    });

    test('nextMonthlyChartType cycles bar -> line -> splineArea', () {
      var type = RecapMonthlyChartType.bar;
      type = nextMonthlyChartType(type);
      expect(type, RecapMonthlyChartType.line);
      type = nextMonthlyChartType(type);
      expect(type, RecapMonthlyChartType.splineArea);
      type = nextMonthlyChartType(type);
      expect(type, RecapMonthlyChartType.bar);
    });
  });

  group('WristRecap chart type switching widgets', () {
    Future<void> pumpChartWidget(
      WidgetTester tester, {
      required Widget child,
      Size screenSize = const Size(400, 800),
    }) async {
      // Filter Syncfusion 28.2.4+1 unmount assertion on Flutter 3.32+
      final previousOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        final msg = details.exceptionAsString();
        final stack = details.stack?.toString() ?? '';
        if (msg.contains('A disposed RenderObject was mutated') &&
            msg.contains('RenderChartFadeTransition') &&
            stack.contains('syncfusion_flutter_charts')) {
          return;
        }
        previousOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = previousOnError);

      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(child: child),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    WristRecapController seedController() {
      final controller = Get.put(WristRecapController());
      controller.selectedRecapOption(WristRecapEnums.annually);
      controller.duplicateBrand(true);

      final omega = _makeWatch('Omega', 'Speedmaster');
      final seiko = _makeWatch('Seiko', 'Alpinist');

      controller.watchesWorn([
        WornWatchesClass(omega, 10, '66.7 %'),
        WornWatchesClass(seiko, 5, '33.3 %'),
      ]);
      controller.brandsWorn([
        ManufacturersWornClass('Omega', 10, '66.7 %'),
        ManufacturersWornClass('Seiko', 5, '33.3 %'),
      ]);
      controller.categoriesWorn([
        CategoriesWornClass('Chronograph', 10, '66.7 %'),
        CategoriesWornClass('Field', 5, '33.3 %'),
      ]);
      controller.statusWorn([
        StatusWornClass('In Collection', 12, '80.0 %'),
        StatusWornClass('Sold', 3, '20.0 %'),
      ]);
      controller.topWatchMonthly([
        for (int m = 1; m <= 12; m++)
          TopWatchMonthlyClass(m, m.isOdd ? omega : seiko, m + 1),
      ]);
      controller.topBrandMonthly([
        for (int m = 1; m <= 12; m++)
          TopBrandMonthlyClass(m, m.isOdd ? 'Omega' : 'Seiko', m + 1),
      ]);
      controller.topCategoryMonthly([
        for (int m = 1; m <= 12; m++)
          TopCategoryMonthlyClass(m, m.isOdd ? 'Chronograph' : 'Field', m + 1),
      ]);
      return controller;
    }

    testWidgets('WearChart cycles bar -> pie -> donut -> bar and does not persist', (tester) async {
      seedController();

      await pumpChartWidget(
        tester,
        child: WearChart(
          key: const ValueKey('run1'),
          isAppProOverride: true,
        ),
      );

      expect(find.byType(SfCartesianChart), findsOneWidget);
      expect(find.byType(SfCircularChart), findsNothing);

      // Bar -> Pie
      await tester.tap(find.byKey(const Key('wear_chart_type_button')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SfCircularChart), findsOneWidget);
      final wearPieChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      final wearPieSeries = wearPieChart.series.first as PieSeries<WornWatchesClass, String>;
      expect(
        wearPieSeries.dataLabelMapper!(wearPieSeries.dataSource!.first, 0),
        contains('Omega Speedmaster: 10'),
      );

      // Pie -> Donut
      await tester.tap(find.byKey(const Key('wear_chart_type_button')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SfCircularChart), findsOneWidget);
      expect(find.byIcon(Icons.donut_large), findsOneWidget);
      final wearDonutChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      final wearDonutSeries = wearDonutChart.series.first as DoughnutSeries<WornWatchesClass, String>;
      expect(
        wearDonutSeries.dataLabelMapper!(wearDonutSeries.dataSource!.first, 0),
        contains('Omega Speedmaster: 10'),
      );

      // Remounting starts back at Bar (non-persistent)
      await pumpChartWidget(
        tester,
        child: WearChart(
          key: const ValueKey('run2'),
          isAppProOverride: true,
        ),
      );
      expect(find.byType(SfCartesianChart), findsOneWidget);
      expect(find.byType(SfCircularChart), findsNothing);
    });

    testWidgets('BrandChart cycles bar -> pie -> donut -> bar', (tester) async {
      seedController();
      await pumpChartWidget(tester, child: const BrandChart());

      expect(find.byType(SfCartesianChart), findsOneWidget);

      await tester.tap(find.byKey(const Key('brand_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCircularChart), findsOneWidget);
      final brandPieChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      final brandPieSeries = brandPieChart.series.first as PieSeries<ManufacturersWornClass, String>;
      expect(
        brandPieSeries.dataLabelMapper!(brandPieSeries.dataSource!.first, 0),
        'Omega: 10',
      );

      await tester.tap(find.byKey(const Key('brand_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.donut_large), findsOneWidget);

      await tester.tap(find.byKey(const Key('brand_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });

    testWidgets('CategoryChart and StatusWearChart cycle bar -> pie -> donut -> radialBar -> bar',
        (tester) async {
      seedController();

      await pumpChartWidget(tester, child: CategoryChart());
      expect(find.byType(SfCartesianChart), findsOneWidget);

      // -> Pie
      await tester.tap(find.byKey(const Key('category_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCircularChart), findsOneWidget);
      final catPieChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      final catPieSeries = catPieChart.series.first as PieSeries<CategoriesWornClass, String>;
      expect(
        catPieSeries.dataLabelMapper!(catPieSeries.dataSource!.first, 0),
        'Chronograph: 10',
      );

      // -> Donut
      await tester.tap(find.byKey(const Key('category_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.donut_large), findsOneWidget);

      // -> RadialBar
      await tester.tap(find.byKey(const Key('category_chart_type_button')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SfCircularChart), findsOneWidget);
      expect(find.byIcon(Icons.track_changes), findsOneWidget);

      // -> Bar
      await tester.tap(find.byKey(const Key('category_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCartesianChart), findsOneWidget);

      // Now test StatusWearChart
      await pumpChartWidget(tester, child: StatusWearChart());
      expect(find.byType(SfCartesianChart), findsOneWidget);

      await tester.tap(find.byKey(const Key('status_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCircularChart), findsOneWidget);
      final statusPieChart = tester.widget<SfCircularChart>(find.byType(SfCircularChart));
      final statusPieSeries = statusPieChart.series.first as PieSeries<StatusWornClass, String>;
      expect(
        statusPieSeries.dataLabelMapper!(statusPieSeries.dataSource!.first, 0),
        'In Collection: 80.0 %',
      );

      await tester.tap(find.byKey(const Key('status_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.donut_large), findsOneWidget);

      await tester.tap(find.byKey(const Key('status_chart_type_button')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.track_changes), findsOneWidget);

      await tester.tap(find.byKey(const Key('status_chart_type_button')));
      await tester.pumpAndSettle();
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });

    testWidgets('Monthly annual charts cycle bar -> line -> splineArea -> bar without overflow',
        (tester) async {
      seedController();

      for (final entry in [
        (const TopWatchMonthly(), const Key('top_watch_monthly_chart_type_button')),
        (const TopBrandMonthly(), const Key('top_brand_monthly_chart_type_button')),
        (const TopCategoryMonthly(), const Key('top_category_monthly_chart_type_button')),
      ]) {
        await pumpChartWidget(tester, child: entry.$1);

        expect(find.byType(SfCartesianChart), findsOneWidget);
        final barIcon = tester.widget<FaIcon>(
          find.descendant(of: find.byKey(entry.$2), matching: find.byType(FaIcon)),
        );
        expect(barIcon.icon, FontAwesomeIcons.chartSimple.data);

        // -> Line
        await tester.tap(find.byKey(entry.$2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(SfCartesianChart), findsOneWidget);
        final lineIcon = tester.widget<FaIcon>(
          find.descendant(of: find.byKey(entry.$2), matching: find.byType(FaIcon)),
        );
        expect(lineIcon.icon, FontAwesomeIcons.chartLine.data);

        // -> Spline Area
        await tester.tap(find.byKey(entry.$2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(SfCartesianChart), findsOneWidget);
        expect(find.byIcon(Icons.area_chart), findsOneWidget);

        // -> Bar
        await tester.tap(find.byKey(entry.$2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final backToBarIcon = tester.widget<FaIcon>(
          find.descendant(of: find.byKey(entry.$2), matching: find.byType(FaIcon)),
        );
        expect(backToBarIcon.icon, FontAwesomeIcons.chartSimple.data);
      }
    });

    testWidgets('all updated charts render cleanly in 2-column tablet ResponsiveWristRecapBody',
        (tester) async {
      seedController();
      await pumpChartWidget(
        tester,
        screenSize: const Size(1000, 1200),
        child: ResponsiveWristRecapBody(
          cards: [
            WearChart(isAppProOverride: true),
            const BrandChart(),
            CategoryChart(),
            StatusWearChart(),
            const TopWatchMonthly(),
            const TopBrandMonthly(),
            const TopCategoryMonthly(),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SfCartesianChart), findsNWidgets(7));
    });
  });
}
