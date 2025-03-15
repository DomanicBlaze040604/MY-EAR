import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorConstants.lightScheme,
      brightness: Brightness.light,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.primary,
        foregroundColor: ColorConstants.textOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primary,
          foregroundColor: ColorConstants.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: ColorConstants.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorConstants.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorConstants.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorConstants.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorConstants.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorConstants.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: ColorConstants.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: ColorConstants.textPrimary),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorConstants.textPrimary,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: ColorConstants.surface,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ColorConstants.textPrimary,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorConstants.surface,
        modalBackgroundColor: ColorConstants.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primary,
        foregroundColor: ColorConstants.textOnPrimary,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primary;
          }
          return ColorConstants.textDisabled;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return ColorConstants.primary.withOpacity(0.5);
          }
          return ColorConstants.textDisabled.withOpacity(0.5);
        }),
      ),

      // Accessibility
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ColorConstants.tooltipBackground,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: ColorConstants.textOnPrimary),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorConstants.darkScheme,
      scaffoldBackgroundColor: const Color(0xFF121212),

      // Dark mode specific overrides
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
      ),

      cardTheme: lightTheme.cardTheme.copyWith(color: const Color(0xFF2C2C2C)),

      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: const Color(0xFF2C2C2C),
      ),
    );
  }
}
