import 'package:country_blocker/core/telemetry/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'analytics_service_test.mocks.dart';

@GenerateMocks([AnalyticsService])
void main() {
  group('NoOpAnalyticsService', () {
    late AnalyticsService service;

    setUp(() => service = NoOpAnalyticsService());

    test('logEvent completes without error', () async {
      await expectLater(
        service.logEvent('test_event'),
        completes,
      );
    });

    test('logEvent with parameters completes without error', () async {
      await expectLater(
        service.logEvent('test_event', parameters: {'country_code': 'US'}),
        completes,
      );
    });

    test('setEnabled completes without error', () async {
      await expectLater(service.setEnabled(false), completes);
      await expectLater(service.setEnabled(true), completes);
    });
  });

  group('AnalyticsService (mock — contract used by callers)', () {
    late MockAnalyticsService mockService;

    setUp(() {
      mockService = MockAnalyticsService();
      when(mockService.logEvent(any, parameters: anyNamed('parameters')))
          .thenAnswer((_) async {});
      when(mockService.setEnabled(any)).thenAnswer((_) async {});
    });

    test('logEvent is called with the correct name', () async {
      await mockService.logEvent('country_added', parameters: {'country_code': 'IN'});
      verify(mockService.logEvent('country_added', parameters: {'country_code': 'IN'}))
          .called(1);
    });

    test('setEnabled is called with false when disabling', () async {
      await mockService.setEnabled(false);
      verify(mockService.setEnabled(false)).called(1);
    });
  });

  group('ConsentGatedAnalyticsService', () {
    late MockAnalyticsService mockDelegate;
    late ConsentGatedAnalyticsService service;

    setUp(() {
      mockDelegate = MockAnalyticsService();
      when(mockDelegate.logEvent(any, parameters: anyNamed('parameters')))
          .thenAnswer((_) async {});
      when(mockDelegate.setEnabled(any)).thenAnswer((_) async {});
    });

    test('when enabled, forwards logEvent to delegate', () async {
      service = ConsentGatedAnalyticsService(mockDelegate, enabled: true);
      await service.logEvent('test_event', parameters: {'k': 'v'});
      verify(mockDelegate.logEvent('test_event', parameters: {'k': 'v'})).called(1);
    });

    test('when disabled, logEvent is a no-op — delegate never called', () async {
      service = ConsentGatedAnalyticsService(mockDelegate, enabled: false);
      await service.logEvent('test_event');
      verifyNever(mockDelegate.logEvent(any, parameters: anyNamed('parameters')));
    });

    test('setEnabled(false) disables logging and calls delegate.setEnabled(false)', () async {
      service = ConsentGatedAnalyticsService(mockDelegate, enabled: true);
      await service.setEnabled(false);
      verify(mockDelegate.setEnabled(false)).called(1);
      // subsequent logEvent is now no-op
      await service.logEvent('after_disable');
      verifyNever(mockDelegate.logEvent('after_disable', parameters: anyNamed('parameters')));
    });

    test('setEnabled(true) re-enables logging and calls delegate.setEnabled(true)', () async {
      service = ConsentGatedAnalyticsService(mockDelegate, enabled: false);
      await service.setEnabled(true);
      verify(mockDelegate.setEnabled(true)).called(1);
      // subsequent logEvent is forwarded
      await service.logEvent('after_enable');
      verify(mockDelegate.logEvent('after_enable', parameters: anyNamed('parameters'))).called(1);
    });
  });
}
