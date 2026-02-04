import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A country list item widget for the blocklist screen
class CountryListItem extends StatelessWidget {
  final String countryName;
  final String phoneCode;
  final String? flagEmoji;
  final String? subtitle;
  final bool isEnabled;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onDelete;

  const CountryListItem({
    super.key,
    required this.countryName,
    required this.phoneCode,
    this.flagEmoji,
    this.subtitle,
    required this.isEnabled,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Flag or Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.inputDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: flagEmoji != null
                        ? Text(
                            flagEmoji!,
                            style: const TextStyle(fontSize: 24),
                          )
                        : const Icon(
                            Icons.dialpad,
                            color: AppColors.textSecondary,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Country info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        countryName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+$phoneCode${subtitle != null ? ' • $subtitle' : ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Toggle switch
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isEnabled,
                    onChanged: onToggle,
                    activeColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withOpacity(0.5),
                  ),
                ),
                
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.textSecondary,
                  onPressed: onDelete,
                  iconSize: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
