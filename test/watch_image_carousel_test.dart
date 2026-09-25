import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/watch/header/watch_image_carousel.dart';

void main() {
  testWidgets('WatchImageCarousel with CarouselView test', (WidgetTester tester) async {
    Get.put(WatchViewController());
    final watch = Watches()
      ..manufacturer = 'Rolex'
      ..model = 'Submariner'
      ..wearList = []
      ..favourite = false
      ..primaryImageIndex = 0;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: WatchImageCarousel(currentWatch: watch),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final carouselFinder = find.byType(CarouselView);
    expect(carouselFinder, findsOneWidget);

    final containers = find.descendant(of: carouselFinder, matching: find.byType(Container));
    print('Container 0 rect: ${tester.getRect(containers.at(0))}');
    print('Container 1 rect: ${tester.getRect(containers.at(1))}');
  });
}
