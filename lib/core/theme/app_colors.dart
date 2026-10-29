import 'package:flutter/material.dart';

/// The app's neutral dark palette.
///
/// These are the raw values the screens are drawn with. Material widgets get
/// their colours from [AppTheme]; everything custom reads from here.
abstract final class AppColors {
  /// Scaffold background.
  static const background = Color(0xFF0E0E10);

  /// Cards, control groups and the touchpad.
  static const surface = Color(0xFF1A1A1E);

  /// Raised surfaces: icon buttons, device icon tile, scroll strip.
  static const surfaceHigh = Color(0xFF232328);

  /// Prominent outline (white12).
  static const border = Color(0x1FFFFFFF);

  /// Subtle outline inside groups and tip cards (white10).
  static const borderSubtle = Color(0x1AFFFFFF);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xB3FFFFFF); // white70
  static const textMuted = Color(0x8AFFFFFF); // white54
  static const textFaint = Color(0x61FFFFFF); // white38
  static const textGhost = Color(0x3DFFFFFF); // white24

  /// Connected host indicator.
  static const success = Color(0xFF69F0AE); // greenAccent

  /// Destructive actions.
  static const danger = Color(0xFFFF5252); // redAccent

  /// Mouse button body.
  static const mouseButton = Color(0xFF424242); // grey[800]
}
