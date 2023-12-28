// ignore: file_names
import 'dart:convert';
import 'dart:io';

class SendPacket {
  static void sendPacket(String message, String adress, int port) async {
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
}
