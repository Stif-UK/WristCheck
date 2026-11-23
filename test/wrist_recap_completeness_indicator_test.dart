import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_category_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/category_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/colour_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/status_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_completeness_indicator.dart';
import 'package:wristcheck/util/helper_classes.dart';

Watches _makeWatch({
  String? category,
  String? status = 'In Collection',
  String? primaryColour,
  String? secondaryColour,
}) {
  return Watches()
    ..manufacturer = 'Omega'
    ..model = 'Seamaster'
    ..wearList = []
    ..favourite = false
    ..frontImagePath = ''
    ..backImagePath = ''
    ..lumeImagePath = ''
    ..category = category
    ..status = status
    ..primaryColour = primaryColour
    ..secondaryColour = secondaryColour;
}

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  group('WristRecapController completeness helpers', () {
    test('areColoursComplete returns false when some worn watches lack colour data', () {
      final partial = [
        WornWatchesClass(_makeWatch(primaryColour: 'Blue'), 3),
        WornWatchesClass(_makeWatch(primaryColour: null, secondaryColour: ''), 2),
      ];
      expect(WristRecapController.areColoursComplete(partial), isFalse);

      final secondaryOnlyCountsAsTracked = [
        WornWatchesClass(_makeWatch(primaryColour: 'Blue'), 3),
        WornWatchesClass(_makeWatch(primaryColour: null, secondaryColour: 'Gold'), 2),
      ];
      expect(WristRecapController.areColoursComplete(secondaryOnlyCountsAsTracked), isTrue);
    });

    test('areCategoriesComplete detects null, empty, Not Selected, and Not Entered', () {
      expect(
        WristRecapController.areCategoriesComplete([
          WornWatchesClass(_makeWatch(category: 'Diver'), 2),
          WornWatchesClass(_makeWatch(category: 'Not Selected'), 1),
        ]),
        isFalse,
      );
      expect(
        WristRecapController.areCategoriesComplete([
          WornWatchesClass(_makeWatch(category: 'Diver'), 2),
          WornWatchesClass(_makeWatch(category: null), 1),
        ]),
        isFalse,
      );
      expect(
        WristRecapController.areCategoriesComplete([
          WornWatchesClass(_makeWatch(category: 'Diver'), 2),
          WornWatchesClass(_makeWatch(category: 'Dress'), 1),
        ]),
        isTrue,
      );
    });

    test('isStatusComplete detects missing status and returns true when populated', () {
      expect(
        WristRecapController.isStatusComplete([
          WornWatchesClass(_makeWatch(status: 'In Collection'), 2),
          WornWatchesClass(_makeWatch(status: ''), 1),
        ]),
        isFalse,
      );
      expect(
        WristRecapController.isStatusComplete([
          WornWatchesClass(_makeWatch(status: 'In Collection'), 2),
          WornWatchesClass(_makeWatch(status: 'Sold'), 1),
        ]),
        isTrue,
      );
    });
  });

  group('RecapCompletenessIndicator widget', () {
    Future<void> pumpIndicator(
      WidgetTester tester, {
      required bool isComplete,
      VoidCallback? onNavigateToDataCompleteness,
    }) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: RecapCompletenessIndicator(
                isComplete: isComplete,
                onNavigateToDataCompleteness: onNavigateToDataCompleteness,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows amber triangle-exclamation, tooltip on long press, and alert dialog on tap',
        (tester) async {
      bool navigated = false;
      await pumpIndicator(
        tester,
        isComplete: false,
        onNavigateToDataCompleteness: () => navigated = true,
      );

      final faIcon = tester.widget<FaIcon>(find.byType(FaIcon));
      expect(faIcon.icon, FontAwesomeIcons.triangleExclamation.data);
      expect(faIcon.color, Colors.amber);

      // Long press triggers tooltip
      await tester.longPress(find.byType(RecapCompletenessIndicator));
      await tester.pump();
      expect(
        find.text('Data for this period is incomplete; not all worn watches track this field.'),
        findsOneWidget,
      );
      Tooltip.dismissAllToolTips();
      await tester.pumpAndSettle();

      // Tap opens alert dialog with icon, explanation, and link to Data Completeness
      await tester.tap(find.byType(RecapCompletenessIndicator));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Incomplete Data'), findsOneWidget);
      expect(
        find.text('Data for this period is incomplete; not all worn watches track this field.'),
        findsOneWidget,
      );
      expect(find.text('Data Completeness'), findsOneWidget);

      await tester.tap(find.text('Data Completeness'));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('shows green circle, tooltip on long press, and alert dialog on tap',
        (tester) async {
      await pumpIndicator(tester, isComplete: true);

      final circleIcon = tester.widget<Icon>(find.byIcon(Icons.circle));
      expect(circleIcon.color, Colors.green);

      // Long press triggers tooltip
      await tester.longPress(find.byType(RecapCompletenessIndicator));
      await tester.pump();
      expect(
        find.text('All data is available for worn watches in this period.'),
        findsOneWidget,
      );
      Tooltip.dismissAllToolTips();
      await tester.pumpAndSettle();

      // Tap opens alert dialog and OK closes it
      await tester.tap(find.byType(RecapCompletenessIndicator));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Complete Data'), findsOneWidget);
      expect(
        find.text('All data is available for worn watches in this period.'),
        findsOneWidget,
      );
      expect(find.text('Data Completeness'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Non-mandatory WristRecap charts completeness prefix', () {
    Future<void> pumpCharts(
      WidgetTester tester, {
      required bool complete,
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

      final controller = Get.put(WristRecapController());
      controller.selectedRecapOption(WristRecapEnums.annually);
      controller.coloursWorn([ColourData('Blue', 3, 1)]);
      controller.coloursComplete(complete);
      controller.categoriesWorn([
        CategoriesWornClass('Diver', 3, '75.0 %'),
        CategoriesWornClass('Unknown', 1, '25.0 %'),
      ]);
      controller.categoriesComplete(complete);
      controller.statusWorn([
        StatusWornClass('In Collection', 3, '75.0 %'),
        StatusWornClass('Sold', 1, '25.0 %'),
      ]);
      controller.statusComplete(complete);
      controller.topCategoryMonthly([
        TopCategoryMonthlyClass(1, 'Diver', 3),
      ]);

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
              child: Column(
                children: [
                  const WristRecapColourChart(),
                  CategoryChart(),
                  StatusWearChart(),
                  const TopCategoryMonthly(),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows amber warning prefix on all 4 non-mandatory charts when incomplete',
        (tester) async {
      await pumpCharts(tester, complete: false);

      expect(tester.takeException(), isNull);
      expect(find.byType(RecapCompletenessIndicator), findsNWidgets(4));
      final indicators = tester
          .widgetList<RecapCompletenessIndicator>(find.byType(RecapCompletenessIndicator))
          .toList();
      expect(indicators.every((i) => !i.isComplete), isTrue);
      expect(find.byIcon(Icons.circle), findsNothing);
    });

    testWidgets('shows green circle prefix on all 4 non-mandatory charts when complete',
        (tester) async {
      await pumpCharts(tester, complete: true);

      expect(tester.takeException(), isNull);
      expect(find.byType(RecapCompletenessIndicator), findsNWidgets(4));
      expect(find.byIcon(Icons.circle), findsNWidgets(4));
    });
  });
}
