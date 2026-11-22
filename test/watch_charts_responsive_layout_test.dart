import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/ui/charts/watch_charts/watch_charts_body.dart';

void main() {
  Future<void> pumpChartsLayout(WidgetTester tester, Size screenSize) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ResponsiveWatchChartsLayout(
              monthSection: Container(key: const Key('month'), height: 200),
              daySection: Container(key: const Key('day'), height: 200),
              yearSection: Container(key: const Key('year'), height: 200),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ResponsiveWatchChartsLayout', () {
    testWidgets('uses full width vertical column on portrait phone', (tester) async {
      await pumpChartsLayout(tester, const Size(400, 800));

      final monthRect = tester.getRect(find.byKey(const Key('month')));
      final dayRect = tester.getRect(find.byKey(const Key('day')));
      final yearRect = tester.getRect(find.byKey(const Key('year')));

      expect(monthRect.width, 400.0);
      expect(monthRect.top, lessThan(dayRect.top));
      expect(dayRect.top, lessThan(yearRect.top));
    });

    testWidgets('constrains and centers vertical column on portrait tablet', (tester) async {
      await pumpChartsLayout(tester, const Size(1000, 1300));

      final monthRect = tester.getRect(find.byKey(const Key('month')));
      final dayRect = tester.getRect(find.byKey(const Key('day')));
      final yearRect = tester.getRect(find.byKey(const Key('year')));

      expect(monthRect.width, 720.0);
      expect(monthRect.center.dx, 500.0);
      expect(dayRect.width, 720.0);
      expect(yearRect.width, 720.0);
      expect(monthRect.top, lessThan(dayRect.top));
      expect(dayRect.top, lessThan(yearRect.top));
    });

    testWidgets('splits into two columns with centered third chart on landscape tablet',
        (tester) async {
      await pumpChartsLayout(tester, const Size(1200, 800));

      final monthRect = tester.getRect(find.byKey(const Key('month')));
      final dayRect = tester.getRect(find.byKey(const Key('day')));
      final yearRect = tester.getRect(find.byKey(const Key('year')));

      expect(monthRect.top, dayRect.top);
      expect(monthRect.left, lessThan(dayRect.left));
      expect(monthRect.width, 588.0);
      expect(dayRect.width, 588.0);

      expect(yearRect.top, greaterThan(monthRect.bottom));
      expect(yearRect.width, 600.0);
      expect(yearRect.center.dx, 600.0);
    });

    testWidgets('stays single column on landscape phone below 900dp', (tester) async {
      await pumpChartsLayout(tester, const Size(800, 400));

      final monthRect = tester.getRect(find.byKey(const Key('month')));
      final dayRect = tester.getRect(find.byKey(const Key('day')));
      final yearRect = tester.getRect(find.byKey(const Key('year')));

      expect(monthRect.width, 720.0);
      expect(monthRect.top, lessThan(dayRect.top));
      expect(dayRect.top, lessThan(yearRect.top));
    });
  });
}
