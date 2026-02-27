import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/blocked_call_log.dart';

abstract class BlockLogRepository {
  Future<Either<Failure, List<BlockedCallLog>>> getLogs();
  Future<Either<Failure, void>> clearLogs();
}
