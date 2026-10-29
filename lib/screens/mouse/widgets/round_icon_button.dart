import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.foreground,
    this.background,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? foreground;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        style: IconButton.styleFrom(
          foregroundColor: foreground ?? AppColors.textPrimary,
          backgroundColor: background ?? AppColors.surfaceHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
