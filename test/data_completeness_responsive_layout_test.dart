import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/ui/appdata/data_completeness.dart';

void main() {
  Future<void> pumpCompletenessList(
    WidgetTester tester, {
    required Size screenSize,
    required List<Widget> standardTiles,
    required List<Widget> proTiles,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveDataCompletenessList(
            standardTiles: standardTiles,
            proTiles: proTiles,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  List<Widget> buildTiles(String prefix, int count) {
    return List.generate(
      count,
      (i) => ListTile(
        leading: const SizedBox(width: 36, height: 36, child: CircularProgressIndicator(value: 0.5)),
        title: Text('$prefix ${i + 1}'),
        trailing: const Text('1/2'),
      ),
    );
  }

  group('ResponsiveDataCompletenessList', () {
    testWidgets('stacks all tiles in single column on phone (< 600dp)', (tester) async {
      await pumpCompletenessList(
        tester,
        screenSize: const Size(400, 800),
        standardTiles: buildTiles('Standard', 3),
        proTiles: buildTiles('Pro', 2),
      );

      expect(tester.takeException(), isNull);
      final s1 = tester.getRect(find.text('Standard 1'));
      final s2 = tester.getRect(find.text('Standard 2'));
      final s3 = tester.getRect(find.text('Standard 3'));
      final p1 = tester.getRect(find.text('Pro 1'));
      final p2 = tester.getRect(find.text('Pro 2'));

      expect(s1.top, lessThan(s2.top));
      expect(s2.top, lessThan(s3.top));
      expect(s3.top, lessThan(p1.top));
      expect(p1.top, lessThan(p2.top));
    });

    testWidgets('renders standard and pro sections in two columns on tablet (>= 600dp)',
        (tester) async {
      await pumpCompletenessList(
        tester,
        screenSize: const Size(800, 1200),
        standardTiles: buildTiles('Standard', 3),
        proTiles: buildTiles('Pro', 2),
      );

      expect(tester.takeException(), isNull);
      final s1 = tester.getRect(find.text('Standard 1'));
      final s2 = tester.getRect(find.text('Standard 2'));
      final s3 = tester.getRect(find.text('Standard 3'));
      final p1 = tester.getRect(find.text('Pro 1'));
      final p2 = tester.getRect(find.text('Pro 2'));

      expect(s1.top, s2.top);
      expect(s1.left, lessThan(s2.left));

      expect(s3.top, greaterThan(s1.bottom));
      expect(s3.left, s1.left);

      // Pro fields stay grouped together below standard fields
      expect(p1.top, greaterThan(s3.bottom));
      expect(p1.top, p2.top);
      expect(p1.left, lessThan(p2.left));
    });

    testWidgets('does not overflow at minimum 600dp tablet width', (tester) async {
      await pumpCompletenessList(
        tester,
        screenSize: const Size(600, 900),
        standardTiles: buildTiles('Standard Field', 4),
        proTiles: buildTiles('Pro Field', 2),
      );

      expect(tester.takeException(), isNull);
      final s1 = tester.getRect(find.text('Standard Field 1'));
      final s2 = tester.getRect(find.text('Standard Field 2'));
      expect(s1.top, s2.top);
    });
  });
}
