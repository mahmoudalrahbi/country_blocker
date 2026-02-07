import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/blocked_country.dart';
import '../repositories/country_blocking_repository.dart';

/// Parameters for adding a blocked country
class AddBlockedCountryParams extends Equatable {
  final BlockedCountry country;

  const AddBlockedCountryParams({required this.country});

  @override
  List<Object> get props => [country];
}

/// Use case for adding a new country to the blocklist
class AddBlockedCountry implements UseCase<void, AddBlockedCountryParams> {
  final CountryBlockingRepository repository;

  AddBlockedCountry(this.repository);

  @override
  Future<Either<Failure, void>> call(AddBlockedCountryParams params) async {
    // Business logic: Validate that country is not already in the list
    final countriesResult = await repository.getBlockedCountries();

    return countriesResult.fold(
      (failure) => Left(failure),
      (countries) async {
        // Check if country already exists
        final exists = countries.any(
          (c) => c.phoneCode == params.country.phoneCode,
        );

        if (exists) {
          return const Left(
            ValidationFailure('This country is already in the blocklist'),
          );
        }

        // Add the country
        return await repository.addBlockedCountry(params.country);
      },
    );
  }
}
