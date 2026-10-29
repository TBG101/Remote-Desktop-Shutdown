import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/screens/home/widgets/connection_tips.dart';

/// Radar-style pulse shown while no host has been found yet.
class SearchingState extends StatefulWidget {
  const SearchingState({super.key});

  @override
  State<SearchingState> createState() => _SearchingStateState();
}

class _SearchingStateState extends State<SearchingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      for (final offset in const [0.0, 0.33, 0.66])
                        _ring((_controller.value + offset) % 1.0, scheme),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_find_rounded,
                          size: 30,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Looking for devices',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const ConnectionTipsCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _ring(double t, ColorScheme scheme) {
    final size = 64 + 116 * Curves.easeOut.transform(t);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: scheme.primary.withValues(alpha: (1 - t) * 0.5),
          width: 2,
        ),
      ),
    );
  }
}
