import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

/// Short checklist of the usual reasons a PC does not show up.
class ConnectionTipsCard extends StatelessWidget {
  const ConnectionTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Column(
        children: [
          _TipRow(
            icon: Icons.dns_rounded,
            text: 'The server is running on your PC',
          ),
          SizedBox(height: 10),
          _TipRow(
            icon: Icons.wifi_rounded,
            text: 'Both devices are on the same Wi-Fi network',
          ),
          SizedBox(height: 10),
          _TipRow(
            icon: Icons.shield_outlined,
            text: 'The firewall allows the app on your PC',
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
