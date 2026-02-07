/// Base class for all exceptions in the data layer
/// Exceptions represent unexpected errors that should be caught and converted to Failures
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when permission operations fail
class PermissionException implements Exception {
  final String message;

  PermissionException([this.message = 'Permission error occurred']);

  @override
  String toString() => 'PermissionException: $message';
}

/// Generic server exception (for future API integration)
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}
