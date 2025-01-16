import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/const_values.dart';
import 'package:remote_shutdown_desktop/model/sendpacket.dart';
import 'package:remote_shutdown_desktop/mouse_screen.dart';
import 'package:remote_shutdown_desktop/widgets/command_line.dart';
import 'package:remote_shutdown_desktop/widgets/my_dropdown.dart';
import 'package:remote_shutdown_desktop/widgets/shutdown_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      theme: ThemeData.dark(),
      home: const SafeArea(child: MyHomePage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SendPacket sendPacket = SendPacket();
  final listOfHosts = <String>[];

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    sendPacket.receivePacket().then((socket) {
      socket.listen((event) {
        if (event != RawSocketEvent.read) return;

        Datagram? dg = socket.receive();
        if (dg == null) return;

        final data = utf8.decode(dg.data).trim();
        if (data.isEmpty) return;

        _handleReceivedData(data);
      });

      sendPacket.sendPacket("get_device", ip, port);
    });
  }

  void _handleReceivedData(String data) {
    if (data.contains("cmd")) {
      final response = data.replaceAll("cmd", "").trim();
      commandLineHistory.add(
          "- $response - {${selectedHost.isEmpty ? "Broadcast" : selectedHost}}");

      setState(() {});
    } else if (data.startsWith("device:")) {
      if (data.isEmpty) return;
      final newHost = data.replaceAll("device:", "").trim();
      if (!listOfHosts.contains(newHost)) {
        setState(() {
          listOfHosts.add(newHost);
        });
      }
    } else {
      print("Received: $data");
    }
  }

  final commandLineHistory = <String>[];

  final texteditingController = TextEditingController();

  var selectedHost = "";

  void onShutdownPressed() {
    if (selectedHost.isEmpty) {
      sendPacket.sendPacket("shutdown all", ip, port);
    } else {
      sendPacket.sendPacket("shutdown $selectedHost", ip, port);
    }
  }

  void onCommandSent(String? value) {
    if (selectedHost.isEmpty) {
      sendPacket.sendPacket("cmd all ${texteditingController.text}", ip, port);
    } else {
      sendPacket.sendPacket(
          "cmd $selectedHost ${texteditingController.text}", ip, port);
    }
    setState(() {
      commandLineHistory.add("> $value - | $selectedHost |");
    });
    texteditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: size.height,
              padEnds: false,
              viewportFraction: 1,
            ),
            items: [
              ShutdownButton(
                callback: onShutdownPressed,
              ),
              CommandLineInputWidget(
                  onCommandSent: onCommandSent,
                  commandLineHistory: commandLineHistory,
                  texteditingController: texteditingController)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: MyDropdown(
                      dropDownValue:
                          selectedHost.isEmpty ? "Broadcast" : selectedHost,
                      listOfHosts: listOfHosts,
                      onChanged: (value) {
                        setState(() {
                          selectedHost = value ?? "";
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800]),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            )),
                        onPressed: () {
                          sendPacket.sendPacket("get_device", ip, port);
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800]),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MouseScreen(
                                      hostName: selectedHost,
                                    )),
                          );
                        },
                        icon: const Icon(Icons.mouse_rounded)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
