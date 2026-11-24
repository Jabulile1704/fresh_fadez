// Some palette values coincide with Material's own defaults (white surfaces,
// black-on-white). They are still written out explicitly so the palette stays
// the single source of truth — change AppColors and the theme follows.
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

import 'constants.dart';

/// The app's themes, derived entirely from [AppColors].
///
/// Monochrome by design: there is no accent colour in either scheme. Emphasis
/// comes from fill (solid black on white, inverted in dark), weight and
/// spacing instead of hue.
class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => _base(
        const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.black,
          onPrimaryContainer: AppColors.white,
          secondary: AppColors.grey900,
          onSecondary: AppColors.white,
          tertiary: AppColors.grey600,
          onTertiary: AppColors.white,
          error: AppColors.error,
          onError: AppColors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surfaceMuted,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.border,
          outlineVariant: AppColors.divider,
        ),
        scaffoldBackground: AppColors.background,
        fieldFill: AppColors.surface,
        muted: AppColors.surfaceMuted,
        hint: AppColors.textSecondary,
      );

  static ThemeData get darkTheme => _base(
        const ColorScheme.dark(
          primary: AppColors.primaryDark,
          onPrimary: AppColors.onPrimaryDark,
          primaryContainer: AppColors.white,
          onPrimaryContainer: AppColors.black,
          secondary: AppColors.textSecondaryDark,
          onSecondary: AppColors.black,
          tertiary: AppColors.grey400,
          onTertiary: AppColors.black,
          error: AppColors.errorDark,
          onError: AppColors.black,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          surfaceContainerHighest: AppColors.surfaceMutedDark,
          onSurfaceVariant: AppColors.textSecondaryDark,
          outline: AppColors.borderDark,
          outlineVariant: AppColors.dividerDark,
        ),
        scaffoldBackground: AppColors.backgroundDark,
        fieldFill: AppColors.backgroundDark,
        muted: AppColors.surfaceMutedDark,
        hint: AppColors.textSecondaryDark,
      );

  /// Shared component styling, so light and dark cannot drift apart.
  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffoldBackground,
    required Color fieldFill,
    required Color muted,
    required Color hint,
  }) =>
      ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: scaffoldBackground,
        splashFactory: InkSparkle.splashFactory,
        textTheme: _textTheme(scheme),
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldBackground,
          foregroundColor: scheme.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: AppFontSize.title,
            fontWeight: AppFontWeight.semiBold,
            letterSpacing: -0.4,
            color: scheme.onSurface,
          ),
          iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fieldFill,
          hintStyle: TextStyle(color: hint, fontSize: AppFontSize.body),
          labelStyle: TextStyle(color: hint, fontSize: AppFontSize.label),
          floatingLabelStyle: TextStyle(color: scheme.onSurface),
          // No error hue: the error state is read from the heavier border, the
          // icon and the bold message, not from a colour.
          errorStyle: TextStyle(
            color: scheme.error,
            fontSize: AppFontSize.caption,
            fontWeight: AppFontWeight.semiBold,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: 17,
          ),
          border: _fieldBorder(scheme.outline),
          enabledBorder: _fieldBorder(scheme.outline),
          focusedBorder: _fieldBorder(scheme.onSurface, width: 1.5),
          errorBorder: _fieldBorder(scheme.error, width: 1.5),
          focusedErrorBorder: _fieldBorder(scheme.error, width: 2),
          disabledBorder: _fieldBorder(scheme.outlineVariant),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            disabledBackgroundColor: scheme.primary.withValues(
              alpha: AppOpacity.disabled,
            ),
            disabledForegroundColor: scheme.onPrimary,
            elevation: 0,
            minimumSize: const Size.fromHeight(AppButtonStyles.primaryHeight),
            textStyle: const TextStyle(
              fontSize: AppFontSize.subtitle,
              fontWeight: AppFontWeight.semiBold,
            ),
            shape: const StadiumBorder(),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.onSurface,
            side: BorderSide(
              color: scheme.onSurface,
              width: AppButtonStyles.borderWidth,
            ),
            minimumSize: const Size.fromHeight(AppButtonStyles.secondaryHeight),
            textStyle: const TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: AppFontWeight.semiBold,
            ),
            shape: const StadiumBorder(),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: scheme.onSurface,
            textStyle: const TextStyle(
              fontSize: AppFontSize.label,
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: scheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: scheme.outline),
            borderRadius: BorderRadius.circular(AppRadius.xlarge),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: muted,
          selectedColor: scheme.primary,
          labelStyle: TextStyle(
            color: scheme.onSurface,
            fontSize: AppFontSize.label,
            fontWeight: AppFontWeight.semiBold,
          ),
          secondaryLabelStyle: TextStyle(color: scheme.onPrimary),
          side: BorderSide(color: scheme.outline),
          shape: const StadiumBorder(),
        ),
        dividerTheme: DividerThemeData(
          color: scheme.outlineVariant,
          space: 1,
          thickness: 1,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: scheme.onSurface,
          textColor: scheme.onSurface,
          contentPadding: EdgeInsets.zero,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: scheme.onSurface,
          contentTextStyle: TextStyle(
            color: scheme.surface,
            fontSize: AppFontSize.label,
            fontWeight: AppFontWeight.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xlarge),
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: scheme.primary,
          linearTrackColor: scheme.outline,
        ),
      );

  static TextTheme _textTheme(ColorScheme scheme) => TextTheme(
        displaySmall: TextStyle(
          fontSize: AppFontSize.display,
          fontWeight: AppFontWeight.bold,
          letterSpacing: -1.1,
          height: 1.08,
          color: scheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: AppFontSize.heading,
          fontWeight: AppFontWeight.bold,
          letterSpacing: -0.9,
          height: 1.15,
          color: scheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: AppFontSize.title,
          fontWeight: AppFontWeight.semiBold,
          letterSpacing: -0.4,
          color: scheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: AppFontSize.subtitle,
          fontWeight: AppFontWeight.semiBold,
          letterSpacing: -0.2,
          color: scheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: AppFontSize.body,
          fontWeight: AppFontWeight.regular,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: AppFontSize.label,
          fontWeight: AppFontWeight.regular,
          color: scheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: AppFontSize.label,
          fontWeight: AppFontWeight.semiBold,
          color: scheme.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: AppFontSize.small,
          fontWeight: AppFontWeight.medium,
          color: scheme.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: AppFontSize.caption,
          fontWeight: AppFontWeight.semiBold,
          letterSpacing: 0.7,
          color: scheme.onSurfaceVariant,
        ),
      );

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium + 1),
        borderSide: BorderSide(color: color, width: width),
      );
}
