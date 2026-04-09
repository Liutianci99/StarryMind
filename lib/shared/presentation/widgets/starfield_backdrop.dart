import 'dart:math' as math;

import 'package:flutter/material.dart';

class StarfieldBackdrop extends StatelessWidget {
  const StarfieldBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _BackgroundGradient()),
        const Positioned(
          top: -120,
          left: -60,
          child: _GlowOrb(size: 280, color: Color(0x3344C4FF)),
        ),
        const Positioned(
          right: -80,
          top: 140,
          child: _GlowOrb(size: 240, color: Color(0x33FFB36B)),
        ),
        const Positioned(
          bottom: -80,
          left: 90,
          child: _GlowOrb(size: 260, color: Color(0x2236F6B0)),
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.4),
          radius: 1.1,
          colors: [Color(0xFF10203D), Color(0xFF060B16), Color(0xFF010308)],
          stops: [0, 0.55, 1],
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
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var index = 0; index < 140; index++) {
      final x = _hash(index * 17 + 1) * size.width;
      final y = _hash(index * 31 + 3) * size.height;
      final radius = 0.5 + _hash(index * 53 + 7) * 2;
      final alpha = 0.18 + _hash(index * 71 + 11) * 0.72;
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);

      if (index % 13 == 0) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = const Color(0xFF8FE9FF).withValues(alpha: 0.18);
        canvas.drawCircle(Offset(x, y), radius * 3.6, glowPaint);
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
