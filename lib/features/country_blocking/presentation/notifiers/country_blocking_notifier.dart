import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_blocked_country.dart';
import '../../domain/usecases/get_blocked_countries.dart';
import '../../domain/usecases/increment_blocked_calls.dart';
import '../../domain/usecases/remove_blocked_country.dart';
import '../../domain/usecases/toggle_country_blocking.dart';
import '../../domain/usecases/toggle_global_blocking.dart';
import 'country_blocking_state.dart';

/// StateNotifier for managing country blocking state
/// This is the presentation layer business logic
class CountryBlockingNotifier extends StateNotifier<CountryBlockingState> {
  final GetBlockedCountries _getBlockedCountries;
  final AddBlockedCountry _addBlockedCountry;
  final RemoveBlockedCountry _removeBlockedCountry;
  final ToggleCountryBlocking _toggleCountryBlocking;
  final ToggleGlobalBlocking _toggleGlobalBlocking;
  final IncrementBlockedCalls _incrementBlockedCalls;

  CountryBlockingNotifier({
    required GetBlockedCountries getBlockedCountries,
    required AddBlockedCountry addBlockedCountry,
    required RemoveBlockedCountry removeBlockedCountry,
    required ToggleCountryBlocking toggleCountryBlocking,
    required ToggleGlobalBlocking toggleGlobalBlocking,
    required IncrementBlockedCalls incrementBlockedCalls,
  })  : _getBlockedCountries = getBlockedCountries,
        _addBlockedCountry = addBlockedCountry,
        _removeBlockedCountry = removeBlockedCountry,
        _toggleCountryBlocking = toggleCountryBlocking,
        _toggleGlobalBlocking = toggleGlobalBlocking,
        _incrementBlockedCalls = incrementBlockedCalls,
        super(CountryBlockingState.initial()) {
    // Load initial data
    loadBlockedCountries();
  }

  /// Load blocked countries from repository
  Future<void> loadBlockedCountries() async {
    state = CountryBlockingState.loading(state);

    final result = await _getBlockedCountries(NoParams());

    result.fold(
      (failure) => state = CountryBlockingState.error(state, failure.message),
      (countries) => state = state.copyWith(
        blockedCountries: countries,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  /// Add a new country to the blocklist
  Future<void> addCountry(AddBlockedCountryParams params) async {
    final result = await _addBlockedCountry(params);

    result.fold(
      (failure) => state = CountryBlockingState.error(state, failure.message),
      (_) {
        // Reload countries after adding
        loadBlockedCountries();
      },
    );
  }

  /// Remove a country from the blocklist
  Future<void> removeCountry(String phoneCode) async {
    final result = await _removeBlockedCountry(
      RemoveBlockedCountryParams(phoneCode: phoneCode),
    );

    result.fold(
      (failure) => state = CountryBlockingState.error(state, failure.message),
      (_) {
        // Reload countries after removing
        loadBlockedCountries();
      },
    );
  }

  /// Toggle blocking status for a specific country
  Future<void> toggleCountry(String phoneCode, bool isEnabled) async {
    final result = await _toggleCountryBlocking(
      ToggleCountryBlockingParams(
        phoneCode: phoneCode,
        isEnabled: isEnabled,
      ),
    );

    result.fold(
      (failure) => state = CountryBlockingState.error(state, failure.message),
      (_) {
        // Reload countries after toggling
        loadBlockedCountries();
      },
    );
  }

  /// Toggle global blocking on/off
  Future<void> toggleGlobalBlocking() async {
    final result = await _toggleGlobalBlocking(NoParams());

    result.fold(
      (failure) => state = CountryBlockingState.error(state, failure.message),
      (_) {
        // Toggle the state
        state = state.copyWith(
          isBlockingActive: !state.isBlockingActive,
          errorMessage: null,
        );
      },
    );
  }

  /// Increment the blocked calls counter
  Future<void> incrementBlockedCallsCount() async {
    final result = await _incrementBlockedCalls(NoParams());

    result.fold(
      (failure) {
        // Silently fail for counter increment
        // Don't update state with error as this is a background operation
      },
      (_) {
        // Increment the count in state
        state = state.copyWith(
          blockedCallsCount: state.blockedCallsCount + 1,
        );
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
