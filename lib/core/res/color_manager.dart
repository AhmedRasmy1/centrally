import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primaryBlue = Color(0xFF1E4FD8);
  static const Color primaryBlueDark = Color(0xFF1640B0);
  static const Color primaryBlueLight = Color(0xFFE8EEFB);

  // Text
  static const Color darkText = Color(0xFF1A1A2E);
  static const Color bodyText = Color(0xFF6B7280);
  static const Color hintText = Color(0xFF9CA3AF);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // Surface
  static const Color scaffold = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB);
}
