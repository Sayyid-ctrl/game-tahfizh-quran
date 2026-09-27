import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgIvory,
      primaryColor: AppColors.primaryTeal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        secondary: AppColors.accentGold,
        background: AppColors.bgIvory,
        surface: AppColors.cardWhite,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(
          color: AppColors.textDark,
          fontSize: 16,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.textLight,
        centerTitle: true,
        elevation: 0,
        scaffoldLineWidth: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardWhite,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.textLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static TextStyle arabicTextStyle({
    double fontSize = 24,
    Color color = AppColors.textArabic,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    try {
      return GoogleFonts.amiri(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: 1.8,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'serif',
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: 1.8,
      );
    }
  }
}
