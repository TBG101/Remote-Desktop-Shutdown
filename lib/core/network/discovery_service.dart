import 'dart:async';
import 'package:nsd/nsd.dart';
import 'package:remote_shutdown_desktop/core/model/r_desk_host.dart';

class DiscoveryService {
  static const serviceType = '_rdesk._udp';

  Discovery? _discovery;
  final _found = <String, RdeskHost>{};
  final _controller = StreamController<List<RdeskHost>>.broadcast();

  Stream<List<RdeskHost>> get hosts => _controller.stream;

  Future<void> start() async {
    await stop();
    _discovery = await startDiscovery(
      serviceType,
      autoResolve: true,
      ipLookupType: IpLookupType.v4, // gives you service.addresses
    );

    _discovery!.addServiceListener((service, status) {
      final name = service.name ?? 'unknown';

      if (status == ServiceStatus.found) {
        final ip = service.addresses?.firstOrNull?.address;
        final port = service.port;
        if (ip == null || port == null) return;
        _found[name] = RdeskHost(name, ip, port);
      } else {
        _found.remove(name);
      }
      _controller.add(_found.values.toList());
    });
  }

  List<RdeskHost> get current => _found.values.toList();

  Future<void> stop() async {
    final d = _discovery;
    _discovery = null;
    if (d != null) await stopDiscovery(d);
    _found.clear();
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
