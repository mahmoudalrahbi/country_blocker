import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/country_blocking_repository.dart';

/// Parameters for toggling country blocking status
class ToggleCountryBlockingParams extends Equatable {
  final String phoneCode;
  final bool isEnabled;

  const ToggleCountryBlockingParams({
    required this.phoneCode,
    required this.isEnabled,
  });

  @override
  List<Object> get props => [phoneCode, isEnabled];
}

/// Use case for enabling/disabling blocking for a specific country
class ToggleCountryBlocking
    implements UseCase<void, ToggleCountryBlockingParams> {
  final CountryBlockingRepository repository;

  ToggleCountryBlocking(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleCountryBlockingParams params) async {
    return await repository.toggleCountryBlocking(
      params.phoneCode,
      params.isEnabled,
    );
  }
}
