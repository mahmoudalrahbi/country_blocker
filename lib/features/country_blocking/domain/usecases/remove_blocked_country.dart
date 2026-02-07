import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/country_blocking_repository.dart';

/// Parameters for removing a blocked country
class RemoveBlockedCountryParams extends Equatable {
  final String phoneCode;

  const RemoveBlockedCountryParams({required this.phoneCode});

  @override
  List<Object> get props => [phoneCode];
}

/// Use case for removing a country from the blocklist
class RemoveBlockedCountry implements UseCase<void, RemoveBlockedCountryParams> {
  final CountryBlockingRepository repository;

  RemoveBlockedCountry(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveBlockedCountryParams params) async {
    return await repository.removeBlockedCountry(params.phoneCode);
  }
}
