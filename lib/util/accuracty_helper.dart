import 'package:wristcheck/model/enums/rate_unit.dart';
import 'package:wristcheck/model/measurement.dart';

class AccuracyHelper {

  /// Calculates the watch's rate (accuracy) based on two sequential measurements.
  /// Once calculated the getScaledRate method should be called on the output to
  /// convert to the desired units (seconds per day/month/year)
  ///
  /// A positive result means the watch is running fast (gaining time).
  /// A negative result means the watch is running slow (losing time).
  ///
  /// Arguments:
  /// - baseline: The initial (older) measurement point.
  /// - latest: The final (newer) measurement point.
  static double calculateRate(Measurement baseline, Measurement latest) {

    // 1. Calculate the raw error (deviation) for the initial measurement.
    // Error = Watch Time - Atomic Time.
    final Duration initialError =
    baseline.watchTime.difference(baseline.atomicTime);

    // 2. Calculate the raw error (deviation) for the final measurement.
    final Duration finalError =
    latest.watchTime.difference(latest.atomicTime);

    // 3. Calculate the total change in error (Drift).
    // Drift = Final Error - Initial Error.
    final Duration drift = finalError - initialError;

    // 4. Calculate the total elapsed time (Interval).
    // Interval = Atomic Time 2 - Atomic Time 1.
    final Duration interval =
    latest.atomicTime.difference(baseline.atomicTime);

    // Ensure the interval is valid and non-zero.
    if (interval.inMicroseconds <= 0) {
      throw ArgumentError(
          'The second measurement must be taken after the first.');
    }

    // 5. Calculate the drift and interval.
    final double driftInSeconds = drift.inMicroseconds /
        Duration.microsecondsPerSecond;
    final double intervalInSeconds = interval.inMicroseconds /
        Duration.microsecondsPerSecond;

    final double rate = (driftInSeconds / intervalInSeconds);
    return rate;
  }

  ///Takes the Provided rate and requested unit (seconds per day/month/year
  ///and returns a result ready to display
  static double getScaledRate(double rate, RateUnit unit){
    // Constants for rate calculation scaling
    final double _SECONDS_PER_DAY = 86400.0;
    final double _DAYS_PER_MONTH = 30.4375; // 365.25 / 12
    final double _DAYS_PER_YEAR = 365.25;

    /// Helper function to get the correct scaling factor based on the desired RateUnit.
    double _getRateFactor(RateUnit unit) {
      switch (unit) {
        case RateUnit.day:
        // Rate is scaled by seconds per day (86400)
          return _SECONDS_PER_DAY;
        case RateUnit.month:
        // Rate is scaled by seconds per average month (86400 * 30.4375)
          return _SECONDS_PER_DAY * _DAYS_PER_MONTH;
        case RateUnit.year:
        // Rate is scaled by seconds per average year (86400 * 365.25)
          return _SECONDS_PER_DAY * _DAYS_PER_YEAR;
      }
    }

    final double scaleFactor = _getRateFactor(unit);
    return rate * scaleFactor;

  }



// --- UPDATED FUNCTION FOR MULTIPLE MEASUREMENTS ---

/// Calculates the overall average rate (accuracy) in seconds per the specified unit (s/unit)
/// by comparing the first and the last measurement in the provided list.
// double calculateOverallRatePerDay(List<Measurement> measurements, RateUnit unit) {
//   if (measurements.length < 2) {
//     throw ArgumentError('At least two measurements are required to calculate a rate.');
//   }
//
//   // Use the very first and very last measurements to calculate the rate
//   // over the maximum possible interval.
//   final Measurement mStart = measurements.first;
//   final Measurement mEnd = measurements.last;
//   // Delegate the calculation to the existing robust function, passing the unit.
//   return calculateRatePerDay(mStart, mEnd, unit);
// }


// void main() {
//   // --- EXAMPLE SCENARIO WITH MULTIPLE MEASUREMENTS (Digital/Quartz Watch) ---
//   // Let's test a watch that is very accurate, running at +5 seconds per year (~+0.0137 s/d)
//   // Over a 48-hour period, it should gain approximately 0.0273 seconds.
//   // The goal is to show how the rate looks in different units.
//   final List<Measurement> testMeasurements = [
//     // M1 (Start)
//     // Atomic: Day 1, 12:00:00 PM | Watch: 12:00:00 PM (Error: 0s)
//     (
//     atomicTime: DateTime.utc(2025, 10, 29, 12, 0, 0),
//     watchTime: DateTime.utc(2025, 10, 29, 12, 0, 0),
//     ),
//
//     // M2 (Intermediate Check 1 - After 24 hours)
//     // Atomic: Day 2, 12:00:00 PM | Watch: 12:00:00.0137s PM (Error: ~+0.0137s)
//     (
//     atomicTime: DateTime.utc(2025, 10, 30, 12, 0, 0),
//     watchTime: DateTime.utc(2025, 10, 30, 12, 0, 0).add(const Duration(microseconds: 13700)),
//     ),
//
//     // M3 (Final Check - After 48 hours)
//     // Atomic: Day 3, 12:00:00 PM | Watch: 12:00:00.0273s PM (Error: ~+0.0273s)
//     (
//     atomicTime: DateTime.utc(2025, 10, 31, 12, 0, 0),
//     watchTime: DateTime.utc(2025, 10, 31, 12, 0, 0).add(const Duration(microseconds: 27300)),
//     ),
//   ];
//   // Determine the drift and interval for display
//   final Measurement mStart = testMeasurements.first;
//   final Measurement mEnd = testMeasurements.last;
//   final Duration totalDrift = mEnd.watchTime.difference(mEnd.atomicTime) -
//       mStart.watchTime.difference(mStart.atomicTime);
//   final Duration totalInterval = mEnd.atomicTime.difference(mStart.atomicTime);
//
//
//   print('--- Watch Accuracy Report (Accurate Watch Test) ---');
//   print('Number of Measurements: ${testMeasurements.length}');
//   print('Total Drift over Interval: ${totalDrift.inMilliseconds} milliseconds');
//   print('Total Test Interval: ${totalInterval.inHours} hours');
//   print('-----------------------------');
//
//   // Calculate and display rates in all three units.
//   final Map<RateUnit, String> rates = {};
//
//   for (final unit in RateUnit.values) {
//     final double rate = calculateOverallRatePerDay(testMeasurements, unit);
//     String unitLabel = switch (unit) {
//       RateUnit.day => 's/d',
//       RateUnit.month => 's/m',
//       RateUnit.year => 's/y',
//     };
//     rates[unit] = '${rate.toStringAsFixed(3)} $unitLabel';
//   }
//
//   print('\nCalculated Rates:');
//   rates.forEach((key, value) {
//     print('- ${key.name.padRight(5)}: $value');
//   });
//
//   // Example of final sentiment based on the most common metric (s/d)
//   final double ratePerDay = calculateOverallRatePerDay(testMeasurements, RateUnit.day);
//   if (ratePerDay > 0) {
//     print('\nOverall Analysis: The watch is running FAST.');
//   } else if (ratePerDay < 0) {
//     print('\nOverall Analysis: The watch is running SLOW.');
//   } else {
//     print('\nOverall Analysis: The watch is perfectly accurate!');
//   }
// }

}