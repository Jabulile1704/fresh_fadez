// Some palette values currently coincide with Material's own defaults (white
// surfaces, white `onPrimary`). They are still written out explicitly so that
// the palette stays the single source of truth — change `AppColors.surface`
// and the theme follows, rather than silently keeping Material's default.
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

import 'constants.dart';

/// The app's themes, derived entirely from [AppColors].
///
/// The previous version of this file defined a careful olive palette in
/// `constants.dart` and then ignored it, overriding the colour scheme with a
/// bright green (`ARGB(255, 107, 246, 92)`), a brown secondary and an orange
/// tertiary, and setting `primaryColor` to `ARGB(96, 31, 139, 7)` — an
/// accidentally semi-transparent colour. Nothing here hardcodes a colour: the
/// palette is the single source of truth, so changing it changes the app.
class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => _base(
    const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
    ),
    scaffoldBackground: AppColors.background,
    fieldFill: AppColors.inputBackground,
    hint: AppColors.textHint,
  );

  static ThemeData get darkTheme => _base(
    const ColorScheme.dark(
      primary: AppColors.oliveLight,
      onPrimary: AppColors.backgroundDark,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.backgroundDark,
      tertiary: AppColors.accent,
      onTertiary: AppColors.backgroundDark,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.borderDark,
    ),
    scaffoldBackground: AppColors.backgroundDark,
    fieldFill: AppColors.inputBackgroundDark,
    hint: AppColors.textHintDark,
  );

  /// Shared component styling, so light and dark cannot drift apart.
  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffoldBackground,
    required Color fieldFill,
    required Color hint,
  }) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffoldBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: AppFontSize.title,
        fontWeight: AppFontWeight.semiBold,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fieldFill,
      hintStyle: TextStyle(color: hint),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.medium,
      ),
      border: _fieldBorder(scheme.outline),
      enabledBorder: _fieldBorder(scheme.outline),
      focusedBorder: _fieldBorder(scheme.primary, width: 2),
      errorBorder: _fieldBorder(scheme.error),
      focusedErrorBorder: _fieldBorder(scheme.error, width: 2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.primary.withValues(
          alpha: AppOpacity.disabled,
        ),
        minimumSize: const Size.fromHeight(AppButtonStyles.secondaryHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(
          color: scheme.primary,
          width: AppButtonStyles.borderWidth,
        ),
        minimumSize: const Size.fromHeight(AppButtonStyles.secondaryHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: scheme.primary),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: fieldFill,
      selectedColor: scheme.primary,
      labelStyle: TextStyle(color: scheme.onSurface),
      secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.circle),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.onSurface,
      contentTextStyle: TextStyle(color: scheme.surface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: color, width: width),
      );
}
