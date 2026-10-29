import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/network/protocol.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

/// Media and volume controls, grouped and evenly sized so they fit narrow
/// screens.
class MediaControlBar extends StatelessWidget {
  const MediaControlBar({
    super.key,
    required this.onMedia,
    required this.onVolume,
  });

  final ValueChanged<MediaAction> onMedia;
  final ValueChanged<VolumeAction> onVolume;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _ControlGroup(
            children: [
              _GroupButton(
                icon: Icons.skip_previous_rounded,
                tooltip: 'Previous',
                onPressed: () => onMedia(MediaAction.previous),
              ),
              _GroupButton(
                icon: Icons.play_arrow_rounded,
                tooltip: 'Play',
                onPressed: () => onMedia(MediaAction.play),
              ),
              _GroupButton(
                icon: Icons.stop_rounded,
                tooltip: 'Stop',
                onPressed: () => onMedia(MediaAction.stop),
              ),
              _GroupButton(
                icon: Icons.skip_next_rounded,
                tooltip: 'Next',
                onPressed: () => onMedia(MediaAction.next),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: _ControlGroup(
            children: [
              _GroupButton(
                icon: Icons.volume_off_rounded,
                tooltip: 'Mute',
                onPressed: () => onVolume(VolumeAction.mute),
              ),
              _GroupButton(
                icon: Icons.volume_down_rounded,
                tooltip: 'Volume down',
                onPressed: () => onVolume(VolumeAction.down),
              ),
              _GroupButton(
                icon: Icons.volume_up_rounded,
                tooltip: 'Volume up',
                onPressed: () => onVolume(VolumeAction.up),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ControlGroup extends StatelessWidget {
  const _ControlGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [for (final child in children) Expanded(child: child)],
      ),
    );
  }
}

class _GroupButton extends StatelessWidget {
  const _GroupButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
