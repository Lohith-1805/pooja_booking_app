import 'package:flutter/material.dart';

class AppColors {
  // Primary Saffron/Orange Palette
  static const Color primary = Color(0xFFD4600A);
  static const Color primaryDark = Color(0xFFB04E07);
  static const Color primaryLight = Color(0xFFE8832E);
  static const Color primaryExtraLight = Color(0xFFFFF0E6);

  // Golden Accent
  static const Color golden = Color(0xFFF5A623);
  static const Color goldenDark = Color(0xFFD4880A);
  static const Color goldenLight = Color(0xFFFBCF75);

  // Sacred Red
  static const Color sacred = Color(0xFF8B1A1A);
  static const Color sacredLight = Color(0xFFB52929);

  // Background
  static const Color background = Color(0xFFFDF5E6);
  static const Color backgroundDark = Color(0xFFF5E6CC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF8F0);

  // Text
  static const Color textPrimary = Color(0xFF2D1A00);
  static const Color textSecondary = Color(0xFF6B4226);
  static const Color textHint = Color(0xFF9E7A5A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF57F17);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF01579B);

  // Divider & Border
  static const Color divider = Color(0xFFE8D5B7);
  static const Color border = Color(0xFFD4B896);
  static const Color borderLight = Color(0xFFEED9B8);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE8D5B7);
  static const Color shimmerHighlight = Color(0xFFFFF0D6);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4600A), Color(0xFFF5A623)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sacredGradient = LinearGradient(
    colors: [Color(0xFF8B1A1A), Color(0xFFD4600A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF8B1A1A), Color(0xFFD4600A), Color(0xFFF5A623)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFF8F0), Color(0xFFFFF0E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
