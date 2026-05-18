import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';

class StarfieldBackdrop extends StatelessWidget {
  const StarfieldBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _BackgroundGradient()),
        const Positioned(
          top: -80,
          left: -40,
          child: _GlowOrb(size: 260, color: Color(0x24C9934B)),
        ),
        const Positioned(
          right: -60,
          top: 200,
          child: _GlowOrb(size: 220, color: Color(0x1A7D5A8E)),
        ),
        const Positioned(
          bottom: -60,
          left: 80,
          child: _GlowOrb(size: 240, color: Color(0x1A7A9080)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _StarfieldPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            AppTheme.creamPaper2,
            AppTheme.creamCanvas,
            AppTheme.creamVoid,
          ],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var index = 0; index < 100; index++) {
      final x = _hash(index * 17 + 1) * size.width;
      final y = _hash(index * 31 + 3) * size.height;
      final radius = 0.4 + _hash(index * 53 + 7) * 1.2;
      final alpha = 0.08 + _hash(index * 71 + 11) * 0.18;
      paint.color = AppTheme.ink900.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);

      if (index % 11 == 0) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = AppTheme.starGold.withValues(alpha: 0.12);
        canvas.drawCircle(Offset(x, y), radius * 3.0, glowPaint);
      }
    }
  }

  double _hash(int seed) {
    final value = math.sin(seed * 12.9898) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
