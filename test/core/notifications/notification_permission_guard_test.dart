import 'package:country_blocker/core/notifications/notification_permission_guard.dart';
import 'package:country_blocker/core/notifications/notification_service.dart';
import 'package:country_blocker/core/providers.dart';
import 'package:country_blocker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _GrantedNotificationService extends NoOpNotificationService {
  @override
  Future<bool> hasPermission() async => true;
}

class _DeniedNotificationService extends NoOpNotificationService {
  @override
  Future<bool> hasPermission() async => false;
}

Widget _buildApp({required NotificationService notificationService}) {
  return ProviderScope(
    overrides: [
      notificationServiceProvider.overrideWithValue(notificationService),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NotificationPermissionGuard(child: Scaffold(body: Text('Home'))),
    ),
  );
}

void main() {
  group('NotificationPermissionGuard', () {
    testWidgets('shows child when notification permission is granted',
        (tester) async {
      await tester.pumpWidget(
        _buildApp(notificationService: _GrantedNotificationService()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(NotificationPermissionGuard), findsOneWidget);
    });

    testWidgets('shows blocking screen when notification permission is denied',
        (tester) async {
      await tester.pumpWidget(
        _buildApp(notificationService: _DeniedNotificationService()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
      expect(find.text('Notifications Required'), findsOneWidget);
    });

    testWidgets('blocking screen has open settings button', (tester) async {
      await tester.pumpWidget(
        _buildApp(notificationService: _DeniedNotificationService()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Open App Settings'), findsOneWidget);
    });
  });
}
