import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_country_blocking.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late ToggleCountryBlocking usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = ToggleCountryBlocking(mockRepository);
  });

  test('should enable blocking for a country in the repository', () async {
    // arrange
    when(mockRepository.toggleCountryBlocking('1', true))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(
      const ToggleCountryBlockingParams(phoneCode: '1', isEnabled: true),
    );
    // assert
    expect(result, const Right(null));
    verify(mockRepository.toggleCountryBlocking('1', true));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should disable blocking for a country in the repository', () async {
    // arrange
    when(mockRepository.toggleCountryBlocking('1', false))
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(
      const ToggleCountryBlockingParams(phoneCode: '1', isEnabled: false),
    );
    // assert
    expect(result, const Right(null));
    verify(mockRepository.toggleCountryBlocking('1', false));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(mockRepository.toggleCountryBlocking('1', true))
        .thenAnswer((_) async => const Left(CacheFailure('Toggle error')));
    // act
    final result = await usecase(
      const ToggleCountryBlockingParams(phoneCode: '1', isEnabled: true),
    );
    // assert
    expect(result, const Left(CacheFailure('Toggle error')));
    verify(mockRepository.toggleCountryBlocking('1', true));
    verifyNoMoreInteractions(mockRepository);
  });
}
