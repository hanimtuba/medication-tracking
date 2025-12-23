import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Light theme colors
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color secondaryLight = Color(0xFF03DAC6);
  static const Color errorLight = Color(0xFFB00020);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color warningLight = Color(0xFFFF9800);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF90CAF9);
  static const Color secondaryDark = Color(0xFF03DAC6);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color successDark = Color(0xFF81C784);
  static const Color warningDark = Color(0xFFFFB74D);

  // Tema'ya göre renk döndür
  static Color primary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryDark : primaryLight;
  }

  static Color secondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? secondaryDark : secondaryLight;
  }

  static Color error(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? errorDark : errorLight;
  }

  static Color success(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? successDark : successLight;
  }

  static Color warning(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? warningDark : warningLight;
  }
}

