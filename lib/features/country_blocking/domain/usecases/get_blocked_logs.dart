import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/blocked_call_log.dart';
import '../repositories/block_log_repository.dart';

class GetBlockedLogs implements UseCase<List<BlockedCallLog>, NoParams> {
  final BlockLogRepository repository;

  GetBlockedLogs(this.repository);

  @override
  Future<Either<Failure, List<BlockedCallLog>>> call(NoParams params) async {
    return await repository.getLogs();
  }
}
