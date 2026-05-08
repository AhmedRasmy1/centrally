import 'package:centrally/core/res/color_manager.dart';
import 'package:centrally/core/res/font_manager.dart';
import 'package:centrally/core/res/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppFontFamily.cairo,
        scaffoldBackgroundColor: AppColors.scaffold,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryBlue,
          onPrimary: AppColors.white,
          secondary: AppColors.primaryBlueDark,
          onSecondary: AppColors.white,
          error: AppColors.error,
          onError: AppColors.white,
          surface: AppColors.surface,
          onSurface: AppColors.darkText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffold,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.darkText),
          titleTextStyle: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s18,
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.darkText,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppSize.s58),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            textStyle: const TextStyle(
              fontFamily: AppFontFamily.cairo,
              fontSize: AppFontSize.s18,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            minimumSize: const Size(double.infinity, AppSize.s58),
            side: const BorderSide(color: AppColors.primaryBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            textStyle: const TextStyle(
              fontFamily: AppFontFamily.cairo,
              fontSize: AppFontSize.s18,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            textStyle: const TextStyle(
              fontFamily: AppFontFamily.cairo,
              fontSize: AppFontSize.s14,
              fontWeight: AppFontWeight.medium,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          hintStyle: const TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s14,
            color: AppColors.hintText,
          ),
          errorStyle: const TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s12,
            color: AppColors.error,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s32,
            fontWeight: AppFontWeight.bold,
            color: AppColors.darkText,
          ),
          titleLarge: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s24,
            fontWeight: AppFontWeight.bold,
            color: AppColors.darkText,
          ),
          titleMedium: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s18,
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.darkText,
          ),
          bodyLarge: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s16,
            fontWeight: AppFontWeight.regular,
            color: AppColors.bodyText,
            height: 1.7,
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s14,
            fontWeight: AppFontWeight.regular,
            color: AppColors.bodyText,
          ),
          bodySmall: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s12,
            fontWeight: AppFontWeight.regular,
            color: AppColors.grey,
          ),
          labelLarge: TextStyle(
            fontFamily: AppFontFamily.cairo,
            fontSize: AppFontSize.s16,
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.darkText,
          ),
        ),
      );
}
