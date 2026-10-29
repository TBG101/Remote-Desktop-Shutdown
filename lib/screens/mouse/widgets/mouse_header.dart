import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/round_icon_button.dart';

/// Back button, connected host label and shutdown action.
class MouseHeader extends StatelessWidget {
  const MouseHeader({
    super.key,
    required this.address,
    required this.onBack,
    required this.onShutdown,
  });

  final String address;
  final VoidCallback onBack;
  final VoidCallback onShutdown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: onBack,
          tooltip: 'Back',
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        RoundIconButton(
          icon: Icons.power_settings_new_rounded,
          onPressed: onShutdown,
          tooltip: 'Shut down',
          foreground: AppColors.danger,
          background: AppColors.danger.withValues(alpha: 0.14),
        ),
      ],
    );
  }
}
