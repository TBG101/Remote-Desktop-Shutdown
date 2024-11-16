import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/Class/sendpacket.dart';
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
      home: const MyHomePage(),
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

  var msg = "shutdown";

  final ip = "192.168.1.255";

  var port = 8888;

  @override
  void initState() {
    super.initState();
    sendPacket.receivePacket().then((socket) {
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = socket.receive();
          if (dg == null) return;
          if (!utf8.decode(dg.data).contains("cmd")) {
            setState(() {
              commandLineHistory.add("- ${utf8.decode(dg.data)}");
            });
          }
        }
      });
    });
  }

  var commandLineHistory = <String>[];

  var texteditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: CarouselSlider(
          options: CarouselOptions(
            height: size.height,
            padEnds: false,
            viewportFraction: 1,
          ),
          items: [
            Container(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: SizedBox(
                  width: size.width,
                  child: ShutdownButton(
                    callback: () {
                      sendPacket.sendPacket(msg, ip, port);
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...commandLineHistory.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                e,
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          },
                        ),
                        TextField(
                          controller: texteditingController,
                          onSubmitted: (value) {
                            print(texteditingController.text);
                            sendPacket.sendPacket(
                                "cmd ${texteditingController.text}", ip, port);
                            setState(() {
                              commandLineHistory.add("> $value");
                            });
                            texteditingController.clear();
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: '>',
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
