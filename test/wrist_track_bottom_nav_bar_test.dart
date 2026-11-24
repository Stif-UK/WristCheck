import 'package:flutter/foundation.dart';
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

    testWidgets('isLargeScreen returns false below 600dp and true at/above 600dp', (tester) async {
      await pumpNavBar(
        tester,
        screenSize: const Size(599, 800),
        alignment: NavBarAlignment.right,
      );
      expect(
        WristTrackBottomNavBar.isLargeScreen(tester.element(find.byType(WristTrackBottomNavBar))),
        isFalse,
      );

      await pumpNavBar(
        tester,
        screenSize: const Size(600, 800),
        alignment: NavBarAlignment.right,
      );
      expect(
        WristTrackBottomNavBar.isLargeScreen(tester.element(find.byType(WristTrackBottomNavBar))),
        isTrue,
      );
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

  group('isRightCutoutPortraitDevice & WristTrackRightNavRail', () {
    Future<bool> checkIsRightCutoutPortrait(
      WidgetTester tester, {
      required Size size,
      required EdgeInsets viewPadding,
      required TargetPlatform platform,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      debugDefaultTargetPlatformOverride = platform;
      try {
        late bool result;
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                size: size,
                padding: viewPadding,
                viewPadding: viewPadding,
              ),
              child: child!,
            ),
            home: Builder(
              builder: (context) {
                result = WristTrackBottomNavBar.isRightCutoutPortraitDevice(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        return result;
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    }

    testWidgets('returns true only for iOS portrait < 600dp with right viewPadding', (tester) async {
      expect(
        await checkIsRightCutoutPortrait(
          tester,
          size: const Size(420, 720),
          viewPadding: const EdgeInsets.only(top: 44, right: 60, bottom: 20),
          platform: TargetPlatform.iOS,
        ),
        isTrue,
      );

      expect(
        await checkIsRightCutoutPortrait(
          tester,
          size: const Size(420, 720),
          viewPadding: const EdgeInsets.only(top: 44, bottom: 20),
          platform: TargetPlatform.iOS,
        ),
        isFalse,
      );

      expect(
        await checkIsRightCutoutPortrait(
          tester,
          size: const Size(800, 400),
          viewPadding: const EdgeInsets.only(right: 44, bottom: 20),
          platform: TargetPlatform.iOS,
        ),
        isFalse,
      );

      expect(
        await checkIsRightCutoutPortrait(
          tester,
          size: const Size(640, 800),
          viewPadding: const EdgeInsets.only(top: 24, right: 44, bottom: 20),
          platform: TargetPlatform.iOS,
        ),
        isFalse,
      );

      expect(
        await checkIsRightCutoutPortrait(
          tester,
          size: const Size(420, 720),
          viewPadding: const EdgeInsets.only(top: 44, right: 60, bottom: 20),
          platform: TargetPlatform.android,
        ),
        isFalse,
      );
    });

    testWidgets('WristTrackRightNavRail fills forced right space and forwards taps', (tester) async {
      tester.view.physicalSize = const Size(420, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      int tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: const Size(420, 720),
              padding: const EdgeInsets.only(top: 44, right: 68, bottom: 20),
              viewPadding: const EdgeInsets.only(top: 44, right: 68, bottom: 20),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  right: WristTrackRightNavRail.outerRightMargin,
                  bottom: 20,
                  child: WristTrackRightNavRail(
                    currentIndex: 0,
                    onTap: (index) => tappedIndex = index,
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Collection'),
                      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
                      BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
                      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Time'),
                      BottomNavigationBarItem(icon: Icon(Icons.chevron_right), label: 'More'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final railContext = tester.element(find.byType(WristTrackRightNavRail));
      expect(WristTrackRightNavRail.railWidthForContext(railContext), 56.0);
      expect(WristTrackRightNavRail.reservedContentRightWidth(railContext), 68.0);

      final railRect = tester.getRect(find.byType(WristTrackRightNavRail));
      expect(railRect.right, 420.0 - WristTrackRightNavRail.outerRightMargin);
      expect(railRect.width, 56.0);
      expect(railRect.top, greaterThan(300.0));

      await tester.tap(find.text('Calendar'));
      await tester.pump();
      expect(tappedIndex, 2);
    });

    testWidgets('WristTrackRightRailBody insets child, positions rail, and keeps FAB clear of rail', (tester) async {
      tester.view.physicalSize = const Size(420, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: const Size(420, 720),
              padding: const EdgeInsets.only(top: 44, right: 68, bottom: 20),
              viewPadding: const EdgeInsets.only(top: 44, right: 68, bottom: 20),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: WristTrackRightRailBody(
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              rightRail: WristTrackRightNavRail(
                currentIndex: 0,
                onTap: (_) {},
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Collection'),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
                  BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
                ],
              ),
              child: const SizedBox.expand(key: ValueKey('body_content')),
            ),
          ),
        ),
      );

      final contentRect = tester.getRect(find.byKey(const ValueKey('body_content')));
      final railRect = tester.getRect(find.byType(WristTrackRightNavRail));
      final fabRect = tester.getRect(find.byType(FloatingActionButton));

      expect(contentRect.right, 420.0 - 68.0);
      expect(railRect.right, 420.0 - WristTrackRightNavRail.outerRightMargin);
      expect(fabRect.right, lessThanOrEqualTo(contentRect.right));
      expect(fabRect.right, lessThan(railRect.left));
    });
  });
}
