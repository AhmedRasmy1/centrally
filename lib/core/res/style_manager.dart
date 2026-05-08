import 'package:centrally/core/res/color_manager.dart';
import 'package:centrally/core/res/font_manager.dart';
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  // Headings
  static const TextStyle headingXL = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s32,
    fontWeight: AppFontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s24,
    fontWeight: AppFontWeight.bold,
    color: AppColors.darkText,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s20,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.darkText,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s18,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.darkText,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s16,
    fontWeight: AppFontWeight.regular,
    color: AppColors.bodyText,
    height: 1.7,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.regular,
    color: AppColors.bodyText,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s12,
    fontWeight: AppFontWeight.regular,
    color: AppColors.bodyText,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s16,
    fontWeight: AppFontWeight.semiBold,
    color: AppColors.darkText,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.medium,
    color: AppColors.darkText,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s18,
    fontWeight: AppFontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle buttonOutlined = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s18,
    fontWeight: AppFontWeight.bold,
    color: AppColors.primaryBlue,
  );

  // Caption / hint
  static const TextStyle caption = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s12,
    fontWeight: AppFontWeight.regular,
    color: AppColors.grey,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: AppFontFamily.cairo,
    fontSize: AppFontSize.s14,
    fontWeight: AppFontWeight.regular,
    color: AppColors.hintText,
  );
}
