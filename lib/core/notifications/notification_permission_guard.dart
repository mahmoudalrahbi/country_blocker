import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers.dart';

class NotificationPermissionGuard extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationPermissionGuard({super.key, required this.child});

  @override
  ConsumerState<NotificationPermissionGuard> createState() =>
      _NotificationPermissionGuardState();
}

class _NotificationPermissionGuardState
    extends ConsumerState<NotificationPermissionGuard>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    if (_isChecking) return;
    _isChecking = true;
    try {
      final granted =
          await ref.read(notificationServiceProvider).hasPermission();
      if (mounted) {
        setState(() => _hasPermission = granted);
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _openSettings() async {
    await ref.read(permissionsServiceProvider).openSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _NotificationPermissionBlockingScreen(
        onOpenSettings: _openSettings,
      );
    }
    return widget.child;
  }
}

class _NotificationPermissionBlockingScreen extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const _NotificationPermissionBlockingScreen(
      {required this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.notificationPermissionRequired,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.notificationPermissionDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: onOpenSettings,
                icon: const Icon(Icons.settings),
                label: Text(l10n.openAppSettings),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
