import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/blocked_call_log.dart';
import '../../domain/usecases/get_blocked_logs.dart';
import '../../domain/repositories/block_log_repository.dart';
import '../../../../core/usecase/usecase.dart';

class BlockLogNotifier extends StateNotifier<List<BlockedCallLog>> {
  final GetBlockedLogs getBlockedLogs;
  final BlockLogRepository repository;

  BlockLogNotifier({
    required this.getBlockedLogs,
    required this.repository,
  }) : super([]) {
    loadLogs();
  }

  Future<void> loadLogs() async {
    final result = await getBlockedLogs(NoParams());
    result.fold(
      (failure) => state = [], // Handle error state if needed
      (logs) => state = logs,
    );
  }

  Future<void> clearLogs() async {
    final result = await repository.clearLogs();
    result.fold(
      (failure) {}, // Handle error
      (_) => state = [],
    );
  }
}
