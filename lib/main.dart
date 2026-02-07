import 'package:flutter/material.dart';
import 'package:country_blocker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers.dart';
import 'shared/presentation/screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    // Wrap app with ProviderScope for Riverpod
    ProviderScope(
      overrides: [
        // Override the SharedPreferences provider with actual instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const CountryBlockerApp(),
    ),
  );
}

class CountryBlockerApp extends ConsumerWidget {
  const CountryBlockerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
