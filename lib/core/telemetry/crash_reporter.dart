abstract class CrashReporter {
  Future<void> recordNonFatal(String type, String message);
}

class NoOpCrashReporter implements CrashReporter {
  @override
  Future<void> recordNonFatal(String type, String message) async {}
}
