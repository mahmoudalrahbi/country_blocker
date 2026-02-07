import 'dart:io';
import 'package:flutter/material.dart';
import 'package:country_blocker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../features/country_blocking/presentation/screens/add_country_screen.dart';
import '../../../features/country_blocking/presentation/screens/logs_screen.dart';
import '../../../features/country_blocking/presentation/screens/tabs/blocklist_tab.dart';
import '../../../features/country_blocking/presentation/screens/tabs/home_tab.dart';
import 'permission_guard_screen.dart';
import 'settings_screen.dart';

/// Main home screen with bottom navigation
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPerms = await ref.read(permissionsServiceProvider).hasPhonePermissions();
    if (mounted) {
      setState(() {
        _hasPermissions = hasPerms;
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  bool _hasPermissions = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasPermissions) {
      return PermissionGuardScreen(
        onPermissionsGranted: () {
          setState(() {
            _hasPermissions = true;
          });
        },
      );
    }

    // Watch loading state
    final isLoading = ref.watch(isLoadingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: const [
                HomeTab(),
                BlocklistTab(),
                LogsScreen(),
                SettingsScreen(),
              ],
            ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddCountryScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.public_off),
              label: AppLocalizations.of(context)!.blocklist,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: AppLocalizations.of(context)!.logs,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    String title = AppLocalizations.of(context)!.appTitle;

    switch (_selectedIndex) {
      case 1:
        title = AppLocalizations.of(context)!.countriesBlocked;
        break;
      case 2:
        title = AppLocalizations.of(context)!.recentActivity;
        break;
      case 3:
        title = AppLocalizations.of(context)!.settings;
        break;
    }

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.public_off,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      title: Text(title),
      actions: [
        if (Platform.isAndroid && _selectedIndex == 0)
          IconButton(
            icon: const Icon(Icons.shield),
            tooltip: AppLocalizations.of(context)!.enableBlocking,
            onPressed: () {
              ref.read(permissionsServiceProvider).requestRole();
            },
          ),
      ],
    );
  }
}
