import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/entities/blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/add_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_countries.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/increment_blocked_calls.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/remove_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_country_blocking.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_global_blocking.dart';
import 'package:country_blocker/features/country_blocking/presentation/notifiers/country_blocking_notifier.dart';
import 'package:country_blocker/features/country_blocking/presentation/notifiers/country_blocking_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'country_blocking_notifier_test.mocks.dart';

@GenerateMocks([
  GetBlockedCountries,
  AddBlockedCountry,
  RemoveBlockedCountry,
  ToggleCountryBlocking,
  ToggleGlobalBlocking,
  IncrementBlockedCalls,
])
void main() {
  late CountryBlockingNotifier notifier;
  late MockGetBlockedCountries mockGetBlockedCountries;
  late MockAddBlockedCountry mockAddBlockedCountry;
  late MockRemoveBlockedCountry mockRemoveBlockedCountry;
  late MockToggleCountryBlocking mockToggleCountryBlocking;
  late MockToggleGlobalBlocking mockToggleGlobalBlocking;
  late MockIncrementBlockedCalls mockIncrementBlockedCalls;

  setUp(() {
    mockGetBlockedCountries = MockGetBlockedCountries();
    mockAddBlockedCountry = MockAddBlockedCountry();
    mockRemoveBlockedCountry = MockRemoveBlockedCountry();
    mockToggleCountryBlocking = MockToggleCountryBlocking();
    mockToggleGlobalBlocking = MockToggleGlobalBlocking();
    mockIncrementBlockedCalls = MockIncrementBlockedCalls();
  });

  void setUpNotifier() {
    notifier = CountryBlockingNotifier(
      getBlockedCountries: mockGetBlockedCountries,
      addBlockedCountry: mockAddBlockedCountry,
      removeBlockedCountry: mockRemoveBlockedCountry,
      toggleCountryBlocking: mockToggleCountryBlocking,
      toggleGlobalBlocking: mockToggleGlobalBlocking,
      incrementBlockedCalls: mockIncrementBlockedCalls,
    );
  }

  const tBlockedCountry = BlockedCountry(
    name: 'Test Country',
    phoneCode: '1',
    isoCode: 'US',
  );
  
  const tBlockedCountries = [tBlockedCountry];

  test('initial state should be correct', () {
    // arrange
    when(mockGetBlockedCountries(any))
        .thenAnswer((_) async => const Right([]));
    
    // act
    setUpNotifier();
    
    // assert
    expect(notifier.state, equals(CountryBlockingState.initial()));
  });

  group('loadBlockedCountries', () {
    test('should update state with blocked countries when success', () async {
      // arrange
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right(tBlockedCountries));
      
      setUpNotifier();
      
      // act
      await notifier.loadBlockedCountries();
      
      // assert
      expect(notifier.state.isLoading, false);
      expect(notifier.state.blockedCountries, tBlockedCountries);
    });

    test('should update state with error message when failure', () async {
      // arrange
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Left(CacheFailure('Error')));
      
      setUpNotifier();
      
      // act
      await notifier.loadBlockedCountries();
      
      // assert
      expect(notifier.state.errorMessage, 'Error');
    });
  });

  group('addCountry', () {
    test('should call AddBlockedCountry and reload countries', () async {
      // arrange
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([]));
      when(mockAddBlockedCountry(any))
          .thenAnswer((_) async => const Right(null));
      
      setUpNotifier();
      
      // act
      await notifier.addCountry(const AddBlockedCountryParams(country: tBlockedCountry));
      
      // assert
      verify(mockAddBlockedCountry(const AddBlockedCountryParams(country: tBlockedCountry)));
      verify(mockGetBlockedCountries(NoParams())).called(2); // Once in init, once in reload
    });
  });
}
