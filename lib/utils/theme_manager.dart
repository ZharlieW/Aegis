import 'package:flutter/material.dart';
import 'package:aegis/utils/local_storage.dart';

/// Theme manager for handling dark mode and theme preferences
class ThemeManager {
  static const String _themeModeKey = 'theme_mode';
  static ThemeMode _themeMode = ThemeMode.system;
  static final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Get current theme mode
  static ThemeMode get themeMode => _themeMode;

  /// Get theme notifier for listening to theme changes
  static ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;

  /// Initialize theme mode from local storage
  static Future<void> init() async {
    try {
      final savedMode = LocalStorage.get(_themeModeKey);
      if (savedMode != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => ThemeMode.system,
        );
        _themeNotifier.value = _themeMode;
      }
    } catch (e) {
      // If error occurs, use system default
      _themeMode = ThemeMode.system;
      _themeNotifier.value = _themeMode;
    }
  }

  /// Set theme mode and save to local storage
  static Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _themeNotifier.value = mode;
    await LocalStorage.set(_themeModeKey, mode.toString());
  }

  /// Toggle between light and dark mode
  static Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // If system, check current brightness and toggle
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Check if dark mode is currently active
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

