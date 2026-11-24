import 'package:flutter/material.dart';

// App Info
const String appName = 'Fresh Fadez';
const String appVersion = '1.0.0';

/// The app's palette: a single greyscale ramp, no hue anywhere.
///
/// This replaced an olive-and-beige palette. The rule that matters most:
/// [grey600] is the lightest grey allowed to carry words (5.25:1 on white).
/// [grey400] is for hairlines, disabled states and struck-through slots only.
///
/// Because there is no accent colour, state is carried by *fill and weight*
/// rather than hue — solid black is confirmed, outlined is pending, grey is
/// unavailable. That survives colour-blindness and direct sunlight, which a
/// green/amber/red scheme does not.
class AppColors {
  const AppColors._();

  // The ramp
  static const Color black = Color(0xFF0A0A0A);
  static const Color grey900 = Color(0xFF3A3A3A);
  static const Color grey600 = Color(0xFF6B6B6B);
  static const Color grey400 = Color(0xFFABABAB);
  static const Color grey200 = Color(0xFFE4E4E4);
  static const Color grey150 = Color(0xFFEFEFEF);
  static const Color grey100 = Color(0xFFF0F0F0);
  static const Color grey50 = Color(0xFFF7F7F7);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic — light
  static const Color primary = black;
  static const Color onPrimary = white;
  static const Color background = white;
  static const Color surface = white;
  static const Color surfaceMuted = grey50;
  static const Color textPrimary = black;
  static const Color textSecondary = grey600;
  static const Color textDisabled = grey400;
  static const Color border = grey200;
  static const Color divider = grey150;

  // Semantic — dark
  static const Color primaryDark = white;
  static const Color onPrimaryDark = black;
  static const Color backgroundDark = black;
  static const Color surfaceDark = Color(0xFF161616);
  static const Color surfaceMutedDark = Color(0xFF202020);
  static const Color textPrimaryDark = white;
  static const Color textSecondaryDark = Color(0xFFACACAC);
  static const Color textDisabledDark = Color(0xFF6E6E6E);
  static const Color borderDark = Color(0xFF2A2A2A);
  static const Color dividerDark = Color(0xFF242424);

  // Frosted glass — the bottom navigation and the sticky action bars.
  static const Color glassFillLight = Color(0xADFFFFFF); // white @ 68%
  static const Color glassFillDark = Color(0x9E202020); // #202020 @ 62%
  static const Color glassBorderLight = Color(0x170A0A0A); // black @ 9%
  static const Color glassBorderDark = Color(0x24FFFFFF); // white @ 14%

  /// There is no error hue. An error reads through an icon, a heavier border
  /// and bold text — never colour alone, which would fail WCAG 1.4.1 anyway.
  static const Color error = black;
  static const Color errorDark = white;

  static const Color shadow = Color(0xFF0A0A0A);
}

// Spacing
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double xlarge = 32;
  static const double xxlarge = 48;

  /// Clearance every scrollable screen leaves at the bottom so its last row
  /// is not trapped under the floating glass bar.
  static const double navClearance = 118;
}

// Border Radius
class AppRadius {
  const AppRadius._();

  static const double small = 8;
  static const double medium = 14;
  static const double large = 18;
  static const double xlarge = 22;
  static const double pill = 999;
}

// Font Sizes
class AppFontSize {
  const AppFontSize._();

  static const double tiny = 10;
  static const double caption = 11;
  static const double small = 12.5;
  static const double label = 13;
  static const double body = 15;
  static const double subtitle = 16;
  static const double title = 19;
  static const double heading = 27;
  static const double display = 34;
}

// Font Weights
class AppFontWeight {
  const AppFontWeight._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

// Animation Durations
class AppDuration {
  const AppDuration._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
}

/// The frosted-glass recipe, in one place so the bottom bar and the sticky
/// action bars cannot drift apart.
class AppGlass {
  const AppGlass._();

  static const double blurSigma = 18;
  static const double barHeight = 66;
  static const double sideInset = 18;
  static const double bottomInset = 20;

  /// How far the centre book button rises above the bar.
  static const double bookButtonLift = 22;
  static const double bookButtonSize = 54;
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0F0A0A0A), blurRadius: 12, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> glassBar = [
    BoxShadow(color: Color(0x260A0A0A), blurRadius: 34, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> raisedButton = [
    BoxShadow(color: Color(0x570A0A0A), blurRadius: 20, offset: Offset(0, 7)),
  ];
}

class AppButtonStyles {
  const AppButtonStyles._();

  static const double primaryHeight = 56;
  static const double secondaryHeight = 52;
  static const double smallHeight = 40;
  static const double borderWidth = 1.5;
}

// Service Categories
class ServiceCategories {
  const ServiceCategories._();

  static const List<String> categories = [
    'Hair Services',
    'Skincare',
    'Nails',
    'Makeup',
  ];
}

// Appointment Status
class AppointmentStatus {
  const AppointmentStatus._();

  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String noShow = 'no_show';
}

// Messages
class AppMessages {
  const AppMessages._();

  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String bookingSuccess = 'Appointment booked';
  static const String selectService = 'Choose a service first';
  static const String selectTime = 'Choose a time first';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
}

// Validation Patterns
class ValidationPatterns {
  const ValidationPatterns._();

  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,}$';
  static const String namePattern = r'^[a-zA-Z\s]{2,}$';
}

// Opacity Values
class AppOpacity {
  const AppOpacity._();

  static const double disabled = 0.4;
  static const double pressed = 0.7;
}
