import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/collection_stats/collection_charts.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_completeness_indicator.dart';

Watches _makeWatch({
  String manufacturer = 'Omega',
  String model = 'Seamaster',
  String status = 'In Collection',
  int? purchasePrice = 5000,
  List<DateTime>? wearList,
  String? movement = 'Mechanical - Automatic',
  String? category = 'Diver',
  String? primaryColour = 'Blue',
  String? secondaryColour,
  int? year = 2020,
  String? dateComplication = 'Date',
  double? caseDiameter = 42.0,
  int? lugWidth = 20,
  double? lug2lug = 49.0,
  double? caseThickness = 13.5,
  int? powerReserve = 55,
  int? waterResistance = 300,
  String? caseMaterial = 'Steel',
}) {
  return Watches()
    ..manufacturer = manufacturer
    ..model = model
    ..status = status
    ..purchasePrice = purchasePrice
    ..wearList = wearList ?? [DateTime(2026, 1, 1)]
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..movement = movement
    ..category = category
    ..primaryColour = primaryColour
    ..secondaryColour = secondaryColour
    ..year = year
    ..dateComplication = dateComplication
    ..caseDiameter = caseDiameter
    ..lugWidth = lugWidth
    ..lug2lug = lug2lug
    ..caseThickness = caseThickness
    ..powerReserve = powerReserve
    ..waterResistance = waterResistance
    ..caseMaterial = caseMaterial;
}

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  group('CollectionStatsController completeness & visibility helpers', () {
    test('detects complete vs partial collection data across all chart fields', () {
      final complete = [_makeWatch(), _makeWatch(model: 'Speedmaster', year: 2022)];

      expect(CollectionStatsController.hasModelYearData(complete), isTrue);
      expect(CollectionStatsController.isCostPerWearComplete(complete), isTrue);
      expect(CollectionStatsController.isMovementComplete(complete), isTrue);
      expect(CollectionStatsController.isCategoryComplete(complete), isTrue);
      expect(CollectionStatsController.isColourComplete(complete), isTrue);
      expect(CollectionStatsController.isModelYearComplete(complete), isTrue);
      expect(CollectionStatsController.isDateComplicationComplete(complete), isTrue);
      expect(CollectionStatsController.isCaseDiameterComplete(complete), isTrue);
      expect(CollectionStatsController.isLugWidthComplete(complete), isTrue);
      expect(CollectionStatsController.isLugToLugComplete(complete), isTrue);
      expect(CollectionStatsController.isCaseThicknessComplete(complete), isTrue);
      expect(CollectionStatsController.isPowerReserveComplete(complete), isTrue);
      expect(CollectionStatsController.isWaterResistanceComplete(complete), isTrue);
      expect(CollectionStatsController.isCaseMaterialComplete(complete), isTrue);

      final partial = [
        _makeWatch(),
        _makeWatch(
          model: 'Missing Fields',
          purchasePrice: null,
          movement: 'Not Entered',
          category: '',
          primaryColour: null,
          secondaryColour: null,
          year: 0,
          dateComplication: null,
          caseDiameter: 0.0,
          lugWidth: null,
          lug2lug: null,
          caseThickness: 0.0,
          powerReserve: null,
          waterResistance: 0,
          caseMaterial: 'Not Selected',
        ),
      ];

      expect(CollectionStatsController.hasModelYearData(partial), isTrue);
      expect(CollectionStatsController.isCostPerWearComplete(partial), isFalse);
      expect(CollectionStatsController.isMovementComplete(partial), isFalse);
      expect(CollectionStatsController.isCategoryComplete(partial), isFalse);
      expect(CollectionStatsController.isColourComplete(partial), isFalse);
      expect(CollectionStatsController.isModelYearComplete(partial), isFalse);
      expect(CollectionStatsController.isDateComplicationComplete(partial), isFalse);
      expect(CollectionStatsController.isCaseDiameterComplete(partial), isFalse);
      expect(CollectionStatsController.isLugWidthComplete(partial), isFalse);
      expect(CollectionStatsController.isLugToLugComplete(partial), isFalse);
      expect(CollectionStatsController.isCaseThicknessComplete(partial), isFalse);
      expect(CollectionStatsController.isPowerReserveComplete(partial), isFalse);
      expect(CollectionStatsController.isWaterResistanceComplete(partial), isFalse);
      expect(CollectionStatsController.isCaseMaterialComplete(partial), isFalse);
    });

    test('hasModelYearData returns false when no watches have valid years', () {
      final noYears = [
        _makeWatch(year: null),
        _makeWatch(model: 'Zero Year', year: 0),
      ];
      expect(CollectionStatsController.hasModelYearData(noYears), isFalse);
    });
  });

  group('CollectionChartsBody', () {
    Future<void> pumpBody(
      WidgetTester tester, {
      required List<Watches> watches,
      bool isPro = true,
      Size screenSize = const Size(1000, 1200),
      VoidCallback? onNavigateToDataCompleteness,
    }) async {
      final previousOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        final msg = details.exceptionAsString();
        if (msg.contains('A disposed RenderObject was mutated') &&
            msg.contains('RenderChartFadeTransition')) {
          return;
        }
        previousOnError?.call(details);
      };

      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        FlutterError.onError = previousOnError;
      });

      await tester.pumpWidget(
        GetMaterialApp(
          key: UniqueKey(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CollectionChartsBody(
              collectionWatches: watches,
              isPro: isPro,
              localeOverride: LocationEnum.us,
              wrUnitOverride: WRUnitsEnum.metres,
              onNavigateToDataCompleteness: onNavigateToDataCompleteness,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Syncfusion 28.2.4+1's RenderChartFadeTransition throws during unmount in
      // Flutter 3.32+ and can abort _InactiveElements._unmountAll() before
      // sibling Tooltips dispose. Dispatching a harmless pointer tap while
      // mounted ensures RawTooltipState._backingController is initialized so
      // any later global pointer event safely no-ops.
      await tester.tapAt(Offset.zero);
      await tester.pump();
    }

    testWidgets('hides Model Year section completely when no model year data exists',
        (tester) async {
      await pumpBody(
        tester,
        isPro: false,
        watches: [
          _makeWatch(year: null),
          _makeWatch(model: 'No Year 2', year: 0),
        ],
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Model Year'), findsNothing);
      expect(find.byKey(const Key('collection_model_year_chart_type_button')), findsNothing);
    });

    testWidgets('shows green circles for complete data and routes to Data Completeness',
        (tester) async {
      bool navigated = false;
      await pumpBody(
        tester,
        isPro: true,
        watches: [
          _makeWatch(),
          _makeWatch(
            manufacturer: 'Seiko',
            model: 'Alpinist',
            movement: 'Mechanical - Manual',
            category: 'Field',
            primaryColour: 'Green',
            year: 2021,
            caseDiameter: 39.5,
            lugWidth: 20,
            waterResistance: 200,
            caseMaterial: 'Titanium',
          ),
        ],
        onNavigateToDataCompleteness: () => navigated = true,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Model Year'), findsOneWidget);
      expect(find.byType(RecapCompletenessIndicator), findsNWidgets(13));
      expect(find.byIcon(Icons.circle), findsNWidgets(13));

      await tester.tap(find.byType(RecapCompletenessIndicator).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('All data is available for watches in your collection.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Data Completeness'));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
    });

    testWidgets('shows amber warnings for partial collection data with incomplete alert dialog',
        (tester) async {
      await pumpBody(
        tester,
        isPro: false,
        watches: [
          _makeWatch(),
          _makeWatch(
            model: 'Partial',
            movement: null,
            category: null,
            primaryColour: null,
            year: null,
          ),
        ],
      );

      expect(tester.takeException(), isNull);
      // Free mode shows CostPerWear upgrade tile (no indicator) + Movements, Categories, Colour, ModelYear = 4 indicators
      expect(find.byType(RecapCompletenessIndicator), findsNWidgets(4));
      expect(find.byIcon(Icons.circle), findsNothing);

      await tester.tap(find.byType(RecapCompletenessIndicator).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'Collection data is incomplete; not all watches in your collection track this field.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('cycles chart types across new CollectionCharts toggles without overflow',
        (tester) async {
      await pumpBody(
        tester,
        isPro: true,
        screenSize: const Size(400, 900),
        watches: [
          _makeWatch(),
          _makeWatch(
            manufacturer: 'Seiko',
            model: 'Alpinist',
            movement: 'Mechanical - Manual',
            category: 'Field',
            primaryColour: 'Green',
            year: 2021,
            dateComplication: 'No Date',
            caseDiameter: 39.5,
            lugWidth: 18,
            lug2lug: 46.4,
            caseThickness: 13.2,
            powerReserve: 70,
            waterResistance: 200,
            caseMaterial: 'Titanium',
          ),
        ],
      );

      expect(tester.takeException(), isNull);

      Future<void> tapButton(Key key) async {
        final finder = find.byKey(key);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      // Movement: Bar -> Pie -> Donut -> RadialBar -> Bar
      for (int i = 0; i < 4; i++) {
        await tapButton(const Key('collection_movement_chart_type_button'));
      }
      // Category: Bar -> Pie -> Donut -> RadialBar -> Bar
      for (int i = 0; i < 4; i++) {
        await tapButton(const Key('collection_category_chart_type_button'));
      }
      // Model Year: Bar -> Column -> SplineArea -> Bar
      await tapButton(const Key('collection_model_year_chart_type_button'));
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
      await tapButton(const Key('collection_model_year_chart_type_button'));
      expect(find.byIcon(Icons.area_chart), findsOneWidget);
      await tapButton(const Key('collection_model_year_chart_type_button'));

      // Date Complication: Bar -> Pie -> Donut -> RadialBar -> Bar
      for (int i = 0; i < 4; i++) {
        await tapButton(const Key('collection_date_complication_chart_type_button'));
      }
      // Case Diameter: Bar -> Line -> Bar
      await tapButton(const Key('collection_case_diameter_chart_type_button'));
      await tapButton(const Key('collection_case_diameter_chart_type_button'));

      // Lug Width: Bar -> Pie -> Donut -> Bar
      for (int i = 0; i < 3; i++) {
        await tapButton(const Key('collection_lug_width_chart_type_button'));
      }
      // Water Resistance: Bar -> Pie -> Donut -> Bar
      for (int i = 0; i < 3; i++) {
        await tapButton(const Key('collection_water_resistance_chart_type_button'));
      }
      // Case Material: Bar -> Pie -> Donut -> RadialBar -> Bar
      for (int i = 0; i < 4; i++) {
        await tapButton(const Key('collection_case_material_chart_type_button'));
      }

      expect(find.byType(SfCartesianChart), findsWidgets);
    });
  });
}
