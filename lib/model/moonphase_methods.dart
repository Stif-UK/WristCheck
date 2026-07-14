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
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          children: [
            // Base background
            Container(color: Colors.black),
            
            // Moon Image (only if detailedMoon is true)
            if (detailedMoon)
              Center(
                child: Transform.scale(
                  scale: 1.5, // Slightly scale up to ensure it fills the circular area
                  child: Image.asset(
                    'assets/img/grayscale_moon.png',
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                ),
              ),
            
            // Phase Painter
            CustomPaint(
              size: Size(size, size),
              painter: _MoonPainter(phase, detailedMoon: detailedMoon),
            ),
            
            // Overlay Border
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final double phase;
  final bool detailedMoon;

  _MoonPainter(this.phase, {required this.detailedMoon});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // illumination < 0 means Gibbous (more than half)
    // illumination > 0 means Crescent (less than half)
    final double illumination = cos(2 * pi * phase);
    final bool isWaxing = phase <= 0.5;

    if (detailedMoon) {
      // When detailed, we have the image in the background.
      // We need to paint the SHADOW (black) on top.
      paint.color = Colors.black;

      Path darkPath = Path();
      if (isWaxing) {
        // Waxing: Shadow is primarily on the LEFT
        darkPath.addArc(Rect.fromCircle(center: center, radius: radius), pi / 2, pi);

        if (illumination >= 0) {
          // Crescent (0 to 0.25): Most of the right side is also dark
          darkPath.addOval(Rect.fromCenter(
            center: center,
            width: radius * 2 * illumination,
            height: radius * 2,
          ));
        } else {
          // Gibbous (0.25 to 0.5): Part of the left side shadow is actually lit
          Path ovalPath = Path()
            ..addOval(Rect.fromCenter(
              center: center,
              width: radius * 2 * illumination.abs(),
              height: radius * 2,
            ));
          darkPath = Path.combine(PathOperation.difference, darkPath, ovalPath);
        }
      } else {
        // Waning: Shadow is primarily on the RIGHT
        darkPath.addArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, pi);

        if (illumination >= 0) {
          // Crescent (0.75 to 1.0): Most of the left side is also dark
          darkPath.addOval(Rect.fromCenter(
            center: center,
            width: radius * 2 * illumination,
            height: radius * 2,
          ));
        } else {
          // Gibbous (0.5 to 0.75): Part of the right side shadow is actually lit
          Path ovalPath = Path()
            ..addOval(Rect.fromCenter(
              center: center,
              width: radius * 2 * illumination.abs(),
              height: radius * 2,
            ));
          darkPath = Path.combine(PathOperation.difference, darkPath, ovalPath);
        }
      }
      canvas.drawPath(darkPath, paint);
    } else {
      // Standard mode: Background is black, paint LIGHT (yellow) on top.
      paint.color = Colors.yellow;

      Path lightPath = Path();
      if (isWaxing) {
        // Waxing: Light is on the RIGHT
        lightPath.addArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, pi);

        if (illumination >= 0) {
          // Crescent: sliver of light on far right
          Path ovalPath = Path()
            ..addOval(Rect.fromCenter(
              center: center,
              width: radius * 2 * illumination,
              height: radius * 2,
            ));
          lightPath = Path.combine(PathOperation.difference, lightPath, ovalPath);
        } else {
          // Gibbous: light on right plus extra on left
          lightPath.addOval(Rect.fromCenter(
            center: center,
            width: radius * 2 * illumination.abs(),
            height: radius * 2,
          ));
        }
      } else {
        // Waning: Light is on the LEFT
        lightPath.addArc(Rect.fromCircle(center: center, radius: radius), pi / 2, pi);

        if (illumination >= 0) {
          // Crescent: sliver of light on far left
          Path ovalPath = Path()
            ..addOval(Rect.fromCenter(
              center: center,
              width: radius * 2 * illumination,
              height: radius * 2,
            ));
          lightPath = Path.combine(PathOperation.difference, lightPath, ovalPath);
        } else {
          // Gibbous: light on left plus extra on right
          lightPath.addOval(Rect.fromCenter(
            center: center,
            width: radius * 2 * illumination.abs(),
            height: radius * 2,
          ));
        }
      }
      canvas.drawPath(lightPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoonPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.detailedMoon != detailedMoon;
}
