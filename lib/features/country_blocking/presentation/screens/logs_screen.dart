import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/blocked_call_log.dart';
import '../../../../core/utils/country_flags.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  // Mock data for demonstration - replace with actual data from provider
  List<BlockedCallLog> _getMockLogs() {
    return [];
  }

  Map<String, List<BlockedCallLog>> _groupLogsByDate(List<BlockedCallLog> logs) {
    final Map<String, List<BlockedCallLog>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var log in logs) {
      final logDate = DateTime(
        log.timestamp.year,
        log.timestamp.month,
        log.timestamp.day,
      );

      String key;
      if (logDate == today) {
        key = 'Today';
      } else if (logDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM d, yyyy').format(logDate);
      }

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(log);
    }

    return grouped;
  }

  List<BlockedCallLog> _filterLogs(List<BlockedCallLog> logs) {
    if (_searchQuery.isEmpty) return logs;
    
    return logs.where((log) {
      return log.phoneNumber.toLowerCase().contains(_searchQuery) ||
             log.countryName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final allLogs = _getMockLogs();
    final filteredLogs = _filterLogs(allLogs);
    final groupedLogs = _groupLogsByDate(filteredLogs);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search number or country',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.inputDecorationTheme.hintStyle?.color,
                  size: 20,
                ),
              ),
            ),
          ),
          
          // Logs list
          Expanded(
            child: filteredLogs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _calculateItemCount(groupedLogs),
                    itemBuilder: (context, index) {
                      return _buildListItem(context, groupedLogs, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha:0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No blocked calls yet' : 'No results found',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  int _calculateItemCount(Map<String, List<BlockedCallLog>> groupedLogs) {
    int count = 0;
    groupedLogs.forEach((date, logs) {
      count += 1; // Date header
      count += logs.length; // Log items
    });
    return count;
  }

  Widget _buildListItem(
    BuildContext context,
    Map<String, List<BlockedCallLog>> groupedLogs,
    int index,
  ) {
    int currentIndex = 0;
    
    for (var entry in groupedLogs.entries) {
      // Check if this is a date header
      if (currentIndex == index) {
        return _buildDateHeader(entry.key);
      }
      currentIndex++;
      
      // Check if this is a log item
      for (var i = 0; i < entry.value.length; i++) {
        if (currentIndex == index) {
          final isOlder = entry.key != 'Today';
          return _buildLogCard(
            entry.value[i],
            isOlder: isOlder,
            olderIndex: isOlder ? i : 0,
          );
        }
        currentIndex++;
      }
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildDateHeader(String date) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        date.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.6,
        ),
      ),
    );
  }

  Widget _buildLogCard(
    BlockedCallLog log, {
    bool isOlder = false,
    int olderIndex = 0,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final flagEmoji = CountryFlags.getFlagEmoji(log.countryCode);
    
    // Calculate opacity for older items (fade effect)
    double opacity = 1.0;
    if (isOlder) {
      opacity = 1.0 - (olderIndex * 0.1).clamp(0.0, 0.3);
    }

    return Opacity(
      opacity: opacity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Country flag
              if (flagEmoji != null)
                Text(
                  flagEmoji,
                  style: theme.textTheme.displayMedium,
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.flag,
                    color: colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                ),
              const SizedBox(width: 16),
              
              // Phone number and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone number only (full width)
                    Text(
                      log.phoneNumber,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Country name and timestamp
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            log.countryName,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatTimestamp(log.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Block icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.block,
                  color: colorScheme.error,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    
    // Just now (< 5 minutes)
    if (difference.inMinutes < 5) {
      return 'JUST NOW';
    }
    
    // All other times (today, yesterday, older) - just show time
    return DateFormat('HH:mm').format(timestamp);
  }
}
