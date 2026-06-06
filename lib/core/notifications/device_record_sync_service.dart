import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_service.dart';

/// Syncs this device's [Device Record] to Firestore (`devices/{deviceToken}`).
///
/// Privacy boundary (ADR 0001): only the [Shareable Signal] `blockedCallsCount`
/// is ever written. The Blocking Preference (`blockedCountries`) is Local-only
/// Data and must NEVER reach Firestore under any code path.
abstract class DeviceRecordSyncService {
  /// Writes (merges) the current device record. [blockedCallsCount] is supplied
  /// per-call so each trigger pushes the live count.
  Future<void> sync({required int blockedCallsCount});
}

/// No-op implementation — the default in tests and when Firebase is absent.
class NoOpDeviceRecordSyncService implements DeviceRecordSyncService {
  @override
  Future<void> sync({required int blockedCallsCount}) async {}
}

/// Firestore-backed implementation.
class FirestoreDeviceRecordSyncService implements DeviceRecordSyncService {
  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;
  final String _platform;
  final String _appVersion;

  FirestoreDeviceRecordSyncService({
    required FirebaseFirestore firestore,
    required NotificationService notificationService,
    required String platform,
    required String appVersion,
  })  : _firestore = firestore,
        _notificationService = notificationService,
        _platform = platform,
        _appVersion = appVersion;

  @override
  Future<void> sync({required int blockedCallsCount}) async {
    final token = await _notificationService.getToken();
    if (token == null) return;

    await _firestore.collection('devices').doc(token).set(
      {
        'token': token,
        'blockedCallsCount': blockedCallsCount,
        'platform': _platform,
        'appVersion': _appVersion,
        'lastSyncedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
