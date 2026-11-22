import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/header/watch_image_gallery.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_home.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/worn_watch_card.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/images_util.dart';

void main() {
  setUp(() {
    Get.reset();
    ImagesUtil.appDocsPath = '/tmp';
  });

  tearDown(() {
    ImagesUtil.appDocsPath = null;
    ImagesUtil.clearImageCache();
  });

  Future<void> pumpWithSize(
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
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ResponsiveWristRecapBody', () {
    testWidgets('stacks cards vertically below carousel on phone (< 600dp)', (tester) async {
      await pumpWithSize(
        tester,
        screenSize: const Size(400, 800),
        child: ResponsiveWristRecapBody(
          watchesWornCarousel: Container(key: const Key('carousel'), height: 250),
          cards: [
            Container(key: const Key('card1'), height: 150),
            Container(key: const Key('card2'), height: 150),
            Container(key: const Key('card3'), height: 150),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      final carousel = tester.getRect(find.byKey(const Key('carousel')));
      final c1 = tester.getRect(find.byKey(const Key('card1')));
      final c2 = tester.getRect(find.byKey(const Key('card2')));
      final c3 = tester.getRect(find.byKey(const Key('card3')));

      expect(carousel.width, 400.0);
      expect(carousel.bottom, lessThanOrEqualTo(c1.top));
      expect(c1.top, lessThan(c2.top));
      expect(c2.top, lessThan(c3.top));
    });

    testWidgets('retains full-width carousel at top and uses 2-column grid on tablet (>= 600dp)',
        (tester) async {
      await pumpWithSize(
        tester,
        screenSize: const Size(1000, 1200),
        child: ResponsiveWristRecapBody(
          watchesWornCarousel: Container(key: const Key('carousel'), height: 250),
          cards: [
            Container(key: const Key('card1'), height: 150),
            Container(key: const Key('card2'), height: 150),
            Container(key: const Key('card3'), height: 150),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      final carousel = tester.getRect(find.byKey(const Key('carousel')));
      final c1 = tester.getRect(find.byKey(const Key('card1')));
      final c2 = tester.getRect(find.byKey(const Key('card2')));
      final c3 = tester.getRect(find.byKey(const Key('card3')));

      expect(carousel.width, 1000.0);
      expect(carousel.bottom, lessThanOrEqualTo(c1.top));
      expect(c1.top, c2.top);
      expect(c1.left, lessThan(c2.left));
      expect(c3.top, greaterThanOrEqualTo(c1.bottom));
    });
  });

  group('WornWatchCard tap navigation', () {
    for (final screenSize in [const Size(400, 800), const Size(1000, 800)]) {
      testWidgets('tapping WornWatchCard opens WatchImageGallery on ${screenSize.width}x${screenSize.height}',
          (tester) async {
        final watch = Watches()
          ..manufacturer = 'Omega'
          ..model = 'Speedmaster'
          ..wearList = [DateTime(2026, 11, 1)]
          ..favourite = false
          ..frontImagePath = ''
          ..backImagePath = ''
          ..lumeImagePath = ''
          ..primaryImageIndex = 1;

        final wornWatch = WornWatchesClass(watch, 3, '50.0');

        await pumpWithSize(
          tester,
          screenSize: screenSize,
          child: WornWatchCard(wornWatch: wornWatch),
        );

        await tester.tap(find.byType(WornWatchCard));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(WatchImageGallery), findsOneWidget);

        final gallery = tester.widget<WatchImageGallery>(find.byType(WatchImageGallery));
        expect(gallery.watch, watch);
        expect(gallery.index, 1);

        final watchViewController = Get.find<WatchViewController>();
        expect(watchViewController.imageList.length, 3);
      });
    }
  });
}
