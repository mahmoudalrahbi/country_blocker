import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/country_blocking/data/datasources/country_blocking_local_data_source.dart';
import '../features/country_blocking/data/datasources/country_blocking_local_data_source_impl.dart';
import '../features/country_blocking/data/repositories/country_blocking_repository_impl.dart';
import '../features/country_blocking/domain/repositories/country_blocking_repository.dart';
import '../features/country_blocking/domain/usecases/add_blocked_country.dart';
import '../features/country_blocking/domain/usecases/get_blocked_countries.dart';
import '../features/country_blocking/domain/usecases/increment_blocked_calls.dart';
import '../features/country_blocking/domain/usecases/remove_blocked_country.dart';
import '../features/country_blocking/domain/usecases/toggle_country_blocking.dart';
import '../features/country_blocking/domain/usecases/toggle_global_blocking.dart';

import '../features/country_blocking/presentation/notifiers/country_blocking_notifier.dart';
import '../features/country_blocking/presentation/notifiers/country_blocking_state.dart';


export '../shared/presentation/notifiers/theme_notifier.dart';
import '../shared/services/permissions_service.dart';

// ==================== External Dependencies ====================

/// SharedPreferences provider
/// This will be overridden in main.dart with the actual instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
});

/// Permissions service provider
final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return PermissionsService();
});

// ==================== Data Sources ====================

/// Country blocking local data source provider
final countryBlockingLocalDataSourceProvider =
    Provider<CountryBlockingLocalDataSource>((ref) {
  return CountryBlockingLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

// ==================== Repositories ====================

/// Country blocking repository provider
final countryBlockingRepositoryProvider =
    Provider<CountryBlockingRepository>((ref) {
  return CountryBlockingRepositoryImpl(
    localDataSource: ref.watch(countryBlockingLocalDataSourceProvider),
  );
});

// ==================== Use Cases ====================

/// Get blocked countries use case provider
final getBlockedCountriesProvider = Provider<GetBlockedCountries>((ref) {
  return GetBlockedCountries(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

/// Add blocked country use case provider
final addBlockedCountryProvider = Provider<AddBlockedCountry>((ref) {
  return AddBlockedCountry(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

/// Remove blocked country use case provider
final removeBlockedCountryProvider = Provider<RemoveBlockedCountry>((ref) {
  return RemoveBlockedCountry(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

/// Toggle country blocking use case provider
final toggleCountryBlockingProvider = Provider<ToggleCountryBlocking>((ref) {
  return ToggleCountryBlocking(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

/// Toggle global blocking use case provider
final toggleGlobalBlockingProvider = Provider<ToggleGlobalBlocking>((ref) {
  return ToggleGlobalBlocking(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

/// Increment blocked calls use case provider
final incrementBlockedCallsProvider = Provider<IncrementBlockedCalls>((ref) {
  return IncrementBlockedCalls(
    ref.watch(countryBlockingRepositoryProvider),
  );
});

// ==================== State Notifiers ====================

/// Country blocking state notifier provider
final countryBlockingNotifierProvider =
    StateNotifierProvider<CountryBlockingNotifier, CountryBlockingState>((ref) {
  return CountryBlockingNotifier(
    getBlockedCountries: ref.watch(getBlockedCountriesProvider),
    addBlockedCountry: ref.watch(addBlockedCountryProvider),
    removeBlockedCountry: ref.watch(removeBlockedCountryProvider),
    toggleCountryBlocking: ref.watch(toggleCountryBlockingProvider),
    toggleGlobalBlocking: ref.watch(toggleGlobalBlockingProvider),
    incrementBlockedCalls: ref.watch(incrementBlockedCallsProvider),
  );
});

// ==================== Convenient State Selectors ====================

/// Provider for blocked countries list
final blockedCountriesProvider = Provider<List>((ref) {
  return ref.watch(countryBlockingNotifierProvider).blockedCountries;
});

/// Provider for blocked calls count
final blockedCallsCountProvider = Provider<int>((ref) {
  return ref.watch(countryBlockingNotifierProvider).blockedCallsCount;
});

/// Provider for global blocking status
final isBlockingActiveProvider = Provider<bool>((ref) {
  return ref.watch(countryBlockingNotifierProvider).isBlockingActive;
});

/// Provider for loading status
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(countryBlockingNotifierProvider).isLoading;
});

/// Provider for error message
final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(countryBlockingNotifierProvider).errorMessage;
});
