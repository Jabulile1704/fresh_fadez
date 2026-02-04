import 'package:flutter/material.dart';

// App Info
const String appName = 'HairSalon Pro';
const String appVersion = '1.0.0';

// Colors
class AppColors {
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFFEC4899);
  static const Color accent = Color(0xFF06B6D4);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
}

// Spacing
class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
}

// Border Radius
class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
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
  static const String welcomeBack = 'Welcome Back';
  static const String loginToContinue = 'Login to your account';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully';
  static const String bookingSuccess = 'Appointment booked successfully!';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
}

class Validators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validates password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}