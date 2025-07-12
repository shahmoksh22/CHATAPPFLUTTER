import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [ChangeNotifier] that manages the application's theme mode.
///
/// This provider allows switching between light, dark, and system default themes,
/// and persists the user's theme preference using [SharedPreferences].
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// The currently selected theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Constructs a [ThemeProvider] and loads the saved theme mode.
  ThemeProvider() {
    _loadThemeMode();
  }

  /// Loads the theme mode preference from [SharedPreferences].
  ///
  /// If no preference is saved, it defaults to [ThemeMode.system].
  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Sets the application's theme mode to the given [mode] and saves the preference.
  ///
  /// Notifies listeners of the change.
  void setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', mode.toString().split('.').last);
      notifyListeners();
    }
  }
}
