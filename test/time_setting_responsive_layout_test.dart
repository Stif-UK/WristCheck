import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/time_view_enum.dart';
import 'package:wristcheck/model/moonphase_methods.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/time/gmt.dart';
import 'package:wristcheck/ui/time/moon_phase.dart';
import 'package:wristcheck/ui/time/time_setting.dart';

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    await WristCheckPreferences.init();
  });

  Future<void> pumpWidgetWithSize(
    WidgetTester tester, {
    required Size screenSize,
    required Widget child,
  }) async {
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

  group('MoonPhaseWidget responsive behavior', () {
    testWidgets('uses ExpansionTile on phone screens (< 600dp)', (tester) async {
      Get.put(TimeController());

      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(400, 800),
        child: MoonPhaseWidget(),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(ExpansionTile), findsOneWidget);
    });

    testWidgets('shows all upcoming phases without ExpansionTile centered under moon on tablet',
        (tester) async {
      final timeController = Get.put(TimeController());
      timeController.currentDateTime.value = DateTime(2026, 11, 22, 12, 0);

      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(800, 1200),
        child: MoonPhaseWidget(),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(ExpansionTile), findsNothing);

      final context = tester.element(find.byType(MoonPhaseWidget));
      final l10n = AppLocalizations.of(context)!;
      final upcomingFinder = find.text(l10n.upcomingPhases);
      expect(upcomingFinder, findsOneWidget);

      final upcomingPhases = MoonPhaseMethods.getUpcomingMoonPhases(
        timeController.currentDateTime.value,
        context,
      );
      for (final phase in upcomingPhases) {
        expect(find.text(phase.title), findsOneWidget);
      }

      final mainMoonFinder = find.byWidgetPredicate(
        (widget) => widget is CustomMoonWidget && widget.size == 150,
      );
      final mainMoonRect = tester.getRect(mainMoonFinder);
      final upcomingHeadingRect = tester.getRect(upcomingFinder);

      expect(upcomingHeadingRect.top, greaterThan(mainMoonRect.bottom));
      expect((upcomingHeadingRect.center.dx - mainMoonRect.center.dx).abs(), lessThan(2.0));
    });
  });

  group('ResponsiveTimeProContent', () {
    testWidgets('hides pro tools when user is not pro', (tester) async {
      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(1000, 800),
        child: ResponsiveTimeProContent(
          isPro: false,
          selectedView: TimeViewEnum.moonphase,
          moonPhaseBuilder: (_) => const SizedBox(key: Key('moon'), height: 200),
          gmtBuilder: (_) => const SizedBox(key: Key('gmt'), height: 200),
        ),
      );

      expect(find.byKey(const Key('moon')), findsNothing);
      expect(find.byKey(const Key('gmt')), findsNothing);
    });

    testWidgets('shows only selected view without Earth header on phone (< 600dp)',
        (tester) async {
      bool expandedArg = true;
      bool showEarthArg = true;

      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(400, 800),
        child: ResponsiveTimeProContent(
          isPro: true,
          selectedView: TimeViewEnum.moonphase,
          moonPhaseBuilder: (expand) {
            expandedArg = expand;
            return const SizedBox(key: Key('moon'), height: 200);
          },
          gmtBuilder: (showEarth) {
            showEarthArg = showEarth;
            return const SizedBox(key: Key('gmt'), height: 200);
          },
        ),
      );

      expect(find.byKey(const Key('moon')), findsOneWidget);
      expect(find.byKey(const Key('gmt')), findsNothing);
      expect(expandedArg, isFalse);

      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(400, 800),
        child: ResponsiveTimeProContent(
          isPro: true,
          selectedView: TimeViewEnum.gmt,
          moonPhaseBuilder: (_) => const SizedBox(key: Key('moon'), height: 200),
          gmtBuilder: (showEarth) {
            showEarthArg = showEarth;
            return const SizedBox(key: Key('gmt'), height: 200);
          },
        ),
      );

      expect(find.byKey(const Key('moon')), findsNothing);
      expect(find.byKey(const Key('gmt')), findsOneWidget);
      expect(showEarthArg, isFalse);
    });

    testWidgets('shows moonphase and GMT with mirrored 150dp Earth globe on tablet (>= 600dp)',
        (tester) async {
      final timeController = Get.put(TimeController());
      timeController.currentDateTime.value = DateTime(2026, 11, 22, 12, 0);

      bool expandedArg = false;
      bool showEarthArg = false;

      await pumpWidgetWithSize(
        tester,
        screenSize: const Size(1000, 1200),
        child: ResponsiveTimeProContent(
          isPro: true,
          selectedView: TimeViewEnum.moonphase,
          moonPhaseBuilder: (expand) {
            expandedArg = expand;
            return MoonPhaseWidget(expandUpcomingPhases: expand);
          },
          gmtBuilder: (showEarth) {
            showEarthArg = showEarth;
            return Column(
              children: [
                if (showEarth) const TabletEarthHeader(),
                const SizedBox(key: Key('gmt_list'), height: 200),
              ],
            );
          },
        ),
      );

      expect(tester.takeException(), isNull);
      expect(expandedArg, isTrue);
      expect(showEarthArg, isTrue);

      final mainMoonRect = tester.getRect(
        find.byWidgetPredicate((w) => w is CustomMoonWidget && w.size == 150),
      );
      final earthRect = tester.getRect(find.byType(EarthGlobeWidget));

      expect(earthRect.width, 150.0);
      expect(earthRect.height, 150.0);
      expect(earthRect.top, mainMoonRect.top);
      expect(mainMoonRect.left, lessThan(earthRect.left));
    });
  });
}
