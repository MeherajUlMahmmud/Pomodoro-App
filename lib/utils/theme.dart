import 'package:flutter/material.dart';
import 'package:pomodoro/utils/colors.dart';

ThemeData createTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF527E5C),
      brightness: Brightness.light,
    ),
    primarySwatch: createMaterialColor(const Color(0xFF527E5C)),
    primaryColor: const Color(0xFF527E5C),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF527E5C),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: const Color(0xFF527E5C).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey[600],
      suffixIconColor: const Color(0xFF527E5C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFF527E5C),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF527E5C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF527E5C),
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFF527E5C).withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF527E5C),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );
}
