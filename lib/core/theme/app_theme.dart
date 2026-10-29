import 'package:flutter/material.dart';
import 'package:remote_shutdown_desktop/core/theme/app_colors.dart';

/// Single source of truth for the app's dark theme.
///
/// Built from [ThemeData.dark] rather than a seed colour so the Material
/// defaults (typography, lavender primary used by the radar pulse) stay as
/// they are, and only the surface values are re-pointed at [AppColors].
abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.background,
        outline: AppColors.border,
        outlineVariant: AppColors.borderSubtle,
      ),
    );
  }
}
