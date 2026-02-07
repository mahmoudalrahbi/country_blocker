import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// A status card widget displaying the current blocking status
class StatusCard extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onToggle;

  const StatusCard({
    super.key,
    required this.isActive,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero gradient image
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Radial overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Lock icon
                Center(
                  child: Icon(
                    Icons.phonelink_lock,
                    size: 70,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),

          // Status content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator row
                Row(
                  children: [
                    _PulsingDot(isActive: isActive),
                    const SizedBox(width: 8),
                    Text(
                      'PROTECTION STATUS',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  isActive ? 'Blocking Active' : 'Blocking Disabled',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  isActive
                      ? 'Incoming calls from your blocked country list are being automatically rejected.'
                      : 'Call blocking is currently disabled. Enable it to start blocking unwanted calls.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Toggle button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onToggle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? Icons.pause_circle : Icons.play_circle,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isActive ? 'Disable Blocking' : 'Enable Blocking',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated pulsing dot for status indicator
class _PulsingDot extends StatefulWidget {
  final bool isActive;

  const _PulsingDot({required this.isActive});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      // Disabled state - use red color with subtle pulse
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: _animation.value * 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: _animation.value),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
