import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_global_blocking.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_blocked_countries_test.mocks.dart';

void main() {
  late ToggleGlobalBlocking usecase;
  late MockCountryBlockingRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryBlockingRepository();
    usecase = ToggleGlobalBlocking(mockRepository);
  });

  test('should toggle global blocking in the repository', () async {
    // arrange
    when(mockRepository.toggleGlobalBlocking())
        .thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(null));
    verify(mockRepository.toggleGlobalBlocking());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(mockRepository.toggleGlobalBlocking())
        .thenAnswer((_) async => const Left(CacheFailure('Toggle error')));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Left(CacheFailure('Toggle error')));
    verify(mockRepository.toggleGlobalBlocking());
    verifyNoMoreInteractions(mockRepository);
  });
}
