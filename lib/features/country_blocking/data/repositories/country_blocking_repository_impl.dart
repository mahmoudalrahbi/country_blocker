import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/blocked_country.dart';
import '../../domain/repositories/country_blocking_repository.dart';
import '../datasources/country_blocking_local_data_source.dart';
import '../models/blocked_country_model.dart';

/// Implementation of CountryBlockingRepository
/// Handles data operations and converts exceptions to failures
class CountryBlockingRepositoryImpl implements CountryBlockingRepository {
  final CountryBlockingLocalDataSource localDataSource;

  CountryBlockingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BlockedCountry>>> getBlockedCountries() async {
    try {
      final countries = await localDataSource.getCachedBlockedCountries();
      return Right(countries);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addBlockedCountry(
    BlockedCountry country,
  ) async {
    try {
      // Get current countries
      final countries = await localDataSource.getCachedBlockedCountries();

      // Add new country
      final updatedCountries = [
        ...countries,
        BlockedCountryModel.fromEntity(country),
      ];

      // Save updated list
      await localDataSource.cacheBlockedCountries(updatedCountries);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBlockedCountry(String phoneCode) async {
    try {
      // Get current countries
      final countries = await localDataSource.getCachedBlockedCountries();

      // Remove country with matching phone code
      final updatedCountries = countries
          .where((c) => c.phoneCode != phoneCode)
          .toList();

      // Save updated list
      await localDataSource.cacheBlockedCountries(updatedCountries);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleCountryBlocking(
    String phoneCode,
    bool isEnabled,
  ) async {
    try {
      // Get current countries
      final countries = await localDataSource.getCachedBlockedCountries();

      // Find and update the country
      final updatedCountries = countries.map((country) {
        if (country.phoneCode == phoneCode) {
          return country.copyWith(isEnabled: isEnabled);
        }
        return country;
      }).toList();

      // Save updated list
      await localDataSource.cacheBlockedCountries(updatedCountries);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getGlobalBlockingStatus() async {
    try {
      final status = await localDataSource.getGlobalBlockingStatus();
      return Right(status);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleGlobalBlocking() async {
    try {
      // Get current status
      final currentStatus = await localDataSource.getGlobalBlockingStatus();

      // Toggle it
      final newStatus = !currentStatus;

      // Save new status
      await localDataSource.cacheGlobalBlockingStatus(newStatus);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getBlockedCallsCount() async {
    try {
      final count = await localDataSource.getBlockedCallsCount();
      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> incrementBlockedCalls() async {
    try {
      // Get current count
      final currentCount = await localDataSource.getBlockedCallsCount();

      // Increment it
      final newCount = currentCount + 1;

      // Save new count
      await localDataSource.cacheBlockedCallsCount(newCount);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
