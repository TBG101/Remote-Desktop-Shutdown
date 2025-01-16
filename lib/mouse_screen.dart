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

  void mouseMove(String hostName, Offset delta) {
    if (hostName.isEmpty || hostName == "Broadcast") hostName = "all";
    print("mouse move $hostName ${delta.dx} ${delta.dy}");
    sendPacket.sendPacket(
        "mouse move $hostName ${delta.dx} ${delta.dy}", ip, port);
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

  Duration? lastMove;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: SizedBox(
                width: size.width,
                height: size.height - 120,
                child: Row(
                  children: [
                    GestureDetector(
                      onTapUp: (details) {
                        onLeftClickUp(widget.hostName);
                      },
                      onTapDown: (details) {
                        onLeftClickDown(widget.hostName);
                      },
                      onLongPress: () {
                        onRightClick(widget.hostName);
                      },
                      onPanStart: (details) {
                        lastMove = details.sourceTimeStamp;
                      },
                      onPanUpdate: (details) {
                        if (lastMove != null) {
                          final currentMove = details.sourceTimeStamp;
                          final delta = currentMove! - lastMove!;
                          print(delta);
                          if (delta.inMilliseconds > 20) {
                            mouseMove(widget.hostName, details.delta);
                            lastMove = currentMove;
                          }
                        }
                      },
                      onPanEnd: (details) {
                        lastMove = null;
                        onLeftClickUp(widget.hostName);
                        print("End");
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
    );
  }
}
