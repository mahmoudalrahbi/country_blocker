import 'package:flutter/material.dart';


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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Flag or Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha:0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: flagEmoji != null
                      ? Text(
                          flagEmoji!,
                          style: theme.textTheme.headlineSmall,
                        )
                      : Icon(
                          Icons.public,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+$phoneCode${subtitle != null ? ' • $subtitle' : ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Toggle switch
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: isEnabled,
                  onChanged: onToggle,
                ),
              ),
              
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: colorScheme.onSurfaceVariant,
                onPressed: onDelete,
                iconSize: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
