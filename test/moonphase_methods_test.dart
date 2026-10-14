import 'package:flutter_test/flutter_test.dart';
import 'package:wristcheck/model/moonphase_methods.dart';

void main() {
  group('MoonPhaseMethods', () {
    test('getDaysSinceLastNewMoon on reference date is 0', () {
      final DateTime refNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
      final days = MoonPhaseMethods.getDaysSinceLastNewMoon(refNewMoon);
      expect(days, equals(0));
    });

    test('getDaysSinceLastNewMoon on reference date + 10 days is 10', () {
      final DateTime date = DateTime.utc(2000, 1, 16, 18, 14);
      final days = MoonPhaseMethods.getDaysSinceLastNewMoon(date);
      expect(days, equals(10));
    });

    test('getDaysSinceLastNewMoon is always between 0 and 30', () {
      final days = MoonPhaseMethods.getDaysSinceLastNewMoon(DateTime.now());
      expect(days, greaterThanOrEqualTo(0));
      expect(days, lessThanOrEqualTo(30));
    });
  });
}
