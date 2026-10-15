import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 24.0;
    canvas.scale(scale, scale);

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Red
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(12, 4.75)
      ..cubicTo(13.77, 4.75, 15.35, 5.36, 16.6, 6.55)
      ..lineTo(20.02, 3.13)
      ..cubicTo(17.95, 1.19, 15.24, 0, 12, 0)
      ..cubicTo(7.42, 0, 3.37, 2.72, 1.39, 6.61)
      ..lineTo(5.32, 9.73)
      ..cubicTo(6.26, 6.9, 8.89, 4.75, 12, 4.75)
      ..close();
    canvas.drawPath(redPath, paint);

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(5.32, 14.27)
      ..cubicTo(5.08, 13.55, 4.94, 12.78, 4.94, 12)
      ..cubicTo(4.94, 11.22, 5.08, 10.45, 5.32, 9.73)
      ..lineTo(1.39, 6.61)
      ..cubicTo(0.5, 8.38, 0, 10.13, 0, 12)
      ..cubicTo(0, 13.87, 0.5, 15.62, 1.39, 17.39)
      ..lineTo(5.32, 14.27)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Green
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(12, 24)
      ..cubicTo(15.24, 24, 17.95, 22.92, 19.93, 21.09)
      ..lineTo(16.05, 18.04)
      ..cubicTo(14.97, 18.76, 13.6, 19.2, 12, 19.2)
      ..cubicTo(8.89, 19.2, 6.26, 17.1, 5.32, 14.27)
      ..lineTo(1.39, 17.39)
      ..cubicTo(3.37, 21.28, 7.42, 24, 12, 24)
      ..close();
    canvas.drawPath(greenPath, paint);

    // Blue
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(23.745, 12.27)
      ..cubicTo(23.745, 11.57, 23.685, 10.87, 23.555, 10.20)
      ..lineTo(12, 10.20)
      ..lineTo(12, 14.71)
      ..lineTo(18.6, 14.71)
      ..cubicTo(18.31, 16.23, 17.46, 17.53, 16.2, 18.39)
      ..lineTo(16.2, 21.44)
      ..lineTo(20.08, 21.44)
      ..cubicTo(22.35, 19.35, 23.745, 16.27, 23.745, 12.27)
      ..close();
    canvas.drawPath(bluePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
