import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/telemetry/failure_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sanitizeFailure — type labels', () {
    test('CacheFailure maps to type "CacheFailure"', () {
      final result = sanitizeFailure(const CacheFailure('some message'));
      expect(result.type, 'CacheFailure');
    });

    test('PermissionFailure maps to type "PermissionFailure"', () {
      final result = sanitizeFailure(const PermissionFailure('denied'));
      expect(result.type, 'PermissionFailure');
    });

    test('ValidationFailure maps to type "ValidationFailure"', () {
      final result = sanitizeFailure(const ValidationFailure('bad input'));
      expect(result.type, 'ValidationFailure');
    });

    test('ServerFailure maps to type "ServerFailure"', () {
      final result = sanitizeFailure(const ServerFailure('network error'));
      expect(result.type, 'ServerFailure');
    });
  });

  group('sanitizeFailure — safe message output', () {
    test('CacheFailure returns the static default message', () {
      final result = sanitizeFailure(const CacheFailure());
      expect(result.message, 'Failed to access local storage');
    });

    test('PermissionFailure returns the static default message', () {
      final result = sanitizeFailure(const PermissionFailure());
      expect(result.message, 'Permission denied');
    });

    test('message output never contains phone-number-like patterns', () {
      const phoneNumbers = [
        '+1 555 123 4567',
        '00966501234567',
        '+44 7911 123456',
      ];
      for (final number in phoneNumbers) {
        final result = sanitizeFailure(CacheFailure(number));
        expect(
          result.message,
          isNot(contains(RegExp(r'\d{6,}'))),
          reason: 'phone number "$number" must not appear in sanitized output',
        );
      }
    });

    test('message output never contains an arbitrary runtime string', () {
      final result = sanitizeFailure(const CacheFailure('SENSITIVE RUNTIME DATA 999'));
      expect(result.message, isNot(contains('SENSITIVE RUNTIME DATA 999')));
    });
  });
}
