import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SplashPainter extends CustomPainter {
  final double animationValue;

  SplashPainter({required this.animationValue}) : super(repaint: null);

  @override
  void paint(Canvas canvas, Size size) {
    // We want the original 400x400 SVG artwork to be centered and 
    // scaled to fit or fill the screen width gracefully.
    final double scale = size.width / 400;

    // 1. Draw background gradient filling the entire screen
    final bgRect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [
          const Color(0xFF00D4AA), // Primary
          const Color(0xFF2F1160), // Secondary
        ],
      );
    canvas.drawRect(bgRect, bgPaint);

    canvas.save();
    
    // 2. Transform the coordinate system to match the 400x400 center
    final offsetX = (size.width - 400 * scale) / 2;
    final offsetY = (size.height - 400 * scale) / 2;
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    final courtPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.butt;

    // Helper functions for progress interpolation
    double getProgress(double start, double end) {
      if (animationValue <= start) return 0.0;
      if (animationValue >= end) return 1.0;
      return (animationValue - start) / (end - start);
    }

    double applyCurve(double t) {
      // Replicate cubic-bezier(0.4, 0, 0.2, 1) approx
      return Curves.fastOutSlowIn.transform(t);
    }

    /* 
     * ANIMATION TIMELINE (Total 2.5s):
     * - Line 1 & 2: 0.1s to 1.6s -> (0.04 to 0.64)
     * - Line 3 & 4: 0.3s to 1.8s -> (0.12 to 0.72)
     * - Line 5 & 6: 0.5s to 2.0s -> (0.20 to 0.80)
     * - Pin Pop: 1.2s to 1.9s -> (0.48 to 0.76)
     * - Mask Lines: 1.8s to 2.4s -> (0.72 to 0.96)
     */

    // --- Court Lines ---

    // Group 1
    final prog1 = applyCurve(getProgress(0.04, 0.64));
    final p1a = Path()..moveTo(-20, 190)..quadraticBezierTo(200, 290, 420, 190);
    final p1b = Path()..moveTo(-20, 340)..quadraticBezierTo(200, 300, 420, 340);
    _drawPathWithProgress(canvas, courtPaint, p1a, prog1);
    _drawPathWithProgress(canvas, courtPaint, p1b, prog1);

    // Group 2
    final prog2 = applyCurve(getProgress(0.12, 0.72));
    final p2a = Path()..moveTo(115, 230)..lineTo(115, 420);
    final p2b = Path()..moveTo(285, 230)..lineTo(285, 420);
    _drawPathWithProgress(canvas, courtPaint, p2a, prog2);
    _drawPathWithProgress(canvas, courtPaint, p2b, prog2);

    // Group 3
    final prog3 = applyCurve(getProgress(0.20, 0.80));
    final p3a = Path()
      ..moveTo(160, 240)
      ..lineTo(160, 315)
      ..arcToPoint(
        const Offset(240, 315),
        radius: const Radius.circular(40),
        clockwise: false,
      )
      ..lineTo(240, 240);
    final p3b = Path()..moveTo(200, 280)..lineTo(200, 370);
    _drawPathWithProgress(canvas, courtPaint, p3a, prog3);
    _drawPathWithProgress(canvas, courtPaint, p3b, prog3);

    // --- Central Pin & Mask ---

    final pinProg = getProgress(0.48, 0.76);
    if (pinProg > 0) {
      final pinScale = Curves.easeOutBack.transform(pinProg);
      final pinOpacity = Curves.easeIn.transform(pinProg);
      final pinTranslateY = 40.0 * (1.0 - Curves.easeOut.transform(pinProg));

      // Use a slightly larger rect to safely capture the bounding box when bouncing
      canvas.saveLayer(const Rect.fromLTWH(-100, -100, 600, 600), Paint());

      canvas.save();
      
      // Transform origin center: 200, 200
      canvas.translate(200, 200 + pinTranslateY);
      canvas.scale(pinScale, pinScale);
      canvas.translate(-200, -200);

      final pinBody = Path()
        ..moveTo(200, 280)
        ..quadraticBezierTo(115, 205, 115, 135)
        ..arcToPoint(
          const Offset(285, 135),
          radius: const Radius.circular(85),
          largeArc: true,
          clockwise: true,
        )
        ..quadraticBezierTo(285, 205, 200, 280)
        ..close();

      final pinFill = Paint()
        ..color = Colors.white.withOpacity(pinOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawPath(pinBody, pinFill);

      canvas.restore(); // Restore transform of the pin body

      // Check if mask lines need drawing
      final maskProg = applyCurve(getProgress(0.72, 0.96));
      if (maskProg > 0) {
        final maskPaint = Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.butt
          ..blendMode = BlendMode.clear;

        final m1 = Path()..moveTo(200, 50)..lineTo(200, 210);
        final m2 = Path()..moveTo(117, 135)..lineTo(283, 135);
        final m3 = Path()..moveTo(155, 61)..quadraticBezierTo(110, 135, 155, 209);
        final m4 = Path()..moveTo(245, 61)..quadraticBezierTo(290, 135, 245, 209);

        _drawPathWithProgress(canvas, maskPaint, m1, maskProg);
        _drawPathWithProgress(canvas, maskPaint, m2, maskProg);
        _drawPathWithProgress(canvas, maskPaint, m3, maskProg);
        _drawPathWithProgress(canvas, maskPaint, m4, maskProg);
      }

      canvas.restore(); // Composites the saveLayer (with cuts!) onto the background
    }

    canvas.restore(); // Restore global canvas state
  }

  void _drawPathWithProgress(Canvas canvas, Paint paint, Path path, double progress) {
    if (progress <= 0.0) return;
    if (progress >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      final extract = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extract, paint);
    }
  }

  @override
  bool shouldRepaint(SplashPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
