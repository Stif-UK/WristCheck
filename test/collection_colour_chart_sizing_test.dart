import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/charts/collection_charts/colour_chart.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';

Watches _makeWatch({
  String manufacturer = 'Omega',
  String model = 'Seamaster',
  String? primaryColour,
  String? secondaryColour,
}) {
  return Watches()
    ..manufacturer = manufacturer
    ..model = model
    ..status = 'In Collection'
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..primaryColour = primaryColour
    ..secondaryColour = secondaryColour;
}

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  group('ColourChart line counting and space calculation helpers', () {
    test('getLinesToDraw returns line count for stackedBar and 0 for pie/donut', () {
      expect(ColourChart.getLinesToDraw(ColourChartEnum.stackedBar, 15), 15);
      expect(ColourChart.getLinesToDraw(ColourChartEnum.stackedBar, 5), 5);
      expect(ColourChart.getLinesToDraw(ColourChartEnum.pie, 15), 0);
      expect(ColourChart.getLinesToDraw(ColourChartEnum.donut, 15), 0);
    });

    testWidgets('ChartHelper.calculateChartSpace scales when dataSize > 10', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final double screenHeight = MediaQuery.of(context).size.height;
              final double expectedBase = screenHeight * 0.45;

              expect(ChartHelper.calculateChartSpace(context, 0), expectedBase);
              expect(ChartHelper.calculateChartSpace(context, 5), expectedBase);
              expect(ChartHelper.calculateChartSpace(context, 10), expectedBase);

              // 15 lines -> 1.5 * base
              expect(
                ChartHelper.calculateChartSpace(context, 15),
                closeTo(expectedBase * 1.5, 0.001),
              );

              // 20 lines -> 2.0 * base
              expect(
                ChartHelper.calculateChartSpace(context, 20),
                closeTo(expectedBase * 2.0, 0.001),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });

  group('ColourChart widget sizing', () {
    Future<void> pumpColourChart(
      WidgetTester tester, {
      required List<Watches> watches,
      Size screenSize = const Size(400, 800),
    }) async {
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
            body: SingleChildScrollView(
              child: ColourChart(watchesOverride: watches),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders fixed 100 height when no colour data recorded', (tester) async {
      await pumpColourChart(
        tester,
        watches: [
          _makeWatch(primaryColour: null, secondaryColour: null),
          _makeWatch(primaryColour: '', secondaryColour: '   '),
        ],
      );

      expect(find.text('No colour data recorded'), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 100);
    });

    testWidgets('uses base height when unique colour lines <= 10', (tester) async {
      const screenSize = Size(400, 800);
      final watches = List.generate(
        5,
        (i) => _makeWatch(primaryColour: 'Colour_$i'),
      );

      await pumpColourChart(tester, watches: watches, screenSize: screenSize);

      final sizedBoxFinder = find.byKey(const Key('colour_chart_sized_box'));
      expect(sizedBoxFinder, findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
      const expectedBase = 800 * 0.45; // 360.0
      expect(sizedBox.height, closeTo(expectedBase, 0.001));
    });

    testWidgets('resizes dynamically based on number of lines drawn (> 10)', (tester) async {
      const screenSize = Size(400, 800);
      const expectedBase = 800 * 0.45; // 360.0

      // 15 unique colours -> 15 lines in stackedBar
      final watches = List.generate(
        15,
        (i) => _makeWatch(primaryColour: 'Colour_$i'),
      );

      await pumpColourChart(tester, watches: watches, screenSize: screenSize);

      final sizedBoxFinder = find.byKey(const Key('colour_chart_sized_box'));
      expect(sizedBoxFinder, findsOneWidget);

      final sizedBoxStacked = tester.widget<SizedBox>(sizedBoxFinder);
      // 15 lines / 10 = 1.5 * base = 540.0
      expect(sizedBoxStacked.height, closeTo(expectedBase * 1.5, 0.001));

      // Switch to pie chart -> 0 lines drawn, reverts to base size
      final controller = Get.find<CollectionStatsController>();
      controller.updateColourChartType(ColourChartEnum.pie);
      await tester.pumpAndSettle();

      final sizedBoxPie = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBoxPie.height, closeTo(expectedBase, 0.001));

      // Switch to donut chart -> 0 lines drawn, stays at base size
      controller.updateColourChartType(ColourChartEnum.donut);
      await tester.pumpAndSettle();

      final sizedBoxDonut = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBoxDonut.height, closeTo(expectedBase, 0.001));

      // Switch back to stacked bar -> 15 lines drawn, expands back to 1.5x
      controller.updateColourChartType(ColourChartEnum.stackedBar);
      await tester.pumpAndSettle();

      final sizedBoxStackedAgain = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBoxStackedAgain.height, closeTo(expectedBase * 1.5, 0.001));
    });

    testWidgets('counts lines by unique colours, not watch count', (tester) async {
      const screenSize = Size(400, 800);
      const expectedBase = 800 * 0.45; // 360.0

      // 30 watches, but only 3 distinct colours -> 3 lines drawn
      final watches = List.generate(
        30,
        (i) => _makeWatch(
          primaryColour: i % 2 == 0 ? 'Black' : 'Blue',
          secondaryColour: i % 3 == 0 ? 'White' : null,
        ),
      );

      await pumpColourChart(tester, watches: watches, screenSize: screenSize);

      final sizedBoxFinder = find.byKey(const Key('colour_chart_sized_box'));
      final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);

      // Only 3 lines drawn (<= 10), so base size is used
      expect(sizedBox.height, closeTo(expectedBase, 0.001));
    });
  });
}
