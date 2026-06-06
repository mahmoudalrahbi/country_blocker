import 'package:country_blocker/core/notifications/device_record_sync_service.dart';
import 'package:country_blocker/core/notifications/notification_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class _TokenService extends NoOpNotificationService {
  final String? _token;
  _TokenService(this._token);

  @override
  Future<String?> getToken() async => _token;
}

void main() {
  late FakeFirebaseFirestore firestore;

  setUp(() {
    firestore = FakeFirebaseFirestore();
  });

  FirestoreDeviceRecordSyncService buildService({
    String? token = 'test-token-123',
    String platform = 'android',
    String appVersion = '1.0.2',
  }) {
    return FirestoreDeviceRecordSyncService(
      firestore: firestore,
      notificationService: _TokenService(token),
      platform: platform,
      appVersion: appVersion,
    );
  }

  group('FirestoreDeviceRecordSyncService.sync()', () {
    test('writes correct fields to devices/{token}', () async {
      final service = buildService();

      await service.sync(blockedCallsCount: 7);

      final doc =
          await firestore.collection('devices').doc('test-token-123').get();

      expect(doc.exists, isTrue);
      expect(doc.data()!['token'], 'test-token-123');
      expect(doc.data()!['blockedCallsCount'], 7);
      expect(doc.data()!['platform'], 'android');
      expect(doc.data()!['appVersion'], '1.0.2');
      expect(doc.data()!['lastSyncedAt'], isNotNull);
    });

    test('never writes blockedCountries', () async {
      final service = buildService(token: 'token-xyz', platform: 'ios');

      await service.sync(blockedCallsCount: 3);

      final doc = await firestore.collection('devices').doc('token-xyz').get();
      expect(doc.data()!.containsKey('blockedCountries'), isFalse);
    });

    test('second sync updates blockedCallsCount', () async {
      final service = buildService(token: 'token-abc');

      await service.sync(blockedCallsCount: 5);
      await service.sync(blockedCallsCount: 12);

      final doc =
          await firestore.collection('devices').doc('token-abc').get();
      expect(doc.data()!['blockedCallsCount'], 12);
    });

    test('is a no-op when token is null', () async {
      final service = buildService(token: null);

      await service.sync(blockedCallsCount: 0);

      final snapshot = await firestore.collection('devices').get();
      expect(snapshot.docs, isEmpty);
    });
  });
}
