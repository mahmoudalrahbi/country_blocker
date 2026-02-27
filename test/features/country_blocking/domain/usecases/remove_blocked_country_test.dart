

import 'package:country_blocker/features/country_blocking/domain/usecases/remove_blocked_country.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late RemoveBlockedCountry usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = RemoveBlockedCountry(mockRepository);
  });

  const tPhoneCode = '1';

  test('should remove blocked country from the repository', () async {
    // arrange
    when(mockRepository.removeBlockedCountry(tPhoneCode))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(RemoveBlockedCountryParams(phoneCode: tPhoneCode));
    // assert
    expect(result, const Right(null));
    verify(mockRepository.removeBlockedCountry(tPhoneCode));
    verifyNoMoreInteractions(mockRepository);
  });
}
