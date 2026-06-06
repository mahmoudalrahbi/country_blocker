import 'package:country_blocker/core/notifications/notification_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

RemoteMessage _messageWithType(String type) =>
    RemoteMessage(data: {'type': type});

RemoteMessage _messageWithoutType() => const RemoteMessage(data: {});

RemoteMessage _messageWithUnknownType() =>
    RemoteMessage(data: {'type': 'something_unknown'});

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late List<String> pushedRoutes;
  late NotificationRouter router;

  setUp(() {
    pushedRoutes = [];
    navigatorKey = GlobalKey<NavigatorState>();
    router = NotificationRouter(navigatorKey: navigatorKey);
  });

  Widget buildApp() {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [_RouteObserver(pushedRoutes)],
      routes: {
        '/logs': (_) => const Scaffold(body: Text('Logs')),
      },
      home: const Scaffold(body: Text('Home')),
    );
  }

  group('NotificationRouter.route()', () {
    testWidgets('monthly_summary navigates to /logs', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(); // ensure navigator is fully attached
      pushedRoutes.clear();

      router.route(_messageWithType('monthly_summary'));
      await tester.pumpAndSettle();

      expect(find.text('Logs'), findsOneWidget);
      expect(pushedRoutes, contains('/logs'));
    });

    testWidgets('announcement triggers no push', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      pushedRoutes.clear();

      router.route(_messageWithType('announcement'));
      await tester.pumpAndSettle();

      expect(pushedRoutes, isEmpty);
    });

    testWidgets('update_available triggers no push', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      pushedRoutes.clear();

      router.route(_messageWithType('update_available'));
      await tester.pumpAndSettle();

      expect(pushedRoutes, isEmpty);
    });

    testWidgets('missing type triggers no navigation', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      pushedRoutes.clear();

      router.route(_messageWithoutType());
      await tester.pumpAndSettle();

      expect(pushedRoutes, isEmpty);
    });

    testWidgets('unknown type triggers no navigation', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      pushedRoutes.clear();

      router.route(_messageWithUnknownType());
      await tester.pumpAndSettle();

      expect(pushedRoutes, isEmpty);
    });
  });
}

class _RouteObserver extends NavigatorObserver {
  final List<String> routes;
  _RouteObserver(this.routes);

  @override
  void didPush(Route route, Route? previousRoute) {
    final name = route.settings.name;
    if (name != null) routes.add(name);
  }
}
