import 'package:flutter/material.dart';
import 'package:sendpacket/Class/sendpacket.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        child: IconButton(
          padding: const EdgeInsets.all(0),
          splashRadius: 100,
          iconSize: 200,
          splashColor: Colors.greenAccent,
          style: ElevatedButton.styleFrom(),
          icon: Image.asset("lib/assets/power.png"),
          onPressed: () {
            SendPacket.sendPacket("shutdown", "192.168.1.255", 8888);
          },
        ),
      )),
    );
  }
}
