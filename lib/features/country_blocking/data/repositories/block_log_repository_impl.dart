import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/blocked_call_log.dart';
import '../../domain/repositories/block_log_repository.dart';
import '../datasources/block_log_local_data_source.dart';

class BlockLogRepositoryImpl implements BlockLogRepository {
  final BlockLogLocalDataSource localDataSource;

  BlockLogRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BlockedCallLog>>> getLogs() async {
    try {
      final localLogs = await localDataSource.getLogs();
      return Right(localLogs);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearLogs() async {
    try {
      await localDataSource.clearLogs();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
