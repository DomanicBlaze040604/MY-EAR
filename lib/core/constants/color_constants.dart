import 'package:flutter/material.dart';

/// ColorConstants provides a centralized color system for the app,
/// with special consideration for accessibility and contrast ratios.
class ColorConstants {
  // Base Brand Colors
  static const Color primary = Color(
    0xFF2196F3,
  ); // Main brand color - WCAG AAA compliant
  static const Color secondary = Color(0xFF03DAC6); // Secondary brand color
  static const Color accent = Color(0xFF536DFE); // Accent color for highlights

  // Semantic Status Colors
  static const Color error = Color(
    0xFFB00020,
  ); // Error state - High contrast red
  static const Color success = Color(
    0xFF4CAF50,
  ); // Success state - Accessible green
  static const Color warning = Color(0xFFFFA000); // Warning state - Clear amber
  static const Color info = Color(
    0xFF2196F3,
  ); // Information state - Matching primary

  // Background Colors
  static const Color background = Color(
    0xFFF5F5F5,
  ); // Main background - Light grey
  static const Color surface = Color(0xFFFFFFFF); // Surface color - Pure white
  static const Color cardBackground = Color(0xFFFFFFFF); // Card background
  static const Color modalBackground = Color(0xFFFAFAFA); // Modal background
  static const Color tooltipBackground = Color(
    0xFF616161,
  ); // Tooltip background

  // Text Colors - Following WCAG 2.1 Guidelines
  static const Color textPrimary = Color(
    0xFF000000,
  ); // Primary text - Maximum contrast
  static const Color textSecondary = Color(
    0xFF666666,
  ); // Secondary text - AA compliant
  static const Color textHint = Color(0xFF999999); // Hint text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Text on primary color
  static const Color textDisabled = Color(0xFFAAAAAA); // Disabled text
  static const Color textLink = Color(0xFF1976D2); // Link text - AA compliant

  // Border and Divider Colors
  static const Color border = Color(0xFFE0E0E0); // Standard border
  static const Color divider = Color(0xFFBDBDBD); // List dividers
  static const Color focusBorder = Color(0xFF1E88E5); // Focus state border

  // High Contrast Mode Colors
  static const Color highContrastLight = Color(
    0xFFFFFFFF,
  ); // High contrast light
  static const Color highContrastDark = Color(0xFF000000); // High contrast dark
  static const Color highContrastAccent = Color(
    0xFFFF4081,
  ); // High contrast accent

  // Accessibility-Specific Colors
  static const Color accessibilityFocus = Color(0xFFFFEB3B); // Focus indicators
  static const Color accessibilitySelection = Color(
    0xFF64B5F6,
  ); // Selection highlight
  static const Color accessibilityAnnouncement = Color(
    0xFFE1F5FE,
  ); // Announcement background

  // Interactive Element Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDisabled = Color(0xFFBDBDBD);
  static const Color toggleActive = success;
  static const Color toggleInactive = Color(0xFF9E9E9E);

  // Elevation Colors
  static const Color shadowLight = Color(0x1F000000); // Light shadow
  static const Color shadowMedium = Color(0x3D000000); // Medium shadow
  static const Color shadowDark = Color(0x52000000); // Dark shadow

  // Color Utilities
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Accessibility Helper Methods
  static bool isHighContrast(Color background, Color foreground) {
    // Calculate relative luminance
    double bl = _getLuminance(background);
    double fl = _getLuminance(foreground);

    // Calculate contrast ratio
    double ratio = (Math.max(bl, fl) + 0.05) / (Math.min(bl, fl) + 0.05);

    // WCAG 2.1 Level AAA requires a contrast ratio of at least 7:1
    return ratio >= 7;
  }

  static double _getLuminance(Color color) {
    // Convert color to relative luminance using WCAG formula
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;

    r = r <= 0.03928 ? r / 12.92 : Math.pow((r + 0.055) / 1.055, 2.4);
    g = g <= 0.03928 ? g / 12.92 : Math.pow((g + 0.055) / 1.055, 2.4);
    b = b <= 0.03928 ? b / 12.92 : Math.pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  // Theme Color Schemes
  static ColorScheme get lightScheme => const ColorScheme(
    primary: primary,
    secondary: secondary,
    surface: surface,
    background: background,
    error: error,
    onPrimary: textOnPrimary,
    onSecondary: textOnPrimary,
    onSurface: textPrimary,
    onBackground: textPrimary,
    onError: textOnPrimary,
    brightness: Brightness.light,
  );

  static ColorScheme get darkScheme => const ColorScheme(
    primary: primary,
    secondary: secondary,
    surface: Color(0xFF121212),
    background: Color(0xFF121212),
    error: error,
    onPrimary: textOnPrimary,
    onSecondary: textOnPrimary,
    onSurface: Color(0xFFFFFFFF),
    onBackground: Color(0xFFFFFFFF),
    onError: textOnPrimary,
    brightness: Brightness.dark,
  );
}
