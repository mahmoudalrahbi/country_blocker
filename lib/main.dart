import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blocked_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CallShieldApp());
}

class CallShieldApp extends StatelessWidget {
  const CallShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BlockedProvider()),
      ],
      child: MaterialApp(
        title: 'Country Blocker',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
