import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/ui/collection_stats/collection_charts.dart';

void main() {
  Future<void> pumpLayout(
    WidgetTester tester, {
    required Size screenSize,
    required List<Widget> sections,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ResponsiveCollectionChartsLayout(sections: sections),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ResponsiveCollectionChartsLayout', () {
    testWidgets('uses single column with dividers on small screens (< 600dp)',
        (tester) async {
      await pumpLayout(
        tester,
        screenSize: const Size(400, 800),
        sections: [
          Container(key: const Key('s1'), height: 150),
          Container(key: const Key('s2'), height: 150),
          Container(key: const Key('s3'), height: 150),
        ],
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Divider), findsNWidgets(2));
      expect(find.byType(Card), findsNothing);

      final s1 = tester.getRect(find.byKey(const Key('s1')));
      final s2 = tester.getRect(find.byKey(const Key('s2')));
      final s3 = tester.getRect(find.byKey(const Key('s3')));

      expect(s1.bottom, lessThan(s2.top));
      expect(s2.bottom, lessThan(s3.top));
    });

    testWidgets('splits into two packed card columns on tablet portrait (>= 600dp)',
        (tester) async {
      await pumpLayout(
        tester,
        screenSize: const Size(750, 1000),
        sections: [
          Container(key: const Key('s1'), height: 400),
          Container(key: const Key('s2'), height: 150),
          Container(key: const Key('s3'), height: 150),
        ],
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Card), findsNWidgets(3));
      expect(find.byType(Divider), findsNothing);

      final s1 = tester.getRect(find.byKey(const Key('s1')));
      final s2 = tester.getRect(find.byKey(const Key('s2')));
      final s3 = tester.getRect(find.byKey(const Key('s3')));

      expect(s1.top, s2.top);
      expect(s1.left, lessThan(s2.left));
      // Masonry packing places s3 in shorter column B directly below s2
      expect(s3.left, s2.left);
      expect(s3.top, greaterThan(s2.bottom));
      expect(s3.bottom, lessThan(s1.bottom));
    });

    testWidgets('constrains maxWidth on large landscape screens (>= 600dp)',
        (tester) async {
      await pumpLayout(
        tester,
        screenSize: const Size(1400, 900),
        sections: [
          Container(key: const Key('s1'), height: 200),
          Container(key: const Key('s2'), height: 200),
        ],
      );

      expect(tester.takeException(), isNull);
      final cardRects =
          tester.widgetList<Card>(find.byType(Card)).map((_) => null).toList();
      expect(cardRects.length, 2);

      final s1 = tester.getRect(find.byKey(const Key('s1')));
      final s2 = tester.getRect(find.byKey(const Key('s2')));
      expect(s1.top, s2.top);
      expect(s2.right - s1.left, lessThanOrEqualTo(1200.0));
    });
  });
}
