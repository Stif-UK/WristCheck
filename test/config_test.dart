import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/config.dart';

void main() {
  group('WristCheckConfig tests', () {
    test('acknowledgePurchase can be set to false in debug mode', () {
      WristCheckConfig.acknowledgePurchase = true;
      expect(WristCheckConfig.acknowledgePurchase, isTrue);

      WristCheckConfig.acknowledgePurchase = false;
      expect(WristCheckConfig.acknowledgePurchase, isFalse);

      WristCheckConfig.acknowledgePurchase = true;
    });

    test('getNow returns customTime when enableTimeOverride is true', () {
      final testTime = DateTime(2025, 5, 22, 14, 30, 0);
      WristCheckConfig.customTime = testTime;

      WristCheckConfig.enableTimeOverride = true;
      expect(WristCheckConfig.getNow(), equals(testTime));

      WristCheckConfig.enableTimeOverride = false;
      expect(WristCheckConfig.getNow(), isNot(equals(testTime)));
    });
  });
}
