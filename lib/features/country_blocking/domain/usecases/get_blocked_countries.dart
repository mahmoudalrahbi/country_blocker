import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/blocked_country.dart';
import '../repositories/country_blocking_repository.dart';

/// Use case for retrieving all blocked countries
class GetBlockedCountries implements UseCase<List<BlockedCountry>, NoParams> {
  final CountryBlockingRepository repository;

  GetBlockedCountries(this.repository);

  @override
  Future<Either<Failure, List<BlockedCountry>>> call(NoParams params) async {
    return await repository.getBlockedCountries();
  }
}
