import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/pad_surface.dart';

/// Narrow strip that turns vertical and horizontal drags into scroll events.
class ScrollStrip extends StatelessWidget {
  const ScrollStrip({
    super.key,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.onHorizontalDragUpdate,
    required this.onHorizontalDragEnd,
  });

  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final GestureDragUpdateCallback onHorizontalDragUpdate;
  final GestureDragEndCallback onHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      onHorizontalDragUpdate: onHorizontalDragUpdate,
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: const PadSurface(
        color: AppColors.surfaceHigh,
        icon: Icons.unfold_more_rounded,
        label: 'Scroll',
        compact: true,
      ),
    );
  }
}
