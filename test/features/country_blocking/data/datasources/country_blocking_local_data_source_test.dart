import 'dart:convert';
import 'package:country_blocker/core/error/exceptions.dart';
import 'package:country_blocker/features/country_blocking/data/datasources/country_blocking_local_data_source_impl.dart';
import 'package:country_blocker/features/country_blocking/data/models/blocked_country_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'country_blocking_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late CountryBlockingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CountryBlockingLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  const tBlockedCountryModel = BlockedCountryModel(
    name: 'Test Country',
    phoneCode: '1',
    isoCode: 'US',
  );

  group('getCachedBlockedCountries', () {
    test('should return list of BlockedCountryModel when cached data is present', () async {
      // arrange
      final expectedJsonList = [tBlockedCountryModel.toJson()];
      when(mockSharedPreferences.getStringList(any))
          .thenReturn(expectedJsonList);
      // act
      final result = await dataSource.getCachedBlockedCountries();
      // assert
      verify(mockSharedPreferences.getStringList(CountryBlockingLocalDataSourceImpl.kBlockedCountriesKey));
      expect(result, equals([tBlockedCountryModel]));
    });

    test('should return empty list when no cached data is present', () async {
      // arrange
      when(mockSharedPreferences.getStringList(any)).thenReturn(null);
      // act
      final result = await dataSource.getCachedBlockedCountries();
      // assert
      verify(mockSharedPreferences.getStringList(CountryBlockingLocalDataSourceImpl.kBlockedCountriesKey));
      expect(result, equals([]));
    });

    test('should throw CacheException when call to SharedPreferences throws', () async {
      // arrange
      when(mockSharedPreferences.getStringList(any)).thenThrow(Exception());
      // act
      final call = dataSource.getCachedBlockedCountries;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheBlockedCountries', () {
    test('should call SharedPreferences to cache data', () async {
      // arrange
      when(mockSharedPreferences.setStringList(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      await dataSource.cacheBlockedCountries([tBlockedCountryModel]);
      // assert
      final expectedJsonList = [tBlockedCountryModel.toJson()];
      verify(mockSharedPreferences.setStringList(
        CountryBlockingLocalDataSourceImpl.kBlockedCountriesKey,
        expectedJsonList,
      ));
      
      // Also verify the "simple" key used for native access
      final expectedSimpleJson = json.encode([tBlockedCountryModel.toMap()]);
      verify(mockSharedPreferences.setString(
        CountryBlockingLocalDataSourceImpl.kBlockedCountriesSimpleKey,
        expectedSimpleJson,
      ));
    });
  });
}
