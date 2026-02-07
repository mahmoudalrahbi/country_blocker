import '../models/blocked_country_model.dart';

/// Abstract interface for local data source operations
/// This abstraction allows for easier testing and potential future implementations
abstract class CountryBlockingLocalDataSource {
  /// Get cached blocked countries from local storage
  /// Throws [CacheException] if operation fails
  Future<List<BlockedCountryModel>> getCachedBlockedCountries();

  /// Cache blocked countries to local storage
  /// Throws [CacheException] if operation fails
  Future<void> cacheBlockedCountries(List<BlockedCountryModel> countries);

  /// Get global blocking status from local storage
  /// Throws [CacheException] if operation fails
  Future<bool> getGlobalBlockingStatus();

  /// Cache global blocking status to local storage
  /// Throws [CacheException] if operation fails
  Future<void> cacheGlobalBlockingStatus(bool status);

  /// Get blocked calls count from local storage
  /// Throws [CacheException] if operation fails
  Future<int> getBlockedCallsCount();

  /// Cache blocked calls count to local storage
  /// Throws [CacheException] if operation fails
  Future<void> cacheBlockedCallsCount(int count);
}
