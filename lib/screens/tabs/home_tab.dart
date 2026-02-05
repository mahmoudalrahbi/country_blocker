import 'package:flutter/material.dart';
import '../../providers/blocked_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_card.dart';
import '../../widgets/stat_card.dart';

class HomeTab extends StatelessWidget {
  final BlockedProvider provider;
  final bool isBlockingActive;
  final VoidCallback onToggleBlocking;

  const HomeTab({
    super.key,
    required this.provider,
    required this.isBlockingActive,
    required this.onToggleBlocking,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          StatusCard(
            isActive: isBlockingActive,
            onToggle: onToggleBlocking,
          ),
          const SizedBox(height: 32),
          
          // Overview header
          Text(
            'Overview',
            style: Theme.of(context).textTheme.headlineLarge,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
