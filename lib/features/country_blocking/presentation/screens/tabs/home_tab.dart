import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers.dart';
import '../../../../../../shared/services/permissions_service.dart';
import '../../widgets/status_card.dart';
import '../../widgets/stat_card.dart';

/// Home tab displaying blocking status and statistics
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  Future<void> _toggleBlocking(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(countryBlockingNotifierProvider.notifier);
    final state = ref.read(countryBlockingNotifierProvider);

    // Ensure we have permissions before enabling
    if (!state.isBlockingActive) {
      final hasPerms = await ref.read(permissionsServiceProvider).requestPhonePermissions();
      if (!hasPerms) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Permissions required to enable blocking'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    await notifier.toggleGlobalBlocking();
    
    // Feedback is handled by UI state change, but we could add a snackbar if desired
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state from Riverpod provider
    final state = ref.watch(countryBlockingNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          StatusCard(
            isActive: state.isBlockingActive,
            onToggle: () => _toggleBlocking(context, ref),
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
                  value: '${state.blockedCallsCount}',
                  icon: Icons.call_missed,
                  trend: state.blockedCallsCount > 0 ? 'Total blocked' : null,
                  isTrendPositive: state.blockedCallsCount > 0 ? true : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Countries',
                  value: '${state.blockedCountries.length}',
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
