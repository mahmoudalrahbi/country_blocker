import 'package:flutter/material.dart';
import 'package:country_blocker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../theme/app_theme.dart';

/// Settings screen that provides app configuration options
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSection(),
            const SizedBox(height: 24),
            _buildSupportSection(),
            const SizedBox(height: 24),
            _buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'GENERAL',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildNotificationToggle(),
              _buildDivider(),
              _buildAppearanceSelector(),
              _buildDivider(),
              _buildLanguageSelector(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildIconContainer(
            Icons.notifications,
            colorScheme.primary, // Replaced hardcoded blue
          ),
          const SizedBox(width: 16),
          Text(
            'Notifications',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Switch.adaptive(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSelector() {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeModeProvider);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconContainer(
                Icons.palette,
                colorScheme.secondary, // Replaced hardcoded indigo
              ),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.theme,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  currentThemeMode,
                  ThemeMode.light,
                  AppLocalizations.of(context)!.light,
                  Icons.wb_sunny,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOption(
                  currentThemeMode,
                  ThemeMode.dark,
                  AppLocalizations.of(context)!.dark,
                  Icons.dark_mode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOption(
                  currentThemeMode,
                  ThemeMode.system,
                  AppLocalizations.of(context)!.system,
                  Icons.settings_suggest,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    ThemeMode currentThemeMode,
    ThemeMode mode,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = currentThemeMode == mode;

    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: mode == ThemeMode.light
                    ? Colors.white
                    : AppColors.backgroundDark,
                border: Border.all(
                  color: mode == ThemeMode.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: mode == ThemeMode.system
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.borderLight, // Fixed: was borderLightMode
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 6,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.surfaceLight, // Fixed: was cardLight
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: AppColors.backgroundDark,
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.borderDark,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 6,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceDark,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 6,
                            width: 30,
                            decoration: BoxDecoration(
                              color: mode == ThemeMode.light
                                  ? AppColors
                                      .borderLight // Fixed: was borderLightMode
                                  : AppColors.borderDark,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 6,
                            width: 20,
                            decoration: BoxDecoration(
                              color: mode == ThemeMode.light
                                  ? AppColors.surfaceLight // Fixed: was cardLight
                                  : AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentLocale = ref.watch(localeProvider);

    return InkWell(
      onTap: () {
        _showLanguageDialog(currentLocale);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildIconContainer(
              Icons.language,
              Colors.purple,
            ),
            const SizedBox(width: 16),
            Text(
              AppLocalizations.of(context)!.language,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              currentLocale.languageCode == 'ar' ? 'العربية' : 'English',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(Locale currentLocale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCountry), // Reused selectCountry for now, ideally needs separate string
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioGroup<String>(
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('English'),
                    value: 'en',
                  ),
                  RadioListTile<String>(
                    title: const Text('العربية'),
                    value: 'ar',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'SUPPORT',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildMenuItem(
                AppLocalizations.of(context)!.contactSupport,
                Icons.help,
                Colors.orange, // Distinct functional color
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help Center coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                AppLocalizations.of(context)!.about,
                Icons.info,
                theme.colorScheme.onSurfaceVariant,
                () {
                  _showAboutDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildIconContainer(icon, iconColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);

    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.dividerTheme.color,
    );
  }

  Widget _buildVersionInfo() {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        '${AppLocalizations.of(context)!.appTitle} V2.5.0',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  void _showAboutDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.public_off,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.about),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.appTitle),
            const SizedBox(height: 4),
            Text(
              '${AppLocalizations.of(context)!.version} 2.5.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Block unwanted international calls by country code. Take control of your phone and protect yourself from spam and fraud.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 ${AppLocalizations.of(context)!.appTitle}. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }
}
