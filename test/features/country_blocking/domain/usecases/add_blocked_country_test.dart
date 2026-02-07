import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/features/country_blocking/domain/entities/blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/repositories/country_blocking_repository.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/add_blocked_country.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

// Reuse mocks from get_blocked_countries_test
void main() {
  late AddBlockedCountry usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = AddBlockedCountry(mockRepository);
  });

  const tBlockedCountry = BlockedCountry(name: 'Test Country', phoneCode: '1', isoCode: 'US');

  test('should add blocked country to the repository when it does not exist', () async {
    // arrange
    when(mockRepository.getBlockedCountries())
        .thenAnswer((_) async => const Right([]));
    when(mockRepository.addBlockedCountry(tBlockedCountry))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(AddBlockedCountryParams(country: tBlockedCountry));
    // assert
    expect(result, const Right(null));
    verify(mockRepository.getBlockedCountries());
    verify(mockRepository.addBlockedCountry(tBlockedCountry));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when country already exists', () async {
    // arrange
    when(mockRepository.getBlockedCountries())
        .thenAnswer((_) async => const Right([tBlockedCountry]));
    // act
    final result = await usecase(AddBlockedCountryParams(country: tBlockedCountry));
    // assert
    expect(result, const Left(ValidationFailure('This country is already in the blocklist')));
    verify(mockRepository.getBlockedCountries());
    verifyNever(mockRepository.addBlockedCountry(any));
    verifyNoMoreInteractions(mockRepository);
  });
}
