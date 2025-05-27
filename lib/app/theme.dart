import 'package:flutter/material.dart';

class AppTheme {
  // Define colors optimized for an investment app
  static const Color primaryColor = Color(
    0xFF00695C,
  ); // Deep teal for trust and stability
  static const Color secondaryColor = Color(
    0xFFF4D03F,
  ); // Soft gold for wealth and optimism
  static const Color accentColor = Color(
    0xFF2ECC71,
  ); // Vibrant green for growth
  static const Color successColor = Color(
    0xFF27AE60,
  ); // Balanced green for positive outcomes
  static const Color errorColor = Color(
    0xFFE74C3C,
  ); // Strong red for errors, high contrast
  static const Color warningColor = Color(
    0xFFF1C40F,
  ); // Warm yellow for cautions
  static const Color infoColor = Color(
    0xFF3498DB,
  ); // Bright blue for information

  // Light theme (unchanged)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(primaryColor),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
    ),
  );

  // Dark theme with darker background
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      surface: Colors.grey[900]!, // Darker background (was Colors.grey[850])
      onPrimary: Colors.white,
      onSecondary: Colors
          .white, // Changed to white for better contrast on darker background
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900]!, // Match app bar to darker surface
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(secondaryColor),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey[600]!,
        ), // Slightly lighter for visibility
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
    ),
    scaffoldBackgroundColor: const Color(
      0xFF1A1A1A,
    ), // Ensure scaffold matches darker surface
  );
}
