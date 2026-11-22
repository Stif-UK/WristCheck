import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/navbar_alignment.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/widgets/wrist_track_bottom_nav_bar.dart';

void main() {
  Future<void> pumpNavBar(
    WidgetTester tester, {
    required Size screenSize,
    required NavBarAlignment alignment,
    int currentIndex = 0,
    ValueChanged<int>? onTap,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          extendBody: true,
          body: const SizedBox.expand(),
          bottomNavigationBar: WristTrackBottomNavBar(
            currentIndex: currentIndex,
            navBarAlignment: alignment,
            onTap: onTap ?? (_) {},
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Collection'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Time'),
              BottomNavigationBarItem(icon: Icon(Icons.chevron_right), label: 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Rect getPillRect(WidgetTester tester) {
    final pillFinder = find
        .ancestor(
          of: find.byType(BottomNavigationBar),
          matching: find.byType(Container),
        )
        .first;
    return tester.getRect(pillFinder);
  }

  group('WristTrackBottomNavBar', () {
    testWidgets('spans full available width on phone screens (< 600dp)', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(400, 800),
        alignment: NavBarAlignment.right,
      );

      final rect = getPillRect(tester);
      // 400 - 12 left padding - 12 right padding = 376
      expect(rect.width, 376.0);
      expect(rect.left, 12.0);
      expect(rect.right, 388.0);
    });

    testWidgets('is shortened and right-aligned on large screens (>= 600dp)', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(1000, 800),
        alignment: NavBarAlignment.right,
      );

      final rect = getPillRect(tester);
      expect(rect.width, WristTrackBottomNavBar.largeScreenMaxWidth);
      expect(rect.right, 1000.0 - 12.0);
    });

    testWidgets('is shortened and left-aligned on large screens when configured left', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(1000, 800),
        alignment: NavBarAlignment.left,
      );

      final rect = getPillRect(tester);
      expect(rect.width, WristTrackBottomNavBar.largeScreenMaxWidth);
      expect(rect.left, 12.0);
    });

    testWidgets('is shortened to sensible width and centered when configured center', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(1000, 800),
        alignment: NavBarAlignment.center,
      );

      final rect = getPillRect(tester);
      expect(rect.width, WristTrackBottomNavBar.largeScreenMaxWidth);
      expect(rect.center.dx, 500.0);
    });

    testWidgets('forwards tab taps with expected index', (tester) async {
      int tappedIndex = -1;
      await pumpNavBar(
        tester,
        screenSize: const Size(1000, 800),
        alignment: NavBarAlignment.right,
        onTap: (index) => tappedIndex = index,
      );

      await tester.tap(find.text('Stats'));
      await tester.pump();
      expect(tappedIndex, 1);
    });
  });

  group('NavBarAlignment localization & preferences', () {
    testWidgets('NavBarAlignment returns expected localized labels', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(1000, 800),
        alignment: NavBarAlignment.right,
      );

      final context = tester.element(find.byType(WristTrackBottomNavBar));
      expect(NavBarAlignment.left.toLocalizedString(context), 'Left');
      expect(NavBarAlignment.center.toLocalizedString(context), 'Center');
      expect(NavBarAlignment.right.toLocalizedString(context), 'Right');
    });

    test('defaults to right and persists updates in WristCheckPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      await WristCheckPreferences.init();

      expect(WristCheckPreferences.getNavBarAlignment(), NavBarAlignment.right);

      await WristCheckPreferences.setNavBarAlignment(NavBarAlignment.left);
      expect(WristCheckPreferences.getNavBarAlignment(), NavBarAlignment.left);

      await WristCheckPreferences.setNavBarAlignment(NavBarAlignment.center);
      expect(WristCheckPreferences.getNavBarAlignment(), NavBarAlignment.center);

      await WristCheckPreferences.setNavBarAlignment(NavBarAlignment.right);
      expect(WristCheckPreferences.getNavBarAlignment(), NavBarAlignment.right);
    });
  });
}
