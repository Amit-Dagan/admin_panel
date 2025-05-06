import 'package:flutter/material.dart';

/// Application-wide theme definitions, matching ChatGPT styling.
class AppThemes {
  /// Light (bright) theme.
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF10A37F),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF10A37F),
      onPrimary: Colors.white,
      secondary: Colors.grey,
      onSecondary: Colors.black,
      surfaceVariant: Colors.grey.shade200,
      onSurfaceVariant: Colors.black,
      background: Colors.white,
      onBackground: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, 
        backgroundColor: const Color(0xFF10A37F),
      ),
    ),
  );

  /// Dark theme.
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF10A37F),
    scaffoldBackgroundColor: const Color(0xFF343541),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF343541),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF10A37F),
      onPrimary: Colors.black,
      secondary: Color(0xFF444654),
      onSecondary: Colors.white,
      surfaceVariant: Color(0xFF444654),
      onSurfaceVariant: Colors.white,
      background: Color(0xFF343541),
      onBackground: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF444654),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: const Color(0xFF10A37F),
      ),
    ),
  );
}