import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/blocked_call_log_model.dart';

abstract class BlockLogLocalDataSource {
  Future<List<BlockedCallLogModel>> getLogs();
  Future<void> clearLogs();
}

const String kBlockedCallLogsKey = 'flutter.blocked_call_logs_native';

class BlockLogLocalDataSourceImpl implements BlockLogLocalDataSource {
  final SharedPreferences sharedPreferences;

  BlockLogLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<BlockedCallLogModel>> getLogs() async {
    final jsonString = sharedPreferences.getString(kBlockedCallLogsKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((jsonItem) => BlockedCallLogModel.fromMap(jsonItem))
            .toList();
      } catch (e) {
        throw CacheException();
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> clearLogs() async {
    await sharedPreferences.remove(kBlockedCallLogsKey);
  }
}
