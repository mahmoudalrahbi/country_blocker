import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/analytics_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  final AnalyticsService _analytics;
  static const String _themeKey = 'theme_mode';

  ThemeNotifier(this._prefs, {AnalyticsService? analytics})
      : _analytics = analytics ?? NoOpAnalyticsService(),
        super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          state = ThemeMode.light;
          break;
        case 'dark':
          state = ThemeMode.dark;
          break;
        case 'system':
          state = ThemeMode.system;
          break;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await _prefs.setString(_themeKey, modeString);
    await _analytics.logEvent('theme_changed', parameters: {'theme': modeString});
  }
}

/// Provider for the ThemeMode
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs, analytics: ref.watch(analyticsServiceProvider));
});
