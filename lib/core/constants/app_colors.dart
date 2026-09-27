import 'package:flutter/material.dart';

class AppColors {
  // Primary Islamic Colors
  static const Color primaryTeal = Color(0xFF0F5257);
  static const Color primaryTealDark = Color(0xFF0B3C3E);
  static const Color secondaryEmerald = Color(0xFF16A085);
  static const Color emeraldLight = Color(0xFFD4EFDF);

  // Accent Gold & Amber
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentAmber = Color(0xFFF39C12);
  static const Color goldLight = Color(0xFFFCF3CF);

  // Background & Cards
  static const Color bgIvory = Color(0xFFF4F7F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF132A2D);
  static const Color darkBg = Color(0xFF0A1819);

  // Status & Feedback
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color errorRed = Color(0xFFC0392B);
  static const Color infoBlue = Color(0xFF2980B9);

  // Text Colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFF9FAFB);
  static const Color textArabic = Color(0xFF0B3C3E);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, secondaryEmerald],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF39C12), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0F5257), Color(0xFF165B60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
