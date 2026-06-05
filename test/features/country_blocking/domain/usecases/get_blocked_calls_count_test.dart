import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_calls_count.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late GetBlockedCallsCount usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = GetBlockedCallsCount(mockRepository);
  });

  test('should return blocked calls count from repository', () async {
    // arrange
    when(mockRepository.getBlockedCallsCount())
        .thenAnswer((_) async => const Right(42));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(42));
    verify(mockRepository.getBlockedCallsCount());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(mockRepository.getBlockedCallsCount())
        .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Left(CacheFailure('Cache error')));
    verify(mockRepository.getBlockedCallsCount());
    verifyNoMoreInteractions(mockRepository);
  });
}
