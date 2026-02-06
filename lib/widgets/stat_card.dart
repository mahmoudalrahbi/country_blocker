import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A statistics card widget for displaying metrics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final String? trend;
  final bool? isTrendPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.trend,
    this.isTrendPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(Spacing.s),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.m),
            
            // Value
            Text(
              value,
              style: theme.textTheme.displaySmall, // Uses default 24px from AppTheme
            ),
            const SizedBox(height: Spacing.xs),
            
            // Subtitle or trend
            if (trend != null && isTrendPositive != null)
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Flexible(
                    child: Text(
                      trend!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.success, // Keeping specific success color or map to a semantic "success" if we had one. 
                        // We mapped error but not success in ColorScheme officially (unless we use tertiary/etc).
                        // I'll stick to AppColors.success for now as it's not in basic ColorScheme 
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            else if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.labelSmall,
              ),
          ],
        ),
      ),
    );
  }
}
