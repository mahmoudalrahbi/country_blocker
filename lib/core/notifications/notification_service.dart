import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  Future<bool> requestPermission();
  Future<bool> hasPermission();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Stream<RemoteMessage> get onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp;
  Future<RemoteMessage?> getInitialMessage();
}

class NoOpNotificationService implements NotificationService {
  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Stream<RemoteMessage> get onMessage => const Stream.empty();

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<RemoteMessage?> getInitialMessage() async => null;
}
