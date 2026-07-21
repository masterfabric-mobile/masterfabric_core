import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'aura_theme.dart';

/// Reads `uiConfiguration` from masterfabric_core [AssetConfigHelper]
/// and builds AURA [ThemeData] / [ThemeMode] / font scale.
abstract final class AuraThemeConfig {
  static AssetConfigHelper get _config => AssetConfigHelper();

  static ThemeMode themeMode() {
    final raw =
        _config.getString('uiConfiguration.themeMode', 'light').toLowerCase();
    return switch (raw) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
  }

  static double fontScale() {
    return _config.getDouble('uiConfiguration.fontScale', 1.0).clamp(0.85, 1.35);
  }

  static bool devModeGrid() =>
      _config.getBool('uiConfiguration.devModeGrid', false);

  static bool devModeSpacer() =>
      _config.getBool('uiConfiguration.devModeSpacer', false);

  static ThemeData light() => AuraTheme.light();

  static ThemeData dark() {
    // AURA stays black–white; dark inverts paper/ink surfaces.
    final base = AuraTheme.light();
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AuraTheme.ink,
      colorScheme: const ColorScheme.dark(
        primary: AuraTheme.paper,
        onPrimary: AuraTheme.ink,
        secondary: AuraTheme.paper,
        onSecondary: AuraTheme.ink,
        surface: Color(0xFF121212),
        onSurface: AuraTheme.paper,
        error: AuraTheme.paper,
        onError: AuraTheme.ink,
      ),
    );
  }

  static List<String> supportedLocales() {
    final raw = _config.getAllConfig()?['localizationConfiguration'];
    if (raw is Map && raw['supportedLocales'] is List) {
      return (raw['supportedLocales'] as List)
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return const ['en', 'tr'];
  }

  static String defaultLocale() {
    final value = _config.getString('localizationConfiguration.defaultLocale', 'en');
    return value.isEmpty ? 'en' : value;
  }
}
