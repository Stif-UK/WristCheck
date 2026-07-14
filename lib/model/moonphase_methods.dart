import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class MoonPhaseMethods {
  /// Calculates the current moon phase.
  /// Returns a double from 0.0 to 1.0.
  /// 0.0: New Moon
  /// 0.25: First Quarter
  /// 0.5: Full Moon
  /// 0.75: Last Quarter
  static double getMoonPhase(DateTime date) {
    // Reference new moon: January 6, 2000, 18:14 UTC
    final DateTime refNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
    const double synodicMonth = 29.530588853;

    final Duration diff = date.toUtc().difference(refNewMoon);
    final double days = diff.inMilliseconds / (1000 * 60 * 60 * 24);
    double phase = (days % synodicMonth) / synodicMonth;

    return phase;
  }

  /// Returns a widget representing the moon phase for the given date.
  static Widget buildMoonWidget(DateTime date, double size, {bool detailedMoon = false}) {
    return CustomMoonWidget(date: date, size: size, detailedMoon: detailedMoon);
  }

  /// Returns the name of the current moon phase.
  static String getMoonPhaseText(DateTime date, BuildContext context) {
    final double phase = getMoonPhase(date);
    final l = AppLocalizations.of(context)!;

    if (phase < 0.03 || phase > 0.97) return l.newMoon;
    if (phase < 0.22) return l.waxingCrescent;
    if (phase < 0.28) return l.firstQuarter;
    if (phase < 0.47) return l.waxingGibbous;
    if (phase < 0.53) return l.fullMoon;
    if (phase < 0.72) return l.waningGibbous;
    if (phase < 0.78) return l.lastQuarter;
    return l.waningCrescent;
  }
}

class CustomMoonWidget extends StatelessWidget {
  final DateTime date;
  final double size;
  final bool detailedMoon;

  const CustomMoonWidget({
    super.key,
    required this.date,
    required this.size,
    this.detailedMoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final double phase = MoonPhaseMethods.getMoonPhase(date);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        image: detailedMoon
            ? const DecorationImage(
                image: AssetImage('assets/img/grayscale_moon.png'),
                fit: BoxFit.cover,
              )
            : null,
        border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _MoonPainter(phase),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final double phase;

  _MoonPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Paint yellowPaint = Paint()..color = Colors.yellow;
    final Paint blackPaint = Paint()..color = Colors.black;

    double illumination = cos(2 * pi * phase);

    if (phase <= 0.5) {
      // Waxing (New -> First Quarter -> Full)
      // Illuminated side is on the right.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        pi,
        true,
        yellowPaint,
      );

      if (illumination >= 0) {
        // Crescent
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 2 * illumination, height: radius * 2),
          blackPaint,
        );
      } else {
        // Gibbous
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 2 * illumination.abs(), height: radius * 2),
          yellowPaint,
        );
      }
    } else {
      // Waning (Full -> Last Quarter -> New)
      // Illuminated side is on the left.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi / 2,
        pi,
        true,
        yellowPaint,
      );

      if (illumination >= 0) {
        // Crescent
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 2 * illumination, height: radius * 2),
          blackPaint,
        );
      } else {
        // Gibbous
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 2 * illumination.abs(), height: radius * 2),
          yellowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MoonPainter oldDelegate) => oldDelegate.phase != phase;
}
