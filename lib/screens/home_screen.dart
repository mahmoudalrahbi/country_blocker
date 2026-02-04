import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blocked_provider.dart';
import '../widgets/status_card.dart';
import '../widgets/stat_card.dart';
import '../theme/app_theme.dart';
import 'add_country_screen.dart';
import '../widgets/country_list_item.dart';
import '../utils/country_flags.dart';

import 'dart:io';
import '../services/permissions_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isBlockingActive = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, bool> _toggleStates = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleBlocking() {
    setState(() {
      _isBlockingActive = !_isBlockingActive;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBlockingActive
              ? 'Call blocking enabled'
              : 'Call blocking disabled',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlockedProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(provider),
                _buildBlocklistTab(provider),
                _buildLogTab(),
                _buildSettingsTab(),
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
              color: AppColors.borderDark.withOpacity(0.5),
              width: 1,
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

  PreferredSizeWidget _buildAppBar() {
    String title = 'Country Blocker';
    
    switch (_selectedIndex) {
      case 1:
        title = 'Blocked Countries';
        break;
      case 2:
        title = 'Call Log';
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
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.public_off,
            color: AppColors.primary,
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
            color: AppColors.textSecondary,
            onPressed: () {
              // TODO: Show more options
            },
          ),
      ],
    );
  }

  // Home Tab - Dashboard
  Widget _buildHomeTab(BlockedProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          StatusCard(
            isActive: _isBlockingActive,
            onToggle: _toggleBlocking,
          ),
          const SizedBox(height: 32),
          
          // Overview header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Last 30 days',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Blocked Calls',
                  value: '${provider.blockedCallsCount}',
                  icon: Icons.call_missed,
                  trend: provider.blockedCallsCount > 0 ? 'Total blocked' : null,
                  isTrendPositive: provider.blockedCallsCount > 0 ? true : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Countries',
                  value: '${provider.blockedList.length}',
                  icon: Icons.flag,
                  subtitle: 'Active on blocklist',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Blocklist Tab
  Widget _buildBlocklistTab(BlockedProvider provider) {
    // Filter countries based on search query
    final filteredCountries = provider.blockedList.where((country) {
      if (_searchQuery.isEmpty) return true;
      return country.name.toLowerCase().contains(_searchQuery) ||
          country.phoneCode.contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search blocked rules...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.inputDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        
        // Section header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            'ACTIVE RULES (${filteredCountries.length})',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Countries list
        Expanded(
          child: filteredCountries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public_off,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No blocked countries yet'
                            : 'No results found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_searchQuery.isEmpty)
                        Text(
                          'Tap + to add one',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final key = country.phoneCode;
                    
                    // Initialize toggle state if not exists
                    _toggleStates.putIfAbsent(key, () => true);
                    
                    return CountryListItem(
                      countryName: country.name,
                      phoneCode: country.phoneCode,
                      flagEmoji: _getFlagEmoji(country.isoCode),
                      subtitle: _getSubtitle(index),
                      isEnabled: _toggleStates[key] ?? true,
                      onToggle: (value) {
                        setState(() {
                          _toggleStates[key] = value;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? '${country.name} blocking enabled'
                                  : '${country.name} blocking disabled',
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteDialog(context, provider, country.phoneCode, country.name);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Log Tab
  Widget _buildLogTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Call Log',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Settings Tab
  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String? _getFlagEmoji(String isoCode) {
    // Use the CountryFlags utility to get flag emoji for any valid ISO code
    // Returns null for unknown countries, which will show the default dialpad icon
    return CountryFlags.getFlagEmoji(isoCode);
  }

  String _getSubtitle(int index) {
    // Mock subtitles for demonstration
    const subtitles = [
      'Custom Code Rule',
      'High spam activity',
      'Blocked by user',
      'Frequent marketing',
      'Potential fraud',
      'Unknown source',
    ];
    return subtitles[index % subtitles.length];
  }

  void _showDeleteDialog(BuildContext context, BlockedProvider provider, String phoneCode, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Delete Country'),
        content: Text('Are you sure you want to remove $name from the blocklist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeCountry(phoneCode);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name removed from blocklist'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
