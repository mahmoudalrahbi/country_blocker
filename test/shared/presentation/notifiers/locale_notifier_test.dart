import 'dart:ui';

import 'package:country_blocker/core/providers/locale_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../core/telemetry/analytics_service_test.mocks.dart';
import '../../../features/country_blocking/data/datasources/country_blocking_local_data_source_test.mocks.dart';

void main() {
  late MockAnalyticsService mockAnalytics;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockAnalytics = MockAnalyticsService();
    mockPrefs = MockSharedPreferences();
    when(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')))
        .thenAnswer((_) async {});
    when(mockPrefs.getString(any)).thenReturn(null);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
  });

  LocaleNotifier buildNotifier() =>
      LocaleNotifier(mockPrefs, analytics: mockAnalytics);

  group('language_changed event', () {
    test('setLocale(en) emits language_changed with language_code=en', () async {
      // Start in 'ar' so the guard doesn't short-circuit the 'en' change
      when(mockPrefs.getString(any)).thenReturn('ar');
      final notifier = buildNotifier();

      await notifier.setLocale(const Locale('en'));

      verify(mockAnalytics.logEvent(
        'language_changed',
        parameters: {'language_code': 'en'},
      )).called(1);
    });

    test('setLocale(ar) emits language_changed with language_code=ar', () async {
      final notifier = buildNotifier();

      await notifier.setLocale(const Locale('ar'));

      verify(mockAnalytics.logEvent(
        'language_changed',
        parameters: {'language_code': 'ar'},
      )).called(1);
    });

    test('setLocale with same locale emits no event', () async {
      when(mockPrefs.getString(any)).thenReturn('en');
      final notifier = buildNotifier();

      await notifier.setLocale(const Locale('en'));

      verifyNever(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')));
    });

    test('no PII in language_code parameter', () async {
      final notifier = buildNotifier();
      await notifier.setLocale(const Locale('ar'));

      final captured = verify(mockAnalytics.logEvent(
        'language_changed',
        parameters: captureAnyNamed('parameters'),
      )).captured;
      final params = captured.single as Map<String, Object>;
      for (final v in params.values) {
        expect(v.toString(), isNot(matches(RegExp(r'\d{7,}'))));
        expect(v.toString(), isNot(contains('+')));
      }
    });
  });
}
