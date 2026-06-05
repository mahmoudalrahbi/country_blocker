import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'crash_reporter.dart';

class FirebaseCrashReporter implements CrashReporter {
  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashReporter(this._crashlytics);

  @override
  Future<void> recordNonFatal(String type, String message) {
    return _crashlytics.recordError(
      '$type: $message',
      StackTrace.current,
      fatal: false,
    );
  }
}
