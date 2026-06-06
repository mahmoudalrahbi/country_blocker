import 'package:country_blocker/core/notifications/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NoOpNotificationService', () {
    late NotificationService service;

    setUp(() {
      service = NoOpNotificationService();
    });

    test('requestPermission returns false', () async {
      expect(await service.requestPermission(), isFalse);
    });

    test('hasPermission returns false', () async {
      expect(await service.hasPermission(), isFalse);
    });

    test('getToken returns null', () async {
      expect(await service.getToken(), isNull);
    });

    test('subscribeToTopic completes without error', () async {
      await expectLater(service.subscribeToTopic('all_users'), completes);
    });

    test('onMessage emits no events', () async {
      final events = await service.onMessage.take(0).toList();
      expect(events, isEmpty);
    });

    test('onMessageOpenedApp emits no events', () async {
      final events = await service.onMessageOpenedApp.take(0).toList();
      expect(events, isEmpty);
    });

    test('getInitialMessage returns null', () async {
      expect(await service.getInitialMessage(), isNull);
    });

    test('subscribeToTopic can be called multiple times without error', () async {
      await service.subscribeToTopic('all_users');
      await service.subscribeToTopic('updates');
    });
  });
}
