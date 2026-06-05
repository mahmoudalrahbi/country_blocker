import 'dart:convert';
import 'analytics_service.dart';

class CallsBlockedHarvester {
  /// Reads [nativeLogsJson] (the value of `flutter.blocked_call_logs_native`),
  /// skips the first [watermark] entries (already reported), groups the
  /// remainder by country code, and emits one `calls_blocked` event per country.
  /// Calls [onWatermarkUpdate] with the new total so callers can persist it.
  ///
  /// Only country codes leave the device — never phone numbers.
  static Future<void> harvest({
    required String? nativeLogsJson,
    required int watermark,
    required AnalyticsService analytics,
    required Future<void> Function(int newWatermark) onWatermarkUpdate,
  }) async {
    if (nativeLogsJson == null || nativeLogsJson.isEmpty) return;

    final List<dynamic> all;
    try {
      all = json.decode(nativeLogsJson) as List<dynamic>;
    } catch (_) {
      return;
    }

    final newEntries = all.skip(watermark).toList();
    if (newEntries.isEmpty) return;

    final counts = <String, int>{};
    for (final entry in newEntries) {
      final map = entry as Map<String, dynamic>;
      final code = (map['countryCode'] as String?) ?? 'UNKNOWN';
      counts[code] = (counts[code] ?? 0) + 1;
    }

    for (final entry in counts.entries) {
      await analytics.logEvent(
        'calls_blocked',
        parameters: {'country_code': entry.key, 'count': entry.value},
      );
    }

    await onWatermarkUpdate(all.length);
  }
}
