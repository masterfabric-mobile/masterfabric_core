import 'package:flutter/services.dart';

import '../data/fitness_calculator.dart';

/// Bridges Flutter → iOS WidgetKit / Live Activities / Watch snapshot.
abstract final class AuraPlatform {
  static const _channel = MethodChannel('aura/platform');

  static void listenDeepLinks(void Function(String route) onRoute) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'deepLink') return;
      final raw = call.arguments as String?;
      if (raw == null || raw.isEmpty) return;
      final route = routeFromDeepLink(raw);
      if (route != null) onRoute(route);
    });
  }

  /// `aura://today` → `/home`, `aura://log` → `/log`,
  /// `aura://today?action=water` → `/home?action=water`.
  static String? routeFromDeepLink(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null || uri.scheme != 'aura') return null;
    final pathTarget =
        uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    final target = (uri.host.isNotEmpty ? uri.host : pathTarget)?.toLowerCase();
    final path = switch (target) {
      'today' || 'home' || null || '' => '/home',
      'log' => '/log',
      'body' => '/body',
      'coach' => '/coach',
      'water' => '/home?action=water',
      'food' || 'meal' => '/home?action=food',
      'burn' => '/home?action=burn',
      _ => '/home',
    };
    if (path.contains('?')) return path;
    if (uri.queryParameters.isEmpty) return path;
    return Uri(path: path, queryParameters: uri.queryParameters).toString();
  }

  static Future<void> sync(DaySummary summary) async {
    try {
      await _channel.invokeMethod<void>('updateSnapshot', {
        'remaining': summary.remaining,
        'goal': summary.goal,
        'eaten': summary.eaten,
        'burned': summary.burned,
        'waterMl': summary.waterMl,
        'protein': summary.protein,
        'carbs': summary.carbs,
        'fat': summary.fat,
        'warning': summary.warnings.isEmpty ? '' : summary.warnings.first,
      });
    } catch (_) {}
  }

  static Future<bool> startLiveActivity() async {
    try {
      await _channel.invokeMethod<void>('startLiveActivity');
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> endLiveActivity() async {
    try {
      await _channel.invokeMethod<void>('endLiveActivity');
    } catch (_) {}
  }

  static Future<void> reloadWidgets() async {
    try {
      await _channel.invokeMethod<void>('reloadWidgets');
    } catch (_) {}
  }
}
