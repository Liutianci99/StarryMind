import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData build() {
    const scaffoldColor = Color(0xFF020611);
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF87E8FF),
      brightness: Brightness.dark,
    );
    final colorScheme = baseScheme.copyWith(
      primary: const Color(0xFF87E8FF),
      onPrimary: const Color(0xFF001821),
      secondary: const Color(0xFFFFD47D),
      tertiary: const Color(0xFF88FFC8),
      surface: const Color(0xFF08111E),
      onSurface: Colors.white,
      outline: Colors.white.withValues(alpha: 0.16),
      shadow: Colors.black.withValues(alpha: 0.28),
    );
    final baseTextTheme = ThemeData(brightness: Brightness.dark).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          height: 1.05,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 13,
          height: 1.45,
          color: Colors.white.withValues(alpha: 0.78),
        ),
      ),
      dividerColor: Colors.white.withValues(alpha: 0.12),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
