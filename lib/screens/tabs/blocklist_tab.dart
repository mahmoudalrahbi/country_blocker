import 'package:flutter/material.dart';
import '../../providers/blocked_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/country_list_item.dart';
import '../../utils/country_flags.dart';

class BlocklistTab extends StatefulWidget {
  final BlockedProvider provider;

  const BlocklistTab({
    super.key,
    required this.provider,
  });

  @override
  State<BlocklistTab> createState() => _BlocklistTabState();
}

class _BlocklistTabState extends State<BlocklistTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // Store toggle states locally for UI responsiveness before persisting if needed
  // In a real app, this might be better handled in the provider model directly
  final Map<String, bool> _toggleStates = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  String? _getFlagEmoji(String isoCode) {
    return CountryFlags.getFlagEmoji(isoCode);
  }

  String _getSubtitle(int index) {
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

  void _showDeleteDialog(BuildContext context, String phoneCode, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Delete Country'),
        content: Text('Are you sure you want to remove $name from the blocklist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.provider.removeCountry(phoneCode);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Filter countries based on search query
    final filteredCountries = widget.provider.blockedList.where((country) {
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
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search blocked rules...',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).inputDecorationTheme.hintStyle?.color,
                size: 20,
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
            style: Theme.of(context).textTheme.labelSmall,
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
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, // Fixed: was textTertiary
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No blocked countries yet'
                            : 'No results found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, // Fixed: was textSecondary
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
                    
                    // Initialize toggle state if not exists, but don't do it in build
                    // We just use the ?? true default here for display
                    final isEnabled = _toggleStates[key] ?? true;
                    
                    return CountryListItem(
                      countryName: country.name,
                      phoneCode: country.phoneCode,
                      flagEmoji: _getFlagEmoji(country.isoCode),
                      subtitle: _getSubtitle(index),
                      isEnabled: isEnabled,
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
                        _showDeleteDialog(context, country.phoneCode, country.name);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
