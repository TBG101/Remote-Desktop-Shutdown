import 'package:remote_shutdown_desktop/model/sendpacket.dart';

void main() {
  SendPacket().sendPacket("cmd start chrome.exe", "192.168.1.255", 8888);
}
