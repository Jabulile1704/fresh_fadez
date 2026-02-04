import 'package:flutter/material.dart';

// App Info
const String appName = 'Fresh_Fadez';
const String appVersion = '1.0.0';

// Colors
class AppColors {
  // Olive Theme Colors
  static const Color primary = Color(0xFF7A9B5C); // Olive Green
  static const Color primaryDark = Color(0xFF6B8B4F); // Dark Olive
  static const Color secondary = Color(0xFF9DAB7A); // Light Olive
  static const Color accent = Color(0xFFB8C870); // Pale Olive
  
  // Background and surfaces
  static const Color background = Color(0xFFF5F3ED); // Warm Beige
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color inputBackground = Color(0xFFF9F8F5); // Light warm beige
  
  // Text colors
  static const Color textPrimary = Color(0xFF3D4A2E); // Dark Olive
  static const Color textSecondary = Color(0xFF8B9B6F); // Medium Olive
  static const Color textHint = Color(0xFFB8C49D); // Light Olive
  
  // Border and dividers
  static const Color border = Color(0xFFD4CAB8); // Olive border
  static const Color borderColor = Color(0xFFE8DFD3); // Olive divider
  static const Color divider = Color(0xFFE8DFD3); // Olive divider
  
  // Status colors
  static const Color error = Color(0xFFE67E22); // Warm Orange
  static const Color success = Color(0xFF6BA85A); // Olive Green
  static const Color warning = Color(0xFFD4A574); // Warm Tan
  static const Color info = Color(0xFF7A9B5C); // Olive Green

  // Olive Shades for FAB & Components
  static const Color oliveDark = Color(0xFF6B8B4F); // Dark Olive
  static const Color oliveMedium = Color(0xFF7A9B5C); // Medium Olive
  static const Color oliveLight = Color(0xFFA5B87A); // Light Olive
  static const Color olivePale = Color(0xFFC5D89E); // Pale Olive
  
  // Additional colors
  static const Color shadow = Color(0x1A3D4A2E); // Shadow
}

// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
  static const double xxlarge = 48.0;
}

// Border Radius
class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 20.0;
  static const double circle = 50.0;
}

// Alternative name for consistency
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 20.0;
  static const double circle = 50.0;
}

// Font Sizes
class AppFontSize {
  static const double tiny = 10.0;
  static const double small = 12.0;
  static const double body = 14.0;
  static const double subtitle = 16.0;
  static const double title = 18.0;
  static const double heading = 24.0;
  static const double largeHeading = 32.0;
  static const double extraLarge = 28.0;
}

// Font Weights
class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

// Animation Durations
class AppDuration {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slowest = Duration(milliseconds: 800);
}

// Service Categories
class ServiceCategories {
  static const List<String> categories = [
    'Haircut',
    'Hair Color',
    'Styling',
    'Treatment',
  ];
}

// Appointment Status
class AppointmentStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

// Messages
class AppMessages {
  // Auth Messages
  static const String welcomeBack = 'Welcome Back';
  static const String loginToContinue = 'Login to your account';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully';
  
  // Booking Messages
  static const String bookingSuccess = 'Appointment booked successfully!';
  static const String bookingError = 'Failed to book appointment';
  static const String selectService = 'Please select a service';
  static const String selectStaff = 'Please select a staff member';
  static const String selectDate = 'Please select a date';
  static const String selectTime = 'Please select a time';
  
  // General Messages
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
  static const String loading = 'Loading...';
  static const String noDataFound = 'No data found';
  static const String tryAgain = 'Try Again';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
}

// Navigation Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String services = '/services';
  static const String staffDetail = '/staff-detail';
  static const String profile = '/profile';
  static const String appointments = '/appointments';
}

// API Endpoints (if needed)
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String services = '/services';
  static const String staff = '/staff';
  static const String bookings = '/bookings';
}

// Validation Patterns
class ValidationPatterns {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9]{10,}$';
  static const String namePattern = r'^[a-zA-Z\s]{2,}$';
}

// Shadow Styles
class AppShadows {
  static final List<BoxShadow> light = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> heavy = [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.16),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

// Gradient Styles
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryDark,
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.secondary,
      AppColors.primary,
    ],
  );

  static LinearGradient accentGradient({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }
}

// Button Styles
class AppButtonStyles {
  static const double primaryHeight = 56.0;
  static const double secondaryHeight = 48.0;
  static const double smallHeight = 40.0;
  static const double borderWidth = 1.5;
}

// Input Decoration Styles
class AppInputStyles {
  static InputDecoration getOutlineInputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      label: Text(label),
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    );
  }
}

// Device Breakpoints
class DeviceBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
}

// Opacity Values
class AppOpacity {
  static const double disabled = 0.5;
  static const double hover = 0.8;
  static const double light = 0.1;
  static const double medium = 0.5;
  static const double heavy = 0.8;
}