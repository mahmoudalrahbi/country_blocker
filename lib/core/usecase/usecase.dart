import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base class for all use cases in the application
/// Type parameter Type is the return type of the use case
/// Type parameter Params is the input parameters type
abstract class UseCase<Type, Params> {
  /// Call method to execute the use case
  /// Returns Either<Failure, Type> where:
  /// - Left side contains Failure if operation failed
  /// - Right side contains Type if operation succeeded
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this class when a use case doesn't need any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
