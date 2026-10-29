import 'dart:io';
import 'package:remote_shutdown_desktop/core/network/protocol.dart';

class RemoteClient {
  final String host;
  final int port;

  RawDatagramSocket? _socket;

  RemoteClient({required this.host, this.port = 8888});

  Future<void> connect() async {
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
    );
  }

  void send(Command command, [Map<String, dynamic> payload = const {}]) {
    final socket = _socket;
    if (socket == null) {
      throw StateError('Call connect() first');
    }

    socket.send(
      Protocol.encode(command, payload),
      InternetAddress(host),
      port,
    );
  }

  void dispose() {
    _socket?.close();
    _socket = null;
  }
}
