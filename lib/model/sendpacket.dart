// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class SendPacket {
  StreamSubscription<RawSocketEvent>? cmdStream;

  Future<void> widgetButton(String message, String adress, int port) async {
    print("working somehow");
    const platform = MethodChannel('channel');

    try {
      platform.setMethodCallHandler((call) async {
        switch (call.method) {
          case "pressed":
            sendPacket(message, adress, port);
            break;
        }
      });
    } on PlatformException catch (e) {
      throw ("error: $e");
    }
  }

  Future<void> sendPacket(String message, String adress, int port) async {
    final InternetAddress destinationAddress = InternetAddress(adress);

    List<int> messageBytes = utf8.encode(message);
    RawDatagramSocket socket =
        await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
            .then((RawDatagramSocket udpSocket) {
      udpSocket.broadcastEnabled = true;

      return udpSocket;
    });

    socket.send(messageBytes, destinationAddress, port);
  }

  // receive packet
  Future<RawDatagramSocket> receivePacket() async {
    return await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
  }

  void closeCmdReceiver() {
    cmdStream?.cancel();
  }
}
