import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/StatsWidget.dart';

void main() {
  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({
      'appPurchased': false,
      'locale': 'en_US',
    });
    await WristCheckPreferences.init();
  });

  Future<void> pumpStatsWidget(
    WidgetTester tester, {
    required Size screenSize,
    Widget? topBanner,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = Get.put(WristCheckController());
    controller.isAppPro.value = false;
    controller.isDrawerOpen.value = false;

    final adState = AdState(Completer<InitializationStatus>().future);

    await tester.pumpWidget(
      Provider<AdState>.value(
        value: adState,
        child: GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            extendBody: true,
            appBar: AppBar(title: const Text('WristTrack')),
            body: Column(
              children: [
                if (topBanner != null) topBanner,
                Expanded(child: StatsWidget()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('StatsWidget.adSizeForScreenHeight', () {
    test('uses small AdSize.banner for small screens including iPhone SE', () {
      expect(StatsWidget.adSizeForScreenHeight(568.0), AdSize.banner);
      expect(StatsWidget.adSizeForScreenHeight(667.0), AdSize.banner);
      expect(StatsWidget.adSizeForScreenHeight(375.0), AdSize.banner);
      expect(StatsWidget.adSizeForScreenHeight(749.0), AdSize.banner);
    });

    test('uses AdSize.mediumRectangle for taller screens', () {
      expect(StatsWidget.adSizeForScreenHeight(750.0), AdSize.mediumRectangle);
      expect(StatsWidget.adSizeForScreenHeight(812.0), AdSize.mediumRectangle);
      expect(StatsWidget.adSizeForScreenHeight(852.0), AdSize.mediumRectangle);
      expect(StatsWidget.adSizeForScreenHeight(1024.0), AdSize.mediumRectangle);
    });
  });

  group('StatsWidget responsive ad & button layout', () {
    testWidgets('uses 50dp banner ad placeholder and avoids button overlap on iPhone SE (375x667)',
        (tester) async {
      await pumpStatsWidget(
        tester,
        screenSize: const Size(375, 667),
      );

      expect(tester.takeException(), isNull);

      final adFinder = find.byKey(const Key('stats_ad_placeholder'));
      expect(adFinder, findsOneWidget);
      final adRect = tester.getRect(adFinder);
      expect(adRect.height, AdSize.banner.height.toDouble());

      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(3));
      for (int i = 0; i < 3; i++) {
        final buttonRect = tester.getRect(buttons.at(i));
        expect(buttonRect.bottom, lessThanOrEqualTo(adRect.top));
      }
    });

    testWidgets('avoids overlap on iPhone SE (375x667) even with a 136dp top notification banner',
        (tester) async {
      await pumpStatsWidget(
        tester,
        screenSize: const Size(375, 667),
        topBanner: const SizedBox(height: 136, child: Placeholder()),
      );

      expect(tester.takeException(), isNull);

      final adRect = tester.getRect(find.byKey(const Key('stats_ad_placeholder')));
      expect(adRect.height, AdSize.banner.height.toDouble());

      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(3));
      for (int i = 0; i < 3; i++) {
        final buttonRect = tester.getRect(buttons.at(i));
        expect(buttonRect.bottom, lessThanOrEqualTo(adRect.top));
      }
    });

    testWidgets('uses 50dp banner ad and avoids overlap on iPhone SE 1st gen (320x568)',
        (tester) async {
      await pumpStatsWidget(
        tester,
        screenSize: const Size(320, 568),
      );

      expect(tester.takeException(), isNull);

      final adRect = tester.getRect(find.byKey(const Key('stats_ad_placeholder')));
      expect(adRect.height, AdSize.banner.height.toDouble());

      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(3));
      for (int i = 0; i < 3; i++) {
        final buttonRect = tester.getRect(buttons.at(i));
        expect(buttonRect.bottom, lessThanOrEqualTo(adRect.top));
      }
    });

    testWidgets('does not overflow or overlap ad in landscape on small screens (667x375)',
        (tester) async {
      await pumpStatsWidget(
        tester,
        screenSize: const Size(667, 375),
      );

      expect(tester.takeException(), isNull);

      final adRect = tester.getRect(find.byKey(const Key('stats_ad_placeholder')));
      expect(adRect.height, AdSize.banner.height.toDouble());
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('keeps 250dp mediumRectangle ad on larger phones (393x852)', (tester) async {
      await pumpStatsWidget(
        tester,
        screenSize: const Size(393, 852),
      );

      expect(tester.takeException(), isNull);

      final adRect = tester.getRect(find.byKey(const Key('stats_ad_placeholder')));
      expect(adRect.height, AdSize.mediumRectangle.height.toDouble());

      final buttons = find.byType(ElevatedButton);
      expect(buttons, findsNWidgets(3));
      for (int i = 0; i < 3; i++) {
        final buttonRect = tester.getRect(buttons.at(i));
        expect(buttonRect.bottom, lessThanOrEqualTo(adRect.top));
      }
    });
  });
}
