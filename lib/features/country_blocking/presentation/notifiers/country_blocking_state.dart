import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/blocked_country.dart';

part 'country_blocking_state.freezed.dart';

/// Immutable state for country blocking feature
/// Using Freezed for immutability and code generation
@freezed
class CountryBlockingState with _$CountryBlockingState {
  const factory CountryBlockingState({
    @Default([]) List<BlockedCountry> blockedCountries,
    @Default(0) int blockedCallsCount,
    @Default(true) bool isBlockingActive,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CountryBlockingState;

  /// Initial state
  factory CountryBlockingState.initial() => const CountryBlockingState(
        isLoading: true,
      );

  /// Loading state
  factory CountryBlockingState.loading(CountryBlockingState current) =>
      current.copyWith(isLoading: true, errorMessage: null);

  /// Success state
  factory CountryBlockingState.success(CountryBlockingState current) =>
      current.copyWith(isLoading: false, errorMessage: null);

  /// Error state
  factory CountryBlockingState.error(
    CountryBlockingState current,
    String message,
  ) =>
      current.copyWith(
        isLoading: false,
        errorMessage: message,
      );
}
