import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/entities/blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/add_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_calls_count.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_countries.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_global_blocking_status.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/increment_blocked_calls.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/remove_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_country_blocking.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_global_blocking.dart';
import 'package:country_blocker/features/country_blocking/presentation/notifiers/country_blocking_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'country_blocking_notifier_test.mocks.dart';

@GenerateMocks([
  GetBlockedCountries,
  GetGlobalBlockingStatus,
  GetBlockedCallsCount,
  AddBlockedCountry,
  RemoveBlockedCountry,
  ToggleCountryBlocking,
  ToggleGlobalBlocking,
  IncrementBlockedCalls,
])
void main() {
  late CountryBlockingNotifier notifier;
  late MockGetBlockedCountries mockGetBlockedCountries;
  late MockGetGlobalBlockingStatus mockGetGlobalBlockingStatus;
  late MockGetBlockedCallsCount mockGetBlockedCallsCount;
  late MockAddBlockedCountry mockAddBlockedCountry;
  late MockRemoveBlockedCountry mockRemoveBlockedCountry;
  late MockToggleCountryBlocking mockToggleCountryBlocking;
  late MockToggleGlobalBlocking mockToggleGlobalBlocking;
  late MockIncrementBlockedCalls mockIncrementBlockedCalls;

  setUp(() {
    mockGetBlockedCountries = MockGetBlockedCountries();
    mockGetGlobalBlockingStatus = MockGetGlobalBlockingStatus();
    mockGetBlockedCallsCount = MockGetBlockedCallsCount();
    mockAddBlockedCountry = MockAddBlockedCountry();
    mockRemoveBlockedCountry = MockRemoveBlockedCountry();
    mockToggleCountryBlocking = MockToggleCountryBlocking();
    mockToggleGlobalBlocking = MockToggleGlobalBlocking();
    mockIncrementBlockedCalls = MockIncrementBlockedCalls();
  });

  void setUpNotifier() {
    notifier = CountryBlockingNotifier(
      getBlockedCountries: mockGetBlockedCountries,
      getGlobalBlockingStatus: mockGetGlobalBlockingStatus,
      getBlockedCallsCount: mockGetBlockedCallsCount,
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

  test('loadInitialState should populate state correctly on startup', () async {
    // arrange
    when(mockGetBlockedCountries(any))
        .thenAnswer((_) async => const Right(tBlockedCountries));
    when(mockGetGlobalBlockingStatus(any))
        .thenAnswer((_) async => const Right(false));
    when(mockGetBlockedCallsCount(any))
        .thenAnswer((_) async => const Right(15));
    
    // act
    setUpNotifier();
    // Wait for the async initialization to complete
    await Future.delayed(Duration.zero);
    
    // assert
    expect(notifier.state.isLoading, false);
    expect(notifier.state.blockedCountries, tBlockedCountries);
    expect(notifier.state.isBlockingActive, false);
    expect(notifier.state.blockedCallsCount, 15);
  });

  test('loadInitialState should set error if any usecase fails', () async {
    // arrange
    when(mockGetBlockedCountries(any))
        .thenAnswer((_) async => const Right(tBlockedCountries));
    when(mockGetGlobalBlockingStatus(any))
        .thenAnswer((_) async => const Right(false));
    // Simulate failure on getBlockedCallsCount
    when(mockGetBlockedCallsCount(any))
        .thenAnswer((_) async => const Left(CacheFailure('Database Error')));
    
    // act
    setUpNotifier();
    await Future.delayed(Duration.zero);
    
    // assert
    expect(notifier.state.errorMessage, 'Database Error');
    // It should still populate the rest of the valid state
    expect(notifier.state.blockedCountries, tBlockedCountries);
    expect(notifier.state.isBlockingActive, false);
  });

  group('loadBlockedCountries', () {
    test('should update state with blocked countries when success', () async {
      // arrange
      // Initial mock answers for constructor
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([]));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(true));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
      
      setUpNotifier();
      await Future.delayed(Duration.zero);
      
      // Update mock answer for explicit load call
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right(tBlockedCountries));
      
      // act
      await notifier.loadBlockedCountries();
      
      // assert
      expect(notifier.state.isLoading, false);
      expect(notifier.state.blockedCountries, tBlockedCountries);
    });

    test('should update state with error message when failure', () async {
      // arrange
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([]));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(true));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
          
      setUpNotifier();
      await Future.delayed(Duration.zero);
      
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Left(CacheFailure('Error')));
      
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
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(true));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
      when(mockAddBlockedCountry(any))
          .thenAnswer((_) async => const Right(null));
      
      setUpNotifier();
      await Future.delayed(Duration.zero);
      
      // act
      await notifier.addCountry(const AddBlockedCountryParams(country: tBlockedCountry));
      
      // assert
      verify(mockAddBlockedCountry(const AddBlockedCountryParams(country: tBlockedCountry)));
      verify(mockGetBlockedCountries(NoParams())).called(2); // Once in init, once in reload
    });
  });
}
