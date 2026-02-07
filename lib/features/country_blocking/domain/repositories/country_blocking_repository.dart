import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/blocked_country.dart';

/// Repository interface for country blocking operations
/// This is a contract that data layer must implement
/// Domain layer depends on this abstraction, not concrete implementations
abstract class CountryBlockingRepository {
  /// Get all blocked countries from local storage
  Future<Either<Failure, List<BlockedCountry>>> getBlockedCountries();

  /// Add a new country to the blocklist
  Future<Either<Failure, void>> addBlockedCountry(BlockedCountry country);

  /// Remove a country from the blocklist by phone code
  Future<Either<Failure, void>> removeBlockedCountry(String phoneCode);

  /// Toggle blocking status for a specific country
  Future<Either<Failure, void>> toggleCountryBlocking(
    String phoneCode,
    bool isEnabled,
  );

  /// Get the global blocking enabled/disabled status
  Future<Either<Failure, bool>> getGlobalBlockingStatus();

  /// Toggle global blocking on/off
  Future<Either<Failure, void>> toggleGlobalBlocking();

  /// Get the count of blocked calls
  Future<Either<Failure, int>> getBlockedCallsCount();

  /// Increment the blocked calls counter
  Future<Either<Failure, void>> incrementBlockedCalls();
}
