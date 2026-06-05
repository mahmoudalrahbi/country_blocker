import 'dart:convert';

import 'package:country_blocker/core/telemetry/calls_blocked_harvester.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'analytics_service_test.mocks.dart';

void main() {
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockAnalytics = MockAnalyticsService();
    when(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')))
        .thenAnswer((_) async {});
  });

  List<Map<String, dynamic>> makeLogs(List<String> countryCodes) => [
        for (int i = 0; i < countryCodes.length; i++)
          {
            'phoneNumber': '+1234567890',
            'countryName': 'Test',
            'countryCode': countryCodes[i],
            'reason': 0,
            'timestamp': DateTime(2026, 1, i + 1).toIso8601String(),
          },
      ];

  group('harvest — correct per-country counts', () {
    test('single country emits one event with count 1', () async {
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(makeLogs(['IN'])),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      final captured = verify(
        mockAnalytics.logEvent('calls_blocked', parameters: captureAnyNamed('parameters')),
      ).captured;
      expect(captured.single, {'country_code': 'IN', 'count': 1});
    });

    test('two different countries emit two events', () async {
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(makeLogs(['IN', 'US'])),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      final verif = verify(
        mockAnalytics.logEvent('calls_blocked', parameters: captureAnyNamed('parameters')),
      );
      expect(verif.callCount, 2);
    });

    test('same country appearing 3 times emits one event with count 3', () async {
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(makeLogs(['RU', 'RU', 'RU'])),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      final captured = verify(
        mockAnalytics.logEvent('calls_blocked', parameters: captureAnyNamed('parameters')),
      ).captured;
      expect(captured.single, {'country_code': 'RU', 'count': 3});
    });
  });

  group('harvest — watermark dedup', () {
    test('watermark equal to log count emits zero events', () async {
      final logs = makeLogs(['IN', 'US', 'RU']);
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(logs),
        watermark: 3,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      verifyNever(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')));
    });

    test('watermark of 1 with 3 logs only counts the 2 new entries', () async {
      final logs = makeLogs(['IN', 'RU', 'RU']);
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(logs),
        watermark: 1,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      final captured = verify(
        mockAnalytics.logEvent('calls_blocked', parameters: captureAnyNamed('parameters')),
      ).captured;
      expect(captured.single, {'country_code': 'RU', 'count': 2});
    });

    test('watermark is updated to new total after harvest', () async {
      int capturedWatermark = 0;
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(makeLogs(['IN', 'US'])),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (w) async => capturedWatermark = w,
      );

      expect(capturedWatermark, 2);
    });

    test('empty log list emits no events', () async {
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode([]),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      verifyNever(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')));
    });
  });

  group('privacy — phone numbers never in events', () {
    test('event parameters never contain a phone number string', () async {
      final logs = [
        {
          'phoneNumber': '+1 555 123 4567',
          'countryName': 'United States',
          'countryCode': 'US',
          'reason': 0,
          'timestamp': DateTime(2026, 1, 1).toIso8601String(),
        }
      ];
      await CallsBlockedHarvester.harvest(
        nativeLogsJson: jsonEncode(logs),
        watermark: 0,
        analytics: mockAnalytics,
        onWatermarkUpdate: (_) async {},
      );

      final captured = verify(
        mockAnalytics.logEvent('calls_blocked', parameters: captureAnyNamed('parameters')),
      ).captured;
      final params = captured.single as Map<String, Object>;
      expect(params.values.map((v) => v.toString()).join(), isNot(contains('+1 555 123 4567')));
    });
  });
}
