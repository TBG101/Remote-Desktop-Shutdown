import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_shutdown_desktop/core/model/r_desk_host.dart';
import 'package:remote_shutdown_desktop/core/network/protocol.dart';
import 'package:remote_shutdown_desktop/core/network/remote_client.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/media_control_bar.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/mouse_actions_bar.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/mouse_header.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/scroll_strip.dart';
import 'package:remote_shutdown_desktop/screens/mouse/widgets/touchpad.dart';

class MouseScreen extends StatefulWidget {
  final RdeskHost host;

  const MouseScreen({super.key, required this.host});

  @override
  State<MouseScreen> createState() => _MouseScreenState();
}

class _MouseScreenState extends State<MouseScreen> {
  static const double _pointerSensitivity = 1.4;
  static const double _scrollSensitivity = 1.0;

  late final RemoteClient remoteClient;

  // Fractional movement is accumulated so slow, small drags are not lost
  // to rounding.
  double _moveRemX = 0;
  double _moveRemY = 0;
  double _scrollRemY = 0;
  double _scrollRemX = 0;

  @override
  void initState() {
    super.initState();
    remoteClient = RemoteClient(host: widget.host.address);
    remoteClient.connect();
  }

  @override
  void dispose() {
    remoteClient.dispose();
    super.dispose();
  }

  void _send(Command command, [Map<String, dynamic> payload = const {}]) {
    try {
      remoteClient.send(command, payload);
    } catch (e) {
      debugPrint('Failed to send command: $e');
    }
  }

  void _sendMedia(MediaAction action) {
    HapticFeedback.selectionClick();
    _send(Command.media, Protocol.media(action));
  }

  void _sendVolume(VolumeAction action) {
    HapticFeedback.selectionClick();
    _send(Command.volume, Protocol.volume(action));
  }

  Future<void> _confirmShutdown() async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.power_settings_new_rounded, size: 32),
        title: const Text('Shut down PC?'),
        content: Text(
          '${widget.host.address} will be turned off.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Shut down'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _send(Command.shutdown);
    }
  }

  void _onTouchpadMove(DragUpdateDetails details) {
    _moveRemX += details.delta.dx * _pointerSensitivity;
    _moveRemY += details.delta.dy * _pointerSensitivity;

    final dx = _moveRemX.truncate();
    final dy = _moveRemY.truncate();

    if (dx != 0 || dy != 0) {
      _moveRemX -= dx;
      _moveRemY -= dy;
      _send(Command.mouseMove, Protocol.mouseMove(dx, dy));
    }
  }

  void _onScrollVertical(DragUpdateDetails details) {
    _scrollRemY += details.delta.dy * _scrollSensitivity;
    final amount = _scrollRemY.truncate();
    if (amount != 0) {
      _scrollRemY -= amount;
      _send(
        Command.mouseScroll,
        Protocol.mouseScroll(amount: -amount, axis: 1),
      );
    }
  }

  void _onScrollHorizontal(DragUpdateDetails details) {
    _scrollRemX += details.delta.dx * _scrollSensitivity;
    final amount = _scrollRemX.truncate();
    if (amount != 0) {
      _scrollRemX -= amount;
      _send(
        Command.mouseScroll,
        Protocol.mouseScroll(amount: amount, axis: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              children: [
                MouseHeader(
                  address: widget.host.address,
                  onBack: () => Navigator.pop(context),
                  onShutdown: _confirmShutdown,
                ),
                const SizedBox(height: 10),
                MediaControlBar(
                  onMedia: _sendMedia,
                  onVolume: _sendVolume,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Touchpad(
                          onPanUpdate: _onTouchpadMove,
                          onPanEnd: (_) {
                            _moveRemX = 0;
                            _moveRemY = 0;
                          },
                          // Tap on the pad = left click
                          onTap: () {
                            HapticFeedback.selectionClick();
                            _send(
                              Command.mouseClick,
                              Protocol.mouseClick(
                                MouseButton.left,
                                ClickAction.click,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ScrollStrip(
                          onVerticalDragUpdate: _onScrollVertical,
                          onVerticalDragEnd: (_) => _scrollRemY = 0,
                          onHorizontalDragUpdate: _onScrollHorizontal,
                          onHorizontalDragEnd: (_) => _scrollRemX = 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MouseActionsBar(
                  onLeftDown: () {
                    HapticFeedback.lightImpact();
                    _send(
                      Command.mouseClick,
                      Protocol.mouseClick(MouseButton.left, ClickAction.press),
                    );
                  },
                  onLeftUp: () => _send(
                    Command.mouseClick,
                    Protocol.mouseClick(
                      MouseButton.left,
                      ClickAction.release,
                    ),
                  ),
                  onMiddle: () {
                    HapticFeedback.lightImpact();
                    _send(
                      Command.mouseClick,
                      Protocol.mouseClick(
                        MouseButton.middle,
                        ClickAction.click,
                      ),
                    );
                  },
                  onRight: () {
                    HapticFeedback.lightImpact();
                    _send(
                      Command.mouseClick,
                      Protocol.mouseClick(MouseButton.right, ClickAction.click),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
