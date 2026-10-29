import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

/// Rounded, bordered surface used by the touchpad and the scroll strip.
class PadSurface extends StatelessWidget {
  const PadSurface({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.compact = false,
  });

  final Color color;
  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: compact ? 22 : 32,
              color: AppColors.textGhost,
            ),
            if (!compact) ...[
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textGhost,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
