import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
      primaryColor: const Color.fromARGB(96, 31, 139, 7),
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 107, 246, 92),
        secondary: const Color.fromARGB(255, 103, 55, 1),
        tertiary: const Color.fromARGB(255, 248, 133, 2),
        error: AppColors.error,
        surface: AppColors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppFontSize.title,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.divider,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 21, 65, 8),
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(96, 31, 139, 7),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
    );
  }
}
