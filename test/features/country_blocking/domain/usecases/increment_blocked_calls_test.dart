import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/increment_blocked_calls.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late IncrementBlockedCalls usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = IncrementBlockedCalls(mockRepository);
  });

  test('should increment blocked calls in the repository', () async {
    // arrange
    when(mockRepository.incrementBlockedCalls())
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(null));
    verify(mockRepository.incrementBlockedCalls());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(mockRepository.incrementBlockedCalls())
        .thenAnswer((_) async => const Left(CacheFailure('Increment error')));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Left(CacheFailure('Increment error')));
    verify(mockRepository.incrementBlockedCalls());
    verifyNoMoreInteractions(mockRepository);
  });
}
