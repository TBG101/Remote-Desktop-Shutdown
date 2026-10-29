import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

/// Title, rescan button and live status pill.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.count,
    required this.hasError,
    required this.onRescan,
  });

  final int count;
  final bool hasError;
  final VoidCallback onRescan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String label;
    final Color accent;
    final Widget leading;

    if (hasError) {
      label = 'Discovery stopped';
      accent = AppColors.danger;
      leading = Icon(Icons.error_outline_rounded, size: 16, color: accent);
    } else if (count == 0) {
      label = 'Scanning your network';
      accent = theme.colorScheme.primary;
      leading = SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(strokeWidth: 2, color: accent),
      );
    } else {
      label = '$count device${count == 1 ? '' : 's'} found';
      accent = AppColors.success;
      leading = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Devices',
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: 'Rescan',
                onPressed: onRescan,
                icon: const Icon(Icons.refresh_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceHigh,
                  foregroundColor: AppColors.textPrimary,
                  fixedSize: const Size(46, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Pick a computer to control',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: ValueKey(label),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leading,
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(color: accent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
