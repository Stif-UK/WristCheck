import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/header/watch_image_carousel.dart';
import 'package:wristcheck/ui/watch/header/watch_image_gallery.dart';
import 'package:wristcheck/ui/widgets/images/image_card_widget.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  Future<void> pumpCarousel(WidgetTester tester, Size screenSize) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(WatchViewController());

    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: WatchImageCarousel(currentWatch: null),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('WatchImageCarousel sizing', () {
    testWidgets('uses 80% of width for height in portrait on phone', (tester) async {
      await pumpCarousel(tester, const Size(400, 800));

      final carouselRect = tester.getRect(find.byType(WatchImageCarousel));
      expect(carouselRect.height, 320.0);
      expect(carouselRect.width, 380.0);
    });

    testWidgets('uses 80% of width for height in portrait on tablet', (tester) async {
      await pumpCarousel(tester, const Size(800, 1200));

      final carouselRect = tester.getRect(find.byType(WatchImageCarousel));
      expect(carouselRect.height, 640.0);
      expect(carouselRect.width, 760.0);
    });

    testWidgets('caps height at 50% of screen height in landscape on tablet', (tester) async {
      await pumpCarousel(tester, const Size(1200, 800));

      final carouselRect = tester.getRect(find.byType(WatchImageCarousel));
      expect(carouselRect.height, 400.0);
      expect(carouselRect.height, lessThanOrEqualTo(800.0 * 0.5));

      final carouselView = tester.widget<CarouselView>(find.byType(CarouselView));
      expect(carouselView.itemExtent, 400.0);
    });

    testWidgets('caps width to fit cards neatly on very wide landscape screens', (tester) async {
      await pumpCarousel(tester, const Size(1400, 700));

      final carouselRect = tester.getRect(find.byType(WatchImageCarousel));
      expect(carouselRect.height, 350.0);
      expect(carouselRect.width, 350.0 * 3);
    });
  });

  group('WatchImageGallery sizing', () {
    testWidgets('does not overflow on landscape tablet', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = Get.put(WatchViewController());
      controller.imageList.assignAll(const [
        ImageCardWidget(image: null),
        ImageCardWidget(image: null),
        ImageCardWidget(image: null),
      ]);

      final watch = Watches()
        ..manufacturer = 'Rolex'
        ..model = 'Submariner'
        ..wearList = []
        ..favourite = false;

      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: WatchImageGallery(watch: watch, index: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final carouselRect = tester.getRect(find.byType(CarouselView));
      expect(carouselRect.height, lessThanOrEqualTo(800.0 * 0.65));
    });
  });
}
