import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart';

/// Provider for the current locale of the application.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  static const _localeKey = 'app_locale';

  LocaleNotifier(this._prefs) : super(_initialLocale(_prefs));

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
  }
}
