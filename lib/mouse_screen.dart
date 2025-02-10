import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/const_values.dart';
import 'package:remote_shutdown_desktop/model/sendpacket.dart';
import 'package:remote_shutdown_desktop/widgets/mouse_buttons.dart';

class MouseScreen extends StatefulWidget {
  final String hostName;

  const MouseScreen({super.key, required this.hostName});

  @override
  State<MouseScreen> createState() => _MouseScreenState();
}

class _MouseScreenState extends State<MouseScreen> {
  SendPacket sendPacket = SendPacket();

  void onRightClick(String hostName) {
    if (hostName.isEmpty || hostName == "Broadcast") hostName = "all";

    sendPacket.sendPacket("mouse $hostName right click", ip, port);
  }

  void onLeftClick(String hostName) {
    print("left click");
    if (hostName.isEmpty || hostName == "Broadcast") hostName = "all";

    sendPacket.sendPacket("mouse $hostName left click", ip, port);
  }

  void onMiddleClick(String hostName) {
    if (hostName.isEmpty || hostName == "Broadcast") hostName = "all";

    sendPacket.sendPacket("mouse $hostName middle click", ip, port);
  }

  void mouseMove(String hostName, Offset delta, double sensitivity) {
    if (hostName.isEmpty || hostName == "Broadcast") hostName = "all";
    sendPacket.sendPacket(
        "mouse move $hostName ${delta.dx * sensitivity} ${delta.dy * sensitivity}",
        ip,
        port);
  }

  void onRightClickDown(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("mouse $hostname right click down", ip, port);
  }

  void onRightClickUp(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("mouse $hostname right click up", ip, port);
  }

  void onLeftClickDown(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";

    sendPacket.sendPacket("mouse $hostname left click down", ip, port);
  }

  void onLeftClickUp(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("mouse $hostname left click up", ip, port);
  }

  void scroll(String hostname, int delta) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("mouse $hostname scroll $delta", ip, port);
  }

  void onMute(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("sound mute", ip, port);
  }

  void onVolumeDown(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("sound volume down", ip, port);
  }

  void onVolumeUp(String hostname) {
    if (hostname.isEmpty || hostname == "Broadcast") hostname = "all";
    sendPacket.sendPacket("sound volume up", ip, port);
  }

  Duration? lastMove;
  DateTime lastTap = DateTime.now();
  bool isDragging = false;
  bool isClickDown = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 0, top: 8, left: 10, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSmallButton(() => Navigator.pop(context),
                        Icons.arrow_back_ios_new_rounded),
                    const Spacer(),
                    _buildSmallButton(() => onMute(widget.hostName),
                        Icons.volume_off_rounded),
                    _buildSmallButton(() => onVolumeDown(widget.hostName),
                        Icons.volume_down_rounded),
                    _buildSmallButton(() => onVolumeUp(widget.hostName),
                        Icons.volume_up_rounded),
                    _buildSmallButton(() => {}, Icons.keyboard_alt_rounded),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: SizedBox(
                  width: size.width,
                  height: size.height - 120 - 42 - 8 * 2,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTapUp: (details) {
                          // if (isDragging) return;

                          // if (lastTap.difference(DateTime.now()).inMilliseconds <
                          //     80) {
                          //   onLeftClickUp(widget.hostName);
                          //   isClickDown = false;
                          // }
                        },
                        onTapDown: (details) {
                          final now = DateTime.now();
                          if (isDragging) return;

                          Future.delayed(const Duration(milliseconds: 100), () {
                            print(now.difference(lastTap).inMilliseconds);
                            if (now.difference(lastTap).inMilliseconds < 500) {
                              onLeftClickDown(widget.hostName);
                              isClickDown = true;
                            } else {
                              onLeftClick(widget.hostName);
                            }
                            lastTap = DateTime.now();
                          });
                        },
                        onLongPress: () {
                          onRightClick(widget.hostName);
                        },
                        onPanStart: (details) {
                          lastMove = details.sourceTimeStamp;
                        },
                        onPanUpdate: (details) {
                          if (lastMove == null) return;
                          isDragging = true;
                          final currentMove = details.sourceTimeStamp;
                          final delta = currentMove! - lastMove!;
                          if (delta.inMilliseconds > 20) {
                            mouseMove(widget.hostName, details.delta, 1.2);
                            lastMove = currentMove;
                          }
                        },
                        onPanEnd: (details) {
                          lastMove = null;
                          isDragging = false;

                          if (isClickDown) {
                            onLeftClickUp(widget.hostName);
                            isClickDown = false;
                          }
                        },
                        child: Container(
                            height: size.height - 120,
                            width: size.width - 50 - 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                color: const Color.fromARGB(111, 255, 255, 255),
                                width: 1,
                              ),
                            ),
                            child: const SizedBox.shrink()),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.primaryDelta == null) return;

                            if (details.primaryDelta! > 0) {
                              scroll(widget.hostName, -1);
                            } else {
                              scroll(widget.hostName, 1);
                            }
                          },
                          child: Container(
                            height: size.height - 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              border: Border.all(
                                color: const Color.fromARGB(111, 255, 255, 255),
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            margin: const EdgeInsets.only(left: 5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MouseButtonWidget(
                          onTapDown: () => onLeftClickDown(widget.hostName),
                          onTapUp: () => onLeftClickUp(widget.hostName)),
                    ),
                    MouseButtonWidget(
                        width: 44, onTap: () => onMiddleClick(widget.hostName)),
                    Expanded(
                        child: MouseButtonWidget(
                      onTap: () => onRightClick(widget.hostName),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(void Function() onPressed, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: SizedBox(
        height: 50,
        width: 50,
        child: IconButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              )),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
