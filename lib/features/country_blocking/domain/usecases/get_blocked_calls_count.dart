import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/country_blocking_repository.dart';

/// Use case that gets the blocked calls count
class GetBlockedCallsCount implements UseCase<int, NoParams> {
  final CountryBlockingRepository repository;

  GetBlockedCallsCount(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getBlockedCallsCount();
  }
}
