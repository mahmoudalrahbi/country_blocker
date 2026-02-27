import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/country_blocking_repository.dart';

/// Use case that gets the global blocking status
class GetGlobalBlockingStatus implements UseCase<bool, NoParams> {
  final CountryBlockingRepository repository;

  GetGlobalBlockingStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getGlobalBlockingStatus();
  }
}
