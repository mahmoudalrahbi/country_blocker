import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_blocker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_picker/country_picker.dart';

import 'core/notifications/device_record_sync_service.dart';
import 'core/notifications/firebase_notification_service.dart';
import 'core/notifications/notification_permission_guard.dart';
import 'core/notifications/notification_router.dart';
import 'core/providers.dart';
import 'core/telemetry/crash_reporter.dart';
import 'core/telemetry/firebase_crash_reporter.dart';
import 'firebase_options.dart';
import 'shared/presentation/screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  CrashReporter crashReporter;

  if (kDebugMode) {
    crashReporter = NoOpCrashReporter();
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    crashReporter = FirebaseCrashReporter(FirebaseCrashlytics.instance);
  }

  final notificationService =
      FirebaseNotificationService(FirebaseMessaging.instance);

  await notificationService.requestPermission();
  await notificationService.subscribeToTopic('all_users');

  // Swallow foreground messages — no UI shown while app is open
  notificationService.onMessage.listen((_) {});

  final navigatorKey = GlobalKey<NavigatorState>();
  final router = NotificationRouter(navigatorKey: navigatorKey);

  // Background tap — app was in background
  notificationService.onMessageOpenedApp.listen(router.route);

  // Cold-start — app was terminated
  final initialMessage = await notificationService.getInitialMessage();
  if (initialMessage != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.route(initialMessage);
    });
  }

  final packageInfo = await PackageInfo.fromPlatform();
  final deviceRecordSync = FirestoreDeviceRecordSyncService(
    firestore: FirebaseFirestore.instance,
    notificationService: notificationService,
    platform: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
    appVersion: packageInfo.version,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        crashReporterProvider.overrideWithValue(crashReporter),
        notificationServiceProvider.overrideWithValue(notificationService),
        deviceRecordSyncServiceProvider.overrideWithValue(deviceRecordSync),
        navigatorKeyProvider.overrideWithValue(navigatorKey),
      ],
      child: CountryBlockerApp(navigatorKey: navigatorKey),
    ),
  );
}

class CountryBlockerApp extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const CountryBlockerApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      routes: {
        '/logs': (_) => const NotificationPermissionGuard(child: HomeScreen()),
      },
      home: const NotificationPermissionGuard(child: HomeScreen()),
    );
  }
}
