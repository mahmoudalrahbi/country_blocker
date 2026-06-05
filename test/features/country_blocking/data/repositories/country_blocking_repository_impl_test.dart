import 'package:country_blocker/core/error/exceptions.dart';
import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/telemetry/crash_reporter.dart';
import 'package:country_blocker/features/country_blocking/data/datasources/country_blocking_local_data_source.dart';
import 'package:country_blocker/features/country_blocking/data/models/blocked_country_model.dart';
import 'package:country_blocker/features/country_blocking/data/repositories/country_blocking_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'country_blocking_repository_impl_test.mocks.dart';

@GenerateMocks([CountryBlockingLocalDataSource, CrashReporter])
void main() {
  late CountryBlockingRepositoryImpl repository;
  late MockCountryBlockingLocalDataSource mockLocalDataSource;
  late MockCrashReporter mockCrashReporter;

  setUp(() {
    mockLocalDataSource = MockCountryBlockingLocalDataSource();
    mockCrashReporter = MockCrashReporter();
    when(mockCrashReporter.recordNonFatal(any, any)).thenAnswer((_) async {});
    repository = CountryBlockingRepositoryImpl(
      localDataSource: mockLocalDataSource,
      crashReporter: mockCrashReporter,
    );
  });

  const tBlockedCountryModel = BlockedCountryModel(
    name: 'Test Country',
    phoneCode: '1',
    isoCode: 'US',
  );

  final tBlockedCountry = BlockedCountryModel.fromEntity(tBlockedCountryModel);

  group('getBlockedCountries', () {
    test('should return list of BlockedCountry when cached data is present', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => [tBlockedCountryModel]);
      // act
      final result = await repository.getBlockedCountries();
      // assert
      verify(mockLocalDataSource.getCachedBlockedCountries());
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r, [tBlockedCountryModel]),
      );
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenThrow(CacheException('Error'));
      // act
      final result = await repository.getBlockedCountries();
      // assert
      verify(mockLocalDataSource.getCachedBlockedCountries());
      expect(result, equals(const Left(CacheFailure('Error'))));
    });
  });

  group('addBlockedCountry', () {
    test('should cache updated list of blocked countries', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => []);
      when(mockLocalDataSource.cacheBlockedCountries(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.addBlockedCountry(tBlockedCountry);
      // assert
      verify(mockLocalDataSource.getCachedBlockedCountries());
      verify(mockLocalDataSource.cacheBlockedCountries([tBlockedCountryModel]));
      expect(result, equals(const Right(null)));
    });
  });

  group('removeBlockedCountry', () {
    test('should remove country and cache updated list', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => [tBlockedCountryModel]);
      when(mockLocalDataSource.cacheBlockedCountries(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.removeBlockedCountry('1');
      // assert
      verify(mockLocalDataSource.getCachedBlockedCountries());
      verify(mockLocalDataSource.cacheBlockedCountries([]));
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when data source throws', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenThrow(CacheException('Remove error'));
      // act
      final result = await repository.removeBlockedCountry('1');
      // assert
      expect(result, equals(const Left(CacheFailure('Remove error'))));
    });
  });

  group('toggleCountryBlocking', () {
    test('should update isEnabled for matching country and cache updated list', () async {
      // arrange
      final disabledModel = tBlockedCountryModel.copyWith(isEnabled: false);
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => [disabledModel]);
      when(mockLocalDataSource.cacheBlockedCountries(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.toggleCountryBlocking('1', true);
      // assert
      final expectedModel = disabledModel.copyWith(isEnabled: true);
      verify(mockLocalDataSource.getCachedBlockedCountries());
      verify(mockLocalDataSource.cacheBlockedCountries([expectedModel]));
      expect(result, equals(const Right(null)));
    });

    test('should not modify countries with non-matching phone code', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => [tBlockedCountryModel]);
      when(mockLocalDataSource.cacheBlockedCountries(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.toggleCountryBlocking('999', false);
      // assert
      verify(mockLocalDataSource.cacheBlockedCountries([tBlockedCountryModel]));
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when data source throws', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenThrow(CacheException('Toggle error'));
      // act
      final result = await repository.toggleCountryBlocking('1', true);
      // assert
      expect(result, equals(const Left(CacheFailure('Toggle error'))));
    });
  });

  group('getGlobalBlockingStatus', () {
    test('should return status from data source', () async {
      // arrange
      when(mockLocalDataSource.getGlobalBlockingStatus())
          .thenAnswer((_) async => true);
      // act
      final result = await repository.getGlobalBlockingStatus();
      // assert
      verify(mockLocalDataSource.getGlobalBlockingStatus());
      expect(result, equals(const Right(true)));
    });

    test('should return CacheFailure when data source throws', () async {
      // arrange
      when(mockLocalDataSource.getGlobalBlockingStatus())
          .thenThrow(CacheException('Status error'));
      // act
      final result = await repository.getGlobalBlockingStatus();
      // assert
      expect(result, equals(const Left(CacheFailure('Status error'))));
    });
  });

  group('toggleGlobalBlocking', () {
    test('should read current status, negate it, and cache the new value', () async {
      // arrange
      when(mockLocalDataSource.getGlobalBlockingStatus())
          .thenAnswer((_) async => false);
      when(mockLocalDataSource.cacheGlobalBlockingStatus(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.toggleGlobalBlocking();
      // assert
      verify(mockLocalDataSource.getGlobalBlockingStatus());
      verify(mockLocalDataSource.cacheGlobalBlockingStatus(true));
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when data source throws on read', () async {
      // arrange
      when(mockLocalDataSource.getGlobalBlockingStatus())
          .thenThrow(CacheException('Toggle error'));
      // act
      final result = await repository.toggleGlobalBlocking();
      // assert
      expect(result, equals(const Left(CacheFailure('Toggle error'))));
    });
  });

  group('getBlockedCallsCount', () {
    test('should return count from data source', () async {
      // arrange
      when(mockLocalDataSource.getBlockedCallsCount())
          .thenAnswer((_) async => 7);
      // act
      final result = await repository.getBlockedCallsCount();
      // assert
      verify(mockLocalDataSource.getBlockedCallsCount());
      expect(result, equals(const Right(7)));
    });

    test('should return CacheFailure when data source throws', () async {
      // arrange
      when(mockLocalDataSource.getBlockedCallsCount())
          .thenThrow(CacheException('Count error'));
      // act
      final result = await repository.getBlockedCallsCount();
      // assert
      expect(result, equals(const Left(CacheFailure('Count error'))));
    });
  });

  group('incrementBlockedCalls', () {
    test('should read current count, increment by 1, and cache new value', () async {
      // arrange
      when(mockLocalDataSource.getBlockedCallsCount())
          .thenAnswer((_) async => 4);
      when(mockLocalDataSource.cacheBlockedCallsCount(any))
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.incrementBlockedCalls();
      // assert
      verify(mockLocalDataSource.getBlockedCallsCount());
      verify(mockLocalDataSource.cacheBlockedCallsCount(5));
      expect(result, equals(const Right(null)));
    });

    test('should return CacheFailure when data source throws on read', () async {
      // arrange
      when(mockLocalDataSource.getBlockedCallsCount())
          .thenThrow(CacheException('Increment error'));
      // act
      final result = await repository.incrementBlockedCalls();
      // assert
      expect(result, equals(const Left(CacheFailure('Increment error'))));
    });
  });

  group('Non-fatal reporting on Failure paths', () {
    test('reports CacheFailure as Non-fatal with sanitized type and message', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenThrow(CacheException('raw detail that must not leak'));
      // act
      await repository.getBlockedCountries();
      // assert — type is correct, no raw exception detail in the message
      final captured = verify(
        mockCrashReporter.recordNonFatal(captureAny, captureAny),
      ).captured;
      expect(captured[0], 'CacheFailure');
      expect(captured[1], isNot(contains('raw detail that must not leak')));
    });

    test('does not report a Non-fatal on success paths', () async {
      // arrange
      when(mockLocalDataSource.getCachedBlockedCountries())
          .thenAnswer((_) async => []);
      // act
      await repository.getBlockedCountries();
      // assert
      verifyNever(mockCrashReporter.recordNonFatal(any, any));
    });
  });
}
