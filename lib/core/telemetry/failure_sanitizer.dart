import '../error/failures.dart';

/// Maps a [Failure] to a (type, message) pair safe for off-device reporting.
/// The message is always a static string — never derived from runtime user
/// input, so phone numbers and blocklist data can never leak.
({String type, String message}) sanitizeFailure(Failure failure) {
  return switch (failure) {
    CacheFailure() => (
        type: 'CacheFailure',
        message: 'Failed to access local storage',
      ),
    PermissionFailure() => (
        type: 'PermissionFailure',
        message: 'Permission denied',
      ),
    ValidationFailure() => (
        type: 'ValidationFailure',
        message: 'Validation failed',
      ),
    ServerFailure() => (
        type: 'ServerFailure',
        message: 'Server error occurred',
      ),
    _ => (
        type: 'UnknownFailure',
        message: 'An unexpected error occurred',
      ),
  };
}
