import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/entities/blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/repositories/country_blocking_repository.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_countries.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

@GenerateMocks([CountryBlockingRepository])
void main() {
  late GetBlockedCountries usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = GetBlockedCountries(mockRepository);
  });

  const tBlockedCountries = [
    BlockedCountry(name: 'Test Country', phoneCode: '1', isoCode: 'US'),
  ];

  test('should get blocked countries from the repository', () async {
    // arrange
    when(mockRepository.getBlockedCountries())
        .thenAnswer((_) async => const Right(tBlockedCountries));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(tBlockedCountries));
    verify(mockRepository.getBlockedCountries());
    verifyNoMoreInteractions(mockRepository);
  });
}
