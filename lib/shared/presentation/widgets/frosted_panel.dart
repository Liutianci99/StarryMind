import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';

class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xD1FDFAF1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.ink900.withValues(alpha: 0.14),
                blurRadius: 28,
                offset: const Offset(0, 12),
                spreadRadius: -12,
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
