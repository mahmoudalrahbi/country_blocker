import 'package:country_blocker/core/error/exceptions.dart';
import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/features/country_blocking/data/datasources/country_blocking_local_data_source.dart';
import 'package:country_blocker/features/country_blocking/data/models/blocked_country_model.dart';
import 'package:country_blocker/features/country_blocking/data/repositories/country_blocking_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'country_blocking_repository_impl_test.mocks.dart';

@GenerateMocks([CountryBlockingLocalDataSource])
void main() {
  late CountryBlockingRepositoryImpl repository;
  late MockCountryBlockingLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCountryBlockingLocalDataSource();
    repository = CountryBlockingRepositoryImpl(localDataSource: mockLocalDataSource);
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
  });
}
