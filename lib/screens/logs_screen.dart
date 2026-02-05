import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/blocked_call_log.dart';
import '../theme/app_theme.dart';
import '../utils/country_flags.dart';

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
    final now = DateTime.now();
    return [
      // Today's logs
      BlockedCallLog(
        phoneNumber: '+91 98765 43210',
        countryName: 'India',
        countryCode: 'IN',
        reason: BlockReason.spamDatabase,
        timestamp: now.subtract(const Duration(minutes: 2)),
      ),
      BlockedCallLog(
        phoneNumber: '+1 (555) 012-3456',
        countryName: 'United States',
        countryCode: 'US',
        reason: BlockReason.ruleMarketing,
        timestamp: now.subtract(const Duration(hours: 2, minutes: 40)),
      ),
      BlockedCallLog(
        phoneNumber: '+234 801 234 5678',
        countryName: 'Nigeria',
        countryCode: 'NG',
        reason: BlockReason.countryBlocked,
        timestamp: now.subtract(const Duration(hours: 5, minutes: 55)),
      ),
      
      // Yesterday's logs
      BlockedCallLog(
        phoneNumber: '+7 495 123-45-67',
        countryName: 'Russia',
        countryCode: 'RU',
        reason: BlockReason.countryBlocked,
        timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 15)),
      ),
      BlockedCallLog(
        phoneNumber: '+44 20 7946 0958',
        countryName: 'United Kingdom',
        countryCode: 'GB',
        reason: BlockReason.ruleUnknownCaller,
        timestamp: now.subtract(const Duration(days: 1, hours: 6, minutes: 48)),
      ),
      BlockedCallLog(
        phoneNumber: '+55 11 91234-5678',
        countryName: 'Brazil',
        countryCode: 'BR',
        reason: BlockReason.countryBlocked,
        timestamp: now.subtract(const Duration(days: 1, hours: 15, minutes: 30)),
      ),
    ];
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
    final allLogs = _getMockLogs();
    final filteredLogs = _filterLogs(allLogs);
    final groupedLogs = _groupLogsByDate(filteredLogs);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search number or country',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.cardDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.borderDark.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.borderDark.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
            _searchQuery.isEmpty ? 'No blocked calls yet' : 'No results found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        date.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF9DA6B9),
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
    final flagEmoji = CountryFlags.getFlagEmoji(log.countryCode);
    
    // Calculate opacity for older items (fade effect)
    double opacity = 1.0;
    if (isOlder) {
      opacity = 1.0 - (olderIndex * 0.1).clamp(0.0, 0.3);
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderDark.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Country flag
            if (flagEmoji != null)
              Text(
                flagEmoji,
                style: const TextStyle(fontSize: 32),
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flag,
                  color: AppColors.textTertiary,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Country name and timestamp
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          log.countryName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimestamp(log.timestamp),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
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
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.block,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    // Just now (< 5 minutes)
    if (difference.inMinutes < 5) {
      return 'JUST NOW';
    }
    
    // All other times (today, yesterday, older) - just show time
    return DateFormat('HH:mm').format(timestamp);
  }
}
