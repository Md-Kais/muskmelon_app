import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand palette
  static const Color primary = Color(0xFF2E7D32);    // Green
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color accent = Color(0xFFFF9800);     // Orange
  static const Color surface = Color(0xFFF9FAFB);    // Light bg
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);

  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.notoSansBengaliTextTheme(
        base.textTheme,
      ).copyWith(
        displaySmall: GoogleFonts.notoSansBengali(
            fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
        titleLarge: GoogleFonts.notoSansBengali(
            fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: GoogleFonts.notoSansBengali(
            fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: GoogleFonts.notoSansBengali(
            fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
        bodyMedium: GoogleFonts.notoSansBengali(
            fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: GoogleFonts.notoSansBengali(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        surfaceTintColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
