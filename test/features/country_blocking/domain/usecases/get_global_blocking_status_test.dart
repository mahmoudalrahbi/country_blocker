import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_global_blocking_status.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late GetGlobalBlockingStatus usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = GetGlobalBlockingStatus(mockRepository);
  });

  test('should return true when global blocking is enabled', () async {
    // arrange
    when(mockRepository.getGlobalBlockingStatus())
        .thenAnswer((_) async => const Right(true));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(true));
    verify(mockRepository.getGlobalBlockingStatus());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return false when global blocking is disabled', () async {
    // arrange
    when(mockRepository.getGlobalBlockingStatus())
        .thenAnswer((_) async => const Right(false));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(false));
    verify(mockRepository.getGlobalBlockingStatus());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(mockRepository.getGlobalBlockingStatus())
        .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Left(CacheFailure('Cache error')));
    verify(mockRepository.getGlobalBlockingStatus());
    verifyNoMoreInteractions(mockRepository);
  });
}
