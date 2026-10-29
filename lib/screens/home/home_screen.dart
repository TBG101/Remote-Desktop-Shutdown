import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_shutdown_desktop/core/model/r_desk_host.dart';
import 'package:remote_shutdown_desktop/core/network/discovery_service.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/animated_entry.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/device.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/discovery_error.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/home_header.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/searching_state.dart';
import 'package:remote_shutdown_desktop/screens/mouse/mouse_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiscoveryService discovery = DiscoveryService();

  @override
  void initState() {
    super.initState();
    discovery.start();
  }

  void _open(RdeskHost host) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) => MouseScreen(host: host),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> _rescan() async {
    HapticFeedback.selectionClick();
    discovery.start();
    // Give the spinner a moment so the refresh feels acknowledged.
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<RdeskHost>>(
          stream: discovery.hosts,
          initialData: discovery.current,
          builder: (context, snap) {
            final hosts = snap.data ?? const <RdeskHost>[];

            return RefreshIndicator(
              onRefresh: _rescan,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      count: hosts.length,
                      hasError: snap.hasError,
                      onRescan: _rescan,
                    ),
                  ),
                  if (snap.hasError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: DiscoveryError(onRetry: _rescan),
                    )
                  else if (hosts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: SearchingState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverList.builder(
                        itemCount: hosts.length,
                        itemBuilder: (context, i) => AnimatedEntry(
                          key: ValueKey(hosts[i].address),
                          index: i,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Device(
                              host: hosts[i],
                              onClick: () => _open(hosts[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
