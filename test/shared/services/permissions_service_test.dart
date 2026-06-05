import 'package:country_blocker/core/telemetry/analytics_service.dart';
import 'package:country_blocker/shared/services/permissions_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/telemetry/analytics_service_test.mocks.dart';

/// Testable subclass that replaces platform calls with controllable stubs.
class _FakePermissionsService extends PermissionsService {
  final bool roleResult;
  final bool phoneResult;

  _FakePermissionsService({
    required this.roleResult,
    required this.phoneResult,
    required AnalyticsService analytics,
  }) : super(analytics: analytics);

  @override
  Future<bool> platformCheckRole() async => roleResult;

  @override
  Future<bool> platformRequestPhonePermissions() async => phoneResult;
}

void main() {
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockAnalytics = MockAnalyticsService();
    when(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')))
        .thenAnswer((_) async {});
    when(mockAnalytics.logEvent(any)).thenAnswer((_) async {});
  });

  group('requestRole()', () {
    test('emits permission_role_requested', () async {
      final service = _FakePermissionsService(
        roleResult: true,
        phoneResult: true,
        analytics: mockAnalytics,
      );

      await service.requestRole();

      verify(mockAnalytics.logEvent('permission_role_requested')).called(1);
    });
  });

  group('hasRole()', () {
    test('emits permission_role_granted when platform returns true', () async {
      final service = _FakePermissionsService(
        roleResult: true,
        phoneResult: true,
        analytics: mockAnalytics,
      );

      final result = await service.hasRole();

      expect(result, isTrue);
      verify(mockAnalytics.logEvent('permission_role_granted')).called(1);
      verifyNever(mockAnalytics.logEvent('permission_role_denied'));
    });

    test('emits permission_role_denied when platform returns false', () async {
      final service = _FakePermissionsService(
        roleResult: false,
        phoneResult: true,
        analytics: mockAnalytics,
      );

      final result = await service.hasRole();

      expect(result, isFalse);
      verify(mockAnalytics.logEvent('permission_role_denied')).called(1);
      verifyNever(mockAnalytics.logEvent('permission_role_granted'));
    });
  });

  group('requestPhonePermissions()', () {
    test('emits permission_phone_granted when platform returns true', () async {
      final service = _FakePermissionsService(
        roleResult: true,
        phoneResult: true,
        analytics: mockAnalytics,
      );

      final result = await service.requestPhonePermissions();

      expect(result, isTrue);
      verify(mockAnalytics.logEvent('permission_phone_granted')).called(1);
      verifyNever(mockAnalytics.logEvent('permission_phone_denied'));
    });

    test('emits permission_phone_denied when platform returns false', () async {
      final service = _FakePermissionsService(
        roleResult: true,
        phoneResult: false,
        analytics: mockAnalytics,
      );

      final result = await service.requestPhonePermissions();

      expect(result, isFalse);
      verify(mockAnalytics.logEvent('permission_phone_denied')).called(1);
      verifyNever(mockAnalytics.logEvent('permission_phone_granted'));
    });
  });

  group('no PII in events', () {
    test('event names contain no phone numbers or contact data', () async {
      final logged = <String>[];
      when(mockAnalytics.logEvent(any)).thenAnswer((inv) async {
        logged.add(inv.positionalArguments[0] as String);
      });

      final service = _FakePermissionsService(
        roleResult: true,
        phoneResult: true,
        analytics: mockAnalytics,
      );

      await service.requestRole();
      await service.hasRole();
      await service.requestPhonePermissions();

      expect(logged, isNotEmpty);
      for (final name in logged) {
        expect(name, isNot(contains('+')));
        expect(name, isNot(matches(RegExp(r'\d{7,}'))));
      }
    });
  });
}
