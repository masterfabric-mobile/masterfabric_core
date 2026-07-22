import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

import '../data/models/app_icon_style.dart';

/// Applies [AppIconStyle] to the OS home-screen icon when supported.
abstract final class AppIconService {
  static Future<bool> supportsAlternateIcons() async {
    if (kIsWeb) return false;
    try {
      return await FlutterDynamicIconPlus.supportsAlternateIcons;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> apply(AppIconStyle style) async {
    if (kIsWeb) return;
    try {
      final supported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!supported) return;
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: style.alternateIconName,
        blacklistBrands: const ['Redmi'],
        blacklistManufactures: const ['Xiaomi'],
        blacklistModels: const ['Redmi 200A'],
      );
    } on PlatformException catch (e) {
      debugPrint('AppIconService.apply failed: ${e.message}');
    } on MissingPluginException {
      // Simulator / desktop — ignore.
    } catch (e) {
      debugPrint('AppIconService.apply failed: $e');
    }
  }
}
