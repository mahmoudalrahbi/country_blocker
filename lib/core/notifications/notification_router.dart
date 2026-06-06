import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationRouter {
  final GlobalKey<NavigatorState> navigatorKey;

  const NotificationRouter({required this.navigatorKey});

  void route(RemoteMessage message) {
    final type = message.data['type'] as String?;
    if (type == null) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    switch (type) {
      case 'monthly_summary':
        navigator.pushNamed('/logs');
      case 'update_available':
      case 'announcement':
        // Bring app to foreground at home — no push needed
        break;
      default:
        // Unknown type — ignore
        break;
    }
  }
}
