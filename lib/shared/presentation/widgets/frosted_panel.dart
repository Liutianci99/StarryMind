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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF0FAF6EA), // cream-paper at ~94% — opaque enough to fake frost
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ink900.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
