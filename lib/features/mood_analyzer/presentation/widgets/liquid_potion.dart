// lib/widgets/liquid_potion.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Improved futuristic liquid potion visual:
/// - Smooth sine wave created with dense sampling (no hard edges)
/// - Bubbles rising with per-bubble phase offsets
/// - Softer, lighter blur (avoid heavy MaskFilter artifacts)
/// - Inner shadow + glossy highlight
/// Usage: pass `fillPercent` (0.0 - 1.0) and `colorA`, `colorB` for gradient.
class LiquidPotion extends StatefulWidget {
  final double fillPercent;
  final Color colorA;
  final Color colorB;
  final Color glowColor;
  final double size;
  final bool animate;

  const LiquidPotion({
    Key? key,
    required this.fillPercent,
    required this.colorA,
    required this.colorB,
    this.glowColor = const Color(0xFF7EE0C3),
    this.size = 260,
    this.animate = true,
  }) : super(key: key);

  @override
  _LiquidPotionState createState() => _LiquidPotionState();
}

class _LiquidPotionState extends State<LiquidPotion> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _particlesController;
  late AnimationController _haloPulseController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: Duration(milliseconds: 1600));
    _particlesController = AnimationController(vsync: this, duration: Duration(seconds: 4));
    _haloPulseController = AnimationController(vsync: this, duration: Duration(milliseconds: 1800));

    if (widget.animate) {
      _waveController.repeat();
      _particlesController.repeat();
      _haloPulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _particlesController.dispose();
    _haloPulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LiquidPotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_waveController.isAnimating) _waveController.repeat();
    if (!widget.animate && _waveController.isAnimating) _waveController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_waveController, _particlesController, _haloPulseController]),
        builder: (context, _) {
          return CustomPaint(
            painter: _ImprovedPotionPainter(
              phase: _waveController.value * 2 * pi,
              bubblePhase: _particlesController.value,
              haloPulse: _haloPulseController.value,
              fillPercent: widget.fillPercent.clamp(0.0, 1.0),
              colorA: widget.colorA,
              colorB: widget.colorB,
              glowColor: widget.glowColor,
              seed: 123456,
            ),
          );
        },
      ),
    );
  }
}

class _ImprovedPotionPainter extends CustomPainter {
  final double phase;
  final double bubblePhase;
  final double haloPulse;
  final double fillPercent;
  final Color colorA;
  final Color colorB;
  final Color glowColor;
  final int seed;
  _ImprovedPotionPainter({
    required this.phase,
    required this.bubblePhase,
    required this.haloPulse,
    required this.fillPercent,
    required this.colorA,
    required this.colorB,
    required this.glowColor,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Random rnd = Random(seed);
    final double radius = min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Outer halo (soft, subtle)
    final double haloRadius = radius * 1.05;
    final Paint haloPaint = Paint()
      ..shader = SweepGradient(
        colors: [glowColor.withOpacity(0.12 * (0.8 + haloPulse * 0.6)), glowColor.withOpacity(0.02), glowColor.withOpacity(0.08)],
        stops: [0.0, 0.6, 1.0],
        transform: GradientRotation(phase * 0.25),
      ).createShader(Rect.fromCircle(center: center, radius: haloRadius));
    canvas.drawCircle(center, haloRadius, haloPaint);

    // Very subtle background (keeps canvas from looking empty on some devices)
    final Paint bgPaint = Paint()..color = Colors.white.withOpacity(0.0);
    canvas.drawCircle(center, radius, bgPaint);

    // Glass: faint bright top and inner shadow
    final Rect jarRect = Rect.fromCircle(center: center, radius: radius);
    final Paint glassPaint = Paint()
      ..shader = LinearGradient(colors: [Colors.white.withOpacity(0.92), Colors.white.withOpacity(0.52)])
          .createShader(jarRect);
    canvas.drawCircle(center, radius - 1, glassPaint);

    final Paint innerEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black.withOpacity(0.06);
    canvas.drawCircle(center, radius - 2, innerEdge);

    // clip to circle for liquid drawing
    canvas.save();
    final Path clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius - 8));
    canvas.clipPath(clipPath);

    // compute the liquid top position (y)
    final double liquidTop = lerpDouble(size.height * 0.95, size.height * 0.05, fillPercent)!;

    // build a smooth sine wave with dense sampling to avoid jaggedness
    final Path wave = Path();
    wave.moveTo(0, size.height);
    wave.lineTo(0, liquidTop);

    // denser sampling and eased amplitude for nicer look
    final int samples = (size.width / 2).round().clamp(80, 220);
    final double waveCount = 2.0;
    final double maxAmplitude = 8.0 + 10.0 * sqrt(fillPercent);
    for (int i = 0; i <= samples; i++) {
      final double x = (i / samples) * size.width;
      final double dx = (x / size.width) * waveCount * 2 * pi;
      final double ampFalloff = (1.0 - (i / samples - 0.5).abs() * 2).clamp(0.2, 1.0); // slightly center-biased
      final double y = (maxAmplitude * ampFalloff) * sin(dx + phase * 1.1) + liquidTop;
      wave.lineTo(x, y);
    }

    wave.lineTo(size.width, size.height);
    wave.close();

    // dynamic gradient morphing (soft)
    final double t = (sin(phase * 0.35) + 1) / 2;
    final Color c1 = _lerpColor(colorA, colorB, 0.18 * t);
    final Color c2 = _lerpColor(colorB, colorA, 0.18 * (1 - t));
    final Rect gradRect = Rect.fromLTWH(0, liquidTop, size.width, size.height - liquidTop);

    final Paint liquidPaint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c1.withOpacity(0.98), c2.withOpacity(0.98)])
          .createShader(gradRect);

    canvas.drawPath(wave, liquidPaint);

    // subtle sheen across the liquid (curved)
    final Path sheenPath = Path();
    final double sheenY = liquidTop + (size.height - liquidTop) * 0.18;
    sheenPath.moveTo(0, sheenY);
    for (int i = 0; i <= (size.width / 20).round(); i++) {
      final double x = (i / (size.width / 20)) * size.width;
      final double dx = (x / size.width) * 2 * pi;
      final double y = 6 * sin(dx + phase * 1.3) + sheenY;
      sheenPath.lineTo(x, y);
    }
    sheenPath.lineTo(size.width, sheenY + 24);
    sheenPath.lineTo(0, sheenY + 24);
    sheenPath.close();

    final Paint sheenPaint = Paint()..shader = LinearGradient(colors: [Colors.white.withOpacity(0.14), Colors.white.withOpacity(0.0)]).createShader(Rect.fromLTWH(0, sheenY, size.width, 36));
    canvas.drawPath(sheenPath, sheenPaint);

    // rising bubbles/particles - smoother calculation and gentle blur
    for (int i = 0; i < 10; i++) {
      final double localSeed = (i * 37 + seed) % 1000 / 1000;
      final double offsetPhase = (bubblePhase + localSeed * 2.0) % 1.0;
      final double baseX = (rnd.nextDouble() * 0.9 + 0.05) * size.width;
      final double travel = (size.height - liquidTop);
      final double vy = (offsetPhase) * travel;
      final double y = liquidTop + (travel - vy);
      if (y < liquidTop || y > size.height) continue;

      final double sizeFactor = 1.8 + rnd.nextDouble() * 5.0 * (0.4 + fillPercent * 0.6);
      final double alpha = (1.0 - (offsetPhase)).clamp(0.08, 0.85);

      final Paint bubblePaint = Paint()
        ..color = Colors.white.withOpacity(alpha * 0.9)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sizeFactor * 0.7); // light blur only

      canvas.drawCircle(Offset(baseX, y), sizeFactor * (0.9 + fillPercent * 0.6), bubblePaint);
    }

    // subtle translucent bottom gradient to add depth
    final Paint bottomShade = Paint()
      ..shader = LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.03)]).createShader(Rect.fromLTWH(0, size.height - radius * 0.6, size.width, radius * 0.6));
    canvas.drawRect(Rect.fromLTWH(0, size.height - radius * 0.6, size.width, radius * 0.6), bottomShade);

    canvas.restore(); // end clip

    // small inner label area (soft)
    final double labelW = radius * 1.0;
    final double labelH = 14.0;
    final Rect labelRect = Rect.fromCenter(center: center.translate(0, radius * 0.65), width: labelW, height: labelH);
    final RRect labelR = RRect.fromRectAndRadius(labelRect, Radius.circular(8));
    final Paint labelBg = Paint()..color = Colors.black.withOpacity(0.05);
    canvas.drawRRect(labelR, labelBg);

    // small highlight on upper-left glass
    final Path glassHighlight = Path()
      ..moveTo(center.dx - radius * 0.6, center.dy - radius * 0.9)
      ..quadraticBezierTo(center.dx - radius * 0.25, center.dy - radius * 1.02, center.dx + radius * 0.18, center.dy - radius * 0.7)
      ..lineTo(center.dx + radius * 0.18, center.dy - radius * 0.6)
      ..quadraticBezierTo(center.dx - radius * 0.2, center.dy - radius * 0.9, center.dx - radius * 0.6, center.dy - radius * 0.9)
      ..close();
    final Paint glassHighlightPaint = Paint()..color = Colors.white.withOpacity(0.07);
    canvas.drawPath(glassHighlight, glassHighlightPaint);
  }

  Color _lerpColor(Color a, Color b, double t) {
    final int A = (a.alpha + ((b.alpha - a.alpha) * t)).round();
    final int R = (a.red + ((b.red - a.red) * t)).round();
    final int G = (a.green + ((b.green - a.green) * t)).round();
    final int B = (a.blue + ((b.blue - a.blue) * t)).round();
    return Color.fromARGB(A, R, G, B);
  }

  @override
  bool shouldRepaint(covariant _ImprovedPotionPainter old) {
    return phase != old.phase ||
        bubblePhase != old.bubblePhase ||
        haloPulse != old.haloPulse ||
        fillPercent != old.fillPercent ||
        colorA != old.colorA ||
        colorB != old.colorB ||
        glowColor != old.glowColor;
  }
}
