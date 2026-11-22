import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  test('WatchViewController initializes isDirty to false and updates it', () {
    final controller = WatchViewController();
    expect(controller.isDirty.value, isFalse);

    controller.updateIsDirty(true);
    expect(controller.isDirty.value, isTrue);

    controller.updateIsDirty(false);
    expect(controller.isDirty.value, isFalse);
  });

  testWidgets('iOS swipe-back gesture works when isDirty is false and blocks when isDirty is true', (WidgetTester tester) async {
    final controller = Get.put(WatchViewController());
    bool invokedBlockedPop = false;

    await tester.pumpWidget(
      GetMaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => Obx(() {
                    final isDirty = controller.isDirty.value;
                    final overrideBackNav = controller.overrideBackNav.value;
                    return PopScope(
                      canPop: !isDirty || overrideBackNav,
                      onPopInvokedWithResult: (bool didPop, dynamic result) {
                        if (!didPop) {
                          invokedBlockedPop = true;
                        }
                      },
                      child: const Scaffold(
                        body: Center(child: Text('WatchView')),
                      ),
                    );
                  }));
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    // Navigate to second page
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('WatchView'), findsOneWidget);

    // Mark dirty: iOS edge swipe-back should be disabled
    controller.updateIsDirty(true);
    await tester.pump();
    await tester.flingFrom(const Offset(5, 300), const Offset(500, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('WatchView'), findsOneWidget);

    // Programmatic maybePop should trigger onPopInvokedWithResult without popping
    await Navigator.of(tester.element(find.text('WatchView'))).maybePop();
    await tester.pumpAndSettle();
    expect(invokedBlockedPop, isTrue);
    expect(find.text('WatchView'), findsOneWidget);

    // Clear dirty: iOS edge swipe-back should succeed
    controller.updateIsDirty(false);
    await tester.pump();
    await tester.flingFrom(const Offset(5, 300), const Offset(500, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('WatchView'), findsNothing);
    expect(find.text('Open'), findsOneWidget);
  });
}
