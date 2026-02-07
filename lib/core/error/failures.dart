import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Failures represent expected errors that should be handled gracefully
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure when caching/retrieving data from local storage fails
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Failed to access local storage'])
      : super(message);
}

/// Failure when permission operations fail
class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'Permission denied'])
      : super(message);
}

/// Generic server failure (for future API integration)
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

/// Validation failure for business logic validation
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
