import 'package:country_blocker/shared/presentation/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';
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

  ThemeNotifier buildNotifier() =>
      ThemeNotifier(mockPrefs, analytics: mockAnalytics);

  group('theme_changed event', () {
    test('setThemeMode(light) emits theme_changed with theme=light', () async {
      final notifier = buildNotifier();

      await notifier.setThemeMode(ThemeMode.light);

      verify(mockAnalytics.logEvent(
        'theme_changed',
        parameters: {'theme': 'light'},
      )).called(1);
    });

    test('setThemeMode(dark) emits theme_changed with theme=dark', () async {
      final notifier = buildNotifier();

      await notifier.setThemeMode(ThemeMode.dark);

      verify(mockAnalytics.logEvent(
        'theme_changed',
        parameters: {'theme': 'dark'},
      )).called(1);
    });

    test('setThemeMode(system) emits theme_changed with theme=system', () async {
      final notifier = buildNotifier();

      await notifier.setThemeMode(ThemeMode.system);

      verify(mockAnalytics.logEvent(
        'theme_changed',
        parameters: {'theme': 'system'},
      )).called(1);
    });

    test('no PII in theme parameter', () async {
      final notifier = buildNotifier();
      await notifier.setThemeMode(ThemeMode.dark);

      final captured = verify(mockAnalytics.logEvent(
        'theme_changed',
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
