import 'package:flutter/material.dart';

/// MasterFabric example design tokens — modern, airy, ink + teal accent.
/// Avoids generic purple / cream-serif AI aesthetics.
class AppTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color bg = Color(0xFFF4F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color ink = Color(0xFF0F172A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color accent = Color(0xFF0F766E);
  static const Color accentSoft = Color(0xFFCCFBF1);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);

  static const double borderWidth = 1.0;
  static const double radius = 16.0;
  static const double radiusSm = 12.0;
  static const double radiusXs = 8.0;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: ink.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
