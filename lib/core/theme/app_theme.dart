import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Design system tokens
  static const creamCanvas = Color(0xFFF6F1E1);
  static const creamVoid = Color(0xFFEBE6D4);
  static const creamPaper = Color(0xFFFAF6EA);
  static const creamPaper2 = Color(0xFFFDFAF1);
  static const creamHover = Color(0xFFF2ECD8);
  static const creamPress = Color(0xFFEAE2C9);

  static const ink900 = Color(0xFF1D2140);
  static const ink700 = Color(0xFF2E3458);
  static const ink500 = Color(0xFF5A6086);
  static const ink400 = Color(0xFF878CAC);
  static const ink300 = Color(0xFFB4B7C8);

  static const starGold = Color(0xFFC9934B);
  static const starGoldSoft = Color(0xFFE0B775);
  static const plum = Color(0xFF7D5A8E);
  static const sage = Color(0xFF7A9080);
  static const ember = Color(0xFFC8704E);
  static const indigoCool = Color(0xFF6A7BB0);

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: starGold,
      brightness: Brightness.light,
    ).copyWith(
      primary: starGold,
      onPrimary: creamPaper,
      secondary: plum,
      tertiary: sage,
      surface: creamPaper,
      onSurface: ink900,
      outline: ink300,
    );

    final displayFont = GoogleFonts.cormorantGaramondTextTheme();
    final uiFont = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: creamCanvas,
      textTheme: TextTheme(
        headlineLarge: displayFont.headlineLarge?.copyWith(
          fontSize: 36, fontWeight: FontWeight.w500,
          letterSpacing: -0.8, height: 1.15, color: ink900,
        ),
        headlineMedium: displayFont.headlineMedium?.copyWith(
          fontSize: 24, fontWeight: FontWeight.w500,
          letterSpacing: -0.4, color: ink900,
        ),
        titleLarge: displayFont.titleLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w600, color: ink900,
        ),
        titleMedium: uiFont.titleMedium?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w500, color: ink500,
        ),
        bodyLarge: displayFont.bodyLarge?.copyWith(
          fontSize: 16, height: 1.6, color: ink700,
        ),
        bodyMedium: displayFont.bodyMedium?.copyWith(
          fontSize: 14, height: 1.5, color: ink500,
        ),
        bodySmall: uiFont.bodySmall?.copyWith(
          fontSize: 11, letterSpacing: 0.14 * 11,
          fontWeight: FontWeight.w500, color: ink400,
        ),
        labelSmall: uiFont.labelSmall?.copyWith(
          fontSize: 10, letterSpacing: 1.4,
          fontWeight: FontWeight.w500, color: ink400,
        ),
      ),
      dividerColor: ink900.withValues(alpha: 0.08),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamVoid.withValues(alpha: 0.5),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic, color: ink400,
          fontFamily: GoogleFonts.cormorantGaramond().fontFamily,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink900.withValues(alpha: 0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink900.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: starGold.withValues(alpha: 0.50)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: starGold,
          foregroundColor: creamPaper,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: uiFont.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
