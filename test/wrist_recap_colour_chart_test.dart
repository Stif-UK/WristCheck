import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/colour_chart.dart';
import 'package:wristcheck/util/helper_classes.dart';

Watches _makeWatch({
  String manufacturer = 'Seiko',
  String model = 'Alpinist',
  String? primaryColour,
  String? secondaryColour,
}) {
  return Watches()
    ..manufacturer = manufacturer
    ..model = model
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..primaryColour = primaryColour
    ..secondaryColour = secondaryColour;
}

void main() {
  setUp(() {
    Get.reset();
  });

  group('WristRecapController.buildColourData', () {
    test('returns empty list when no worn watches exist', () {
      expect(WristRecapController.buildColourData([]), isEmpty);
    });

    test('ignores null, empty, whitespace, and Not Entered colours', () {
      final wornList = [
        WornWatchesClass(_makeWatch(primaryColour: null, secondaryColour: ''), 3),
        WornWatchesClass(_makeWatch(primaryColour: '   ', secondaryColour: 'Not Entered'), 2),
      ];

      expect(WristRecapController.buildColourData(wornList), isEmpty);
    });

    test('aggregates primary and secondary wear counts and sorts ascending by total', () {
      final wornList = [
        WornWatchesClass(_makeWatch(primaryColour: ' Blue ', secondaryColour: 'Gold'), 4),
        WornWatchesClass(_makeWatch(primaryColour: 'Black', secondaryColour: 'Blue'), 2),
        WornWatchesClass(_makeWatch(primaryColour: 'Green', secondaryColour: null), 1),
      ];

      final result = WristRecapController.buildColourData(wornList);

      expect(result.map((e) => e.colour).toList(), ['Green', 'Black', 'Gold', 'Blue']);

      expect(result[0].colour, 'Green');
      expect(result[0].primaryCount, 1);
      expect(result[0].secondaryCount, 0);

      expect(result[1].colour, 'Black');
      expect(result[1].primaryCount, 2);
      expect(result[1].secondaryCount, 0);

      expect(result[2].colour, 'Gold');
      expect(result[2].primaryCount, 0);
      expect(result[2].secondaryCount, 4);

      expect(result[3].colour, 'Blue');
      expect(result[3].primaryCount, 4);
      expect(result[3].secondaryCount, 2);
      expect(result[3].totalCount, 6);
    });
  });

  group('WristRecapColourChart widget', () {
    Future<void> pumpChart(
      WidgetTester tester, {
      required List<ColourData> colours,
      Size screenSize = const Size(400, 800),
      bool wrapInResponsiveBody = false,
    }) async {
      // Syncfusion charts 28.2.4+1 throws a debug assertion on unmount in Flutter 3.32+
      // when dataLabelSettings is visible (`RenderChartFadeTransition DISPOSED`).
      // Filter only that library unmount assertion so real errors (e.g. overflows) still fail.
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

      final controller = Get.put(WristRecapController());
      controller.coloursWorn(colours);

      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final Widget content = wrapInResponsiveBody
          ? ResponsiveWristRecapBody(
              cards: const [
                WristRecapColourChart(),
                Card(child: SizedBox(height: 200)),
              ],
            )
          : const SingleChildScrollView(child: WristRecapColourChart());

      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: content),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders stacked bar chart by default and expands/collapses on tap', (tester) async {
      await pumpChart(
        tester,
        colours: [
          ColourData('Green', 1, 0),
          ColourData('Blue', 4, 2),
        ],
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Colour Chart'), findsOneWidget);
      expect(find.text('(primary colour only)'), findsNothing);
      expect(find.byType(SfCartesianChart), findsOneWidget);
      expect(find.byType(SfCircularChart), findsNothing);

      final chartFinder = find.byType(SfCartesianChart);
      final initialHeight = tester.getSize(chartFinder).height;
      expect(initialHeight, closeTo(800 * 0.35, 0.01));

      await tester.tap(find.byKey(const Key('colour_chart_expand_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final expandedHeight = tester.getSize(chartFinder).height;
      expect(expandedHeight, closeTo(initialHeight * 1.5, 0.01));

      await tester.tap(find.byKey(const Key('colour_chart_expand_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(chartFinder).height, closeTo(initialHeight, 0.01));
    });

    testWidgets('cycles between stacked bar, pie, and donut charts', (tester) async {
      await pumpChart(
        tester,
        colours: [
          ColourData('Black', 2, 1),
          ColourData('Blue', 4, 0),
        ],
      );

      // Starts as stacked bar
      expect(find.byType(SfCartesianChart), findsOneWidget);

      // Cycle -> Pie
      await tester.tap(find.byKey(const Key('colour_chart_type_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SfCircularChart), findsOneWidget);
      expect(find.text('(primary colour only)'), findsOneWidget);

      // Cycle -> Donut
      await tester.tap(find.byKey(const Key('colour_chart_type_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SfCircularChart), findsOneWidget);
      expect(find.text('(primary colour only)'), findsOneWidget);
      expect(find.byIcon(Icons.donut_large), findsOneWidget);

      // Cycle -> Stacked Bar
      await tester.tap(find.byKey(const Key('colour_chart_type_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SfCartesianChart), findsOneWidget);
      expect(find.text('(primary colour only)'), findsNothing);
    });

    testWidgets('renders cleanly inside 2-column tablet layout without overflow', (tester) async {
      await pumpChart(
        tester,
        screenSize: const Size(1000, 800),
        wrapInResponsiveBody: true,
        colours: [
          ColourData('Green', 1, 2),
          ColourData('Blue', 4, 1),
        ],
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(WristRecapColourChart), findsOneWidget);
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });

    testWidgets('shows empty state message in pie/donut when only secondary colours exist', (tester) async {
      await pumpChart(
        tester,
        colours: [
          ColourData('Gold', 0, 3),
        ],
      );

      await tester.tap(find.byKey(const Key('colour_chart_type_button')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('No colour data recorded'), findsOneWidget);
    });
  });
}
