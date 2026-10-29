import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/pad_surface.dart';

/// Pointer pad. A tap is a left click, a drag moves the cursor.
class Touchpad extends StatelessWidget {
  const Touchpad({
    super.key,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onTap,
  });

  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onTap: onTap,
      child: const PadSurface(
        color: AppColors.surface,
        icon: Icons.touch_app_rounded,
        label: 'Touchpad',
      ),
    );
  }
}
