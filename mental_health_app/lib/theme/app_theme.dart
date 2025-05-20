import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color sageGreen = Color(0xFF9CAF88);
  static const Color lavender = Color(0xFFE6E6FA);
  static const Color mutedBlue = Color(0xFFB0C4DE);
  static const Color lightSage = Color(0xFFD4E0D0);
  static const Color darkSage = Color(0xFF7A8B6F);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: sageGreen,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: sageGreen,
        secondary: lavender,
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red.shade300,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontFamily: 'Nunito',
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontFamily: 'Nunito',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sageGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSage.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sageGreen, width: 2),
        ),
      ),
    );
  }
} 