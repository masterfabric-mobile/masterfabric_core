import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:masterfabric_core/src/helper/url_launcher_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/force_update_models.dart';

/// Handles redirecting users to app stores
class StoreRedirector {
  /// Store configuration
  final StoreConfig config;

  StoreRedirector({required this.config});

  /// Get the appropriate store URL for the current platform
  String? get storeUrl {
    if (kIsWeb) {
      // For web, prefer custom URL or Android store
      return config.customUrl ?? config.effectiveAndroidUrl;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return config.effectiveIosUrl ?? config.customUrl;
    }

    if (Platform.isAndroid) {
      return config.effectiveAndroidUrl ?? config.customUrl;
    }

    // Fallback to custom URL for other platforms
    return config.customUrl;
  }

  /// Open the app store
  Future<bool> openStore() async {
    final url = storeUrl;

    if (url == null || url.isEmpty) {
      debugPrint('StoreRedirector: No store URL configured');
      return false;
    }

    return openUrl(url);
  }

  /// Open a specific URL (scheme allowlisted via [UrlLauncherHelper]).
  Future<bool> openUrl(String url) async {
    try {
      final launched = await UrlLauncherHelper.launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;

      final uri = Uri.parse(url);
      // Fallback: try platform default only if allowlisted
      if (!await UrlLauncherHelper.canLaunch(url)) return false;
      return await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } catch (e) {
      debugPrint('StoreRedirector error: $e');
      return false;
    }
  }

  /// Check if the store URL is available
  bool get hasStoreUrl => storeUrl != null && storeUrl!.isNotEmpty;

  /// Get the store name for the current platform
  String get storeName {
    if (kIsWeb) return 'Store';

    if (Platform.isIOS || Platform.isMacOS) {
      return 'App Store';
    }

    if (Platform.isAndroid) {
      return 'Play Store';
    }

    return 'Store';
  }

  /// Check if we can open the store
  Future<bool> canOpenStore() async {
    final url = storeUrl;
    if (url == null || url.isEmpty) return false;

    try {
      return await canLaunchUrl(Uri.parse(url));
    } catch (e) {
      return false;
    }
  }

  /// Get iOS-specific URL schemes for direct App Store launch
  String? get iosAppStoreSchemeUrl {
    if (config.appStoreId != null) {
      return 'itms-apps://apps.apple.com/app/id${config.appStoreId}';
    }
    return null;
  }

  /// Get Android-specific URL scheme for direct Play Store launch
  String? get androidPlayStoreSchemeUrl {
    if (config.playStorePackage != null) {
      return 'market://details?id=${config.playStorePackage}';
    }
    return null;
  }

  /// Open with native scheme first, fallback to web URL
  Future<bool> openStoreNative() async {
    if (kIsWeb) return openStore();

    String? schemeUrl;
    String? fallbackUrl;

    if (Platform.isIOS || Platform.isMacOS) {
      schemeUrl = iosAppStoreSchemeUrl;
      fallbackUrl = config.effectiveIosUrl;
    } else if (Platform.isAndroid) {
      schemeUrl = androidPlayStoreSchemeUrl;
      fallbackUrl = config.effectiveAndroidUrl;
    }

    // Try native scheme first
    if (schemeUrl != null) {
      try {
        final uri = Uri.parse(schemeUrl);
        if (await canLaunchUrl(uri)) {
          final success = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (success) return true;
        }
      } catch (e) {
        debugPrint('Native scheme failed: $e');
      }
    }

    // Fallback to web URL
    if (fallbackUrl != null) {
      return openUrl(fallbackUrl);
    }

    // Last resort: custom URL
    if (config.customUrl != null) {
      return openUrl(config.customUrl!);
    }

    return false;
  }
}
