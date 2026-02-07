import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/country_blocking_repository.dart';

/// Use case for toggling global blocking on/off
class ToggleGlobalBlocking implements UseCase<void, NoParams> {
  final CountryBlockingRepository repository;

  ToggleGlobalBlocking(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.toggleGlobalBlocking();
  }
}
