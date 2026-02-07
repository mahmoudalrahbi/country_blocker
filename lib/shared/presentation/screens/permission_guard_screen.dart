import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/permissions_service.dart';
import '../../../core/providers.dart';

/// Screen displayed when required permissions are missing.
/// Forces the user to grant permissions to proceed.
class PermissionGuardScreen extends ConsumerStatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionGuardScreen({
    super.key,
    required this.onPermissionsGranted,
  });

  @override
  ConsumerState<PermissionGuardScreen> createState() => _PermissionGuardScreenState();
}

class _PermissionGuardScreenState extends ConsumerState<PermissionGuardScreen> with WidgetsBindingObserver {
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final hasPerms = await ref.read(permissionsServiceProvider).hasPhonePermissions();
      if (hasPerms && mounted) {
        widget.onPermissionsGranted();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _requestPermissions() async {
    final granted = await ref.read(permissionsServiceProvider).requestPhonePermissions();
    if (granted && mounted) {
      widget.onPermissionsGranted();
    }
  }

  Future<void> _openSettings() async {
    await ref.read(permissionsServiceProvider).openSettings();
    // The observer will catch the return to app and check permissions
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security_update_warning_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Permissions Required',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'To protect you from unwanted calls, Country Blocker needs access to read your phone state and contacts.\n\nWe do not upload or share your data.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: _requestPermissions,
                icon: const Icon(Icons.check),
                label: const Text('Grant Permissions'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _openSettings,
                child: const Text('Open App Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
