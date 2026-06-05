import 'package:country_blocker/core/telemetry/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crash_reporter_test.mocks.dart';

@GenerateMocks([CrashReporter])
void main() {
  group('NoOpCrashReporter', () {
    late CrashReporter reporter;

    setUp(() {
      reporter = NoOpCrashReporter();
    });

    test('recordNonFatal completes without error', () async {
      await expectLater(
        reporter.recordNonFatal('CacheFailure', 'Failed to access local storage'),
        completes,
      );
    });

    test('recordNonFatal can be called multiple times without error', () async {
      await reporter.recordNonFatal('CacheFailure', 'msg1');
      await reporter.recordNonFatal('PermissionFailure', 'msg2');
      await reporter.recordNonFatal('ValidationFailure', 'msg3');
    });
  });

  group('CrashReporter (mock — contract used by collaborators)', () {
    late MockCrashReporter mockReporter;

    setUp(() {
      mockReporter = MockCrashReporter();
      when(mockReporter.recordNonFatal(any, any))
          .thenAnswer((_) async {});
    });

    test('interface accepts type and message strings', () async {
      await mockReporter.recordNonFatal('CacheFailure', 'safe message');
      verify(mockReporter.recordNonFatal('CacheFailure', 'safe message')).called(1);
    });
  });
}
