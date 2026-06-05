import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/telemetry/analytics_service.dart';
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
  AnalyticsService,
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
  late MockAnalyticsService mockAnalytics;

  setUp(() {
    mockGetBlockedCountries = MockGetBlockedCountries();
    mockGetGlobalBlockingStatus = MockGetGlobalBlockingStatus();
    mockGetBlockedCallsCount = MockGetBlockedCallsCount();
    mockAddBlockedCountry = MockAddBlockedCountry();
    mockRemoveBlockedCountry = MockRemoveBlockedCountry();
    mockToggleCountryBlocking = MockToggleCountryBlocking();
    mockToggleGlobalBlocking = MockToggleGlobalBlocking();
    mockIncrementBlockedCalls = MockIncrementBlockedCalls();
    mockAnalytics = MockAnalyticsService();
    when(mockAnalytics.logEvent(any, parameters: anyNamed('parameters')))
        .thenAnswer((_) async {});
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
      analytics: mockAnalytics,
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

  group('removeCountry', () {
    void setUpInitMocks() {
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right(tBlockedCountries));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(true));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
    }

    test('should call RemoveBlockedCountry and reload countries on success', () async {
      // arrange
      setUpInitMocks();
      when(mockRemoveBlockedCountry(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.removeCountry('1');

      // assert
      verify(mockRemoveBlockedCountry(const RemoveBlockedCountryParams(phoneCode: '1')));
      verify(mockGetBlockedCountries(NoParams())).called(2);
    });

    test('should set error state when RemoveBlockedCountry fails', () async {
      // arrange
      setUpInitMocks();
      when(mockRemoveBlockedCountry(any))
          .thenAnswer((_) async => const Left(CacheFailure('Remove error')));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.removeCountry('1');

      // assert
      expect(notifier.state.errorMessage, 'Remove error');
    });
  });

  group('toggleCountry', () {
    void setUpInitMocks() {
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right(tBlockedCountries));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(true));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
    }

    test('should call ToggleCountryBlocking and reload countries on success', () async {
      // arrange
      setUpInitMocks();
      when(mockToggleCountryBlocking(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.toggleCountry('1', false);

      // assert
      verify(mockToggleCountryBlocking(
        const ToggleCountryBlockingParams(phoneCode: '1', isEnabled: false),
      ));
      verify(mockGetBlockedCountries(NoParams())).called(2);
    });

    test('should set error state when ToggleCountryBlocking fails', () async {
      // arrange
      setUpInitMocks();
      when(mockToggleCountryBlocking(any))
          .thenAnswer((_) async => const Left(CacheFailure('Toggle error')));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.toggleCountry('1', false);

      // assert
      expect(notifier.state.errorMessage, 'Toggle error');
    });
  });

  group('toggleGlobalBlocking', () {
    void setUpInitMocks({bool initialStatus = false}) {
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([]));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => Right(initialStatus));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
    }

    test('should flip isBlockingActive from false to true on success', () async {
      // arrange
      setUpInitMocks(initialStatus: false);
      when(mockToggleGlobalBlocking(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      expect(notifier.state.isBlockingActive, false);

      // act
      await notifier.toggleGlobalBlocking();

      // assert
      expect(notifier.state.isBlockingActive, true);
      expect(notifier.state.errorMessage, isNull);
    });

    test('should flip isBlockingActive from true to false on success', () async {
      // arrange
      setUpInitMocks(initialStatus: true);
      when(mockToggleGlobalBlocking(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      expect(notifier.state.isBlockingActive, true);

      // act
      await notifier.toggleGlobalBlocking();

      // assert
      expect(notifier.state.isBlockingActive, false);
    });

    test('should set error state and not flip status when ToggleGlobalBlocking fails', () async {
      // arrange
      setUpInitMocks(initialStatus: false);
      when(mockToggleGlobalBlocking(any))
          .thenAnswer((_) async => const Left(CacheFailure('Toggle error')));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.toggleGlobalBlocking();

      // assert
      expect(notifier.state.isBlockingActive, false);
      expect(notifier.state.errorMessage, 'Toggle error');
    });
  });

  group('incrementBlockedCallsCount', () {
    void setUpInitMocks({int initialCount = 0}) {
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([]));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(false));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => Right(initialCount));
    }

    test('should increment blockedCallsCount in state on success', () async {
      // arrange
      setUpInitMocks(initialCount: 5);
      when(mockIncrementBlockedCalls(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      expect(notifier.state.blockedCallsCount, 5);

      // act
      await notifier.incrementBlockedCallsCount();

      // assert
      expect(notifier.state.blockedCallsCount, 6);
    });

    test('should not update error state when IncrementBlockedCalls fails (silent)', () async {
      // arrange
      setUpInitMocks(initialCount: 3);
      when(mockIncrementBlockedCalls(any))
          .thenAnswer((_) async => const Left(CacheFailure('Increment error')));
      setUpNotifier();
      await Future.delayed(Duration.zero);

      // act
      await notifier.incrementBlockedCallsCount();

      // assert
      expect(notifier.state.blockedCallsCount, 3); // unchanged
      expect(notifier.state.errorMessage, isNull);  // silently fails
    });
  });

  group('clearError', () {
    test('should clear error message from state', () async {
      // arrange
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Left(CacheFailure('Some error')));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(false));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      expect(notifier.state.errorMessage, isNotNull);

      // act
      notifier.clearError();

      // assert
      expect(notifier.state.errorMessage, isNull);
    });
  });

  group('analytics events', () {
    void setUpInitMocksForAnalytics() {
      when(mockGetBlockedCountries(any))
          .thenAnswer((_) async => const Right([tBlockedCountry]));
      when(mockGetGlobalBlockingStatus(any))
          .thenAnswer((_) async => const Right(false));
      when(mockGetBlockedCallsCount(any))
          .thenAnswer((_) async => const Right(0));
    }

    test('addCountry fires country_added event with ISO code on success', () async {
      setUpInitMocksForAnalytics();
      when(mockAddBlockedCountry(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      clearInteractions(mockAnalytics);

      await notifier.addCountry(
        const AddBlockedCountryParams(country: tBlockedCountry),
      );

      verify(mockAnalytics.logEvent('country_added',
          parameters: {'country_code': 'US'})).called(1);
    });

    test('addCountry does not fire event on failure', () async {
      setUpInitMocksForAnalytics();
      when(mockAddBlockedCountry(any))
          .thenAnswer((_) async => const Left(CacheFailure()));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      clearInteractions(mockAnalytics);

      await notifier.addCountry(
        const AddBlockedCountryParams(country: tBlockedCountry),
      );

      verifyNever(mockAnalytics.logEvent('country_added',
          parameters: anyNamed('parameters')));
    });

    test('toggleGlobalBlocking fires global_blocking_toggled with new enabled value', () async {
      setUpInitMocksForAnalytics();
      when(mockToggleGlobalBlocking(any))
          .thenAnswer((_) async => const Right(null));
      setUpNotifier();
      await Future.delayed(Duration.zero);
      clearInteractions(mockAnalytics);

      await notifier.toggleGlobalBlocking();

      verify(mockAnalytics.logEvent('global_blocking_toggled',
          parameters: {'enabled': true})).called(1);
    });

    test('logLogsScreenOpened fires logs_screen_opened event', () async {
      setUpInitMocksForAnalytics();
      setUpNotifier();
      await Future.delayed(Duration.zero);
      clearInteractions(mockAnalytics);

      notifier.logLogsScreenOpened();

      verify(mockAnalytics.logEvent('logs_screen_opened',
          parameters: anyNamed('parameters'))).called(1);
    });
  });
}
