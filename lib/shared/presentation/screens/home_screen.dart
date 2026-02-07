import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../features/country_blocking/presentation/screens/add_country_screen.dart';
import '../../../features/country_blocking/presentation/screens/logs_screen.dart';
import '../../../features/country_blocking/presentation/screens/tabs/blocklist_tab.dart';
import '../../../features/country_blocking/presentation/screens/tabs/home_tab.dart';
import '../../services/permissions_service.dart';
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
    await PermissionsService.requestPhonePermissions();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public_off),
              label: 'Blocklist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    String title = 'Country Blocker';

    switch (_selectedIndex) {
      case 1:
        title = 'Blocked Countries';
        break;
      case 2:
        title = 'Recent Blocks';
        break;
      case 3:
        title = 'Settings';
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
            tooltip: 'Enable Call Blocking',
            onPressed: () {
              PermissionsService.requestRole();
            },
          ),
        if (_selectedIndex == 1 || _selectedIndex == 3)
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            onPressed: () {
              // TODO: Show more options
            },
          ),
        if (_selectedIndex == 2)
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
      ],
    );
  }
}
