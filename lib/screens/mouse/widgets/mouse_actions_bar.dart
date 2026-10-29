import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/mouse_buttons.dart';

/// Left, middle and right mouse buttons.
class MouseActionsBar extends StatelessWidget {
  const MouseActionsBar({
    super.key,
    required this.onLeftDown,
    required this.onLeftUp,
    required this.onMiddle,
    required this.onRight,
  });

  final VoidCallback onLeftDown;
  final VoidCallback onLeftUp;
  final VoidCallback onMiddle;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MouseButtonWidget(
            onTapDown: onLeftDown,
            onTapUp: onLeftUp,
          ),
        ),
        const SizedBox(width: 8),
        MouseButtonWidget(width: 44, onTap: onMiddle),
        const SizedBox(width: 8),
        Expanded(
          child: MouseButtonWidget(onTap: onRight),
        ),
      ],
    );
  }
}
