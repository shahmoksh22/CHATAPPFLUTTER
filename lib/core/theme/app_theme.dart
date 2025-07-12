import 'package:flutter/material.dart';

/// Defines the application's light and dark themes using Material 3 design principles.
///
/// This class provides static [ThemeData] objects for consistent theming
/// across the application.
class AppTheme {
  /// Returns the light theme data for the application.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      brightness: Brightness.light,
    );
  }

  /// Returns the dark theme data for the application.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, brightness: Brightness.dark),
      brightness: Brightness.dark,
    );
  }
}
