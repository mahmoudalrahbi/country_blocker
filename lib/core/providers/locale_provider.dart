import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart';
import '../telemetry/analytics_service.dart';

/// Provider for the current locale of the application.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs, analytics: ref.watch(analyticsServiceProvider));
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  final AnalyticsService _analytics;
  static const _localeKey = 'app_locale';

  LocaleNotifier(this._prefs, {AnalyticsService? analytics})
      : _analytics = analytics ?? NoOpAnalyticsService(),
        super(_initialLocale(_prefs));

  static Locale _initialLocale(SharedPreferences prefs) {
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    // Default to system locale if supported, otherwise English
    final systemLocale = PlatformDispatcher.instance.locale;
    if (systemLocale.languageCode == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    await _analytics.logEvent(
      'language_changed',
      parameters: {'language_code': locale.languageCode},
    );
  }
}
