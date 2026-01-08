import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'models/force_update_models.dart';
import 'providers/force_update_providers.dart';
import 'version_comparator.dart';
import 'store_redirector.dart';
import 'widgets/update_alert_dialog.dart';
import 'widgets/update_bottom_sheet.dart';
import 'widgets/force_update_screen.dart';

/// Callback when user taps update
typedef OnUpdateCallback = void Function(UpdateInfo info);

/// Callback when user taps later
typedef OnLaterCallback = void Function(UpdateInfo info);

/// Callback when user taps skip
typedef OnSkipCallback = void Function(UpdateInfo info);

/// Force Update Helper
/// 
/// A flexible helper for managing app version checks and update prompts.
/// 
/// Usage:
/// ```dart
/// // Initialize with config file provider
/// await ForceUpdateHelper.instance.initialize(
///   ForceUpdateConfig(providerType: VersionProviderType.configFile),
/// );
/// 
/// // Check for updates
/// final updateInfo = await ForceUpdateHelper.instance.checkForUpdate();
/// 
/// // Show update UI if needed
/// if (updateInfo.hasUpdate) {
///   await ForceUpdateHelper.instance.showUpdateUI(context, updateInfo);
/// }
/// ```
class ForceUpdateHelper {
  /// Singleton instance
  static final ForceUpdateHelper instance = ForceUpdateHelper._();

  ForceUpdateHelper._();

  /// Configuration
  ForceUpdateConfig? _config;

  /// Version provider
  VersionProvider? _provider;

  /// Store redirector
  StoreRedirector? _storeRedirector;

  /// Current app version
  String? _currentVersion;

  /// Last check time
  DateTime? _lastCheckTime;

  /// Cached update info
  UpdateInfo? _cachedUpdateInfo;

  /// Whether the helper is initialized
  bool get isInitialized => _config != null && _provider != null;

  /// Current configuration
  ForceUpdateConfig? get config => _config;

  /// Initialize the helper
  Future<bool> initialize(ForceUpdateConfig config) async {
    try {
      _config = config;

      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;

      // Setup provider
      _provider = _createProvider(config);

      // Setup store redirector
      _storeRedirector = StoreRedirector(config: config.storeConfig);

      debugPrint('ForceUpdateHelper initialized');
      debugPrint('  Current version: $_currentVersion');
      debugPrint('  Provider: ${config.providerType.name}');

      // Auto check if enabled
      if (config.autoCheck) {
        await checkForUpdate();
      }

      return true;
    } catch (e) {
      debugPrint('ForceUpdateHelper initialization error: $e');
      return false;
    }
  }

  /// Initialize with a custom provider
  Future<bool> initializeWithProvider(
    VersionProvider provider, {
    ForceUpdateConfig? config,
  }) async {
    try {
      _config = config ?? const ForceUpdateConfig();
      _provider = provider;

      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;

      _storeRedirector = StoreRedirector(config: _config!.storeConfig);

      debugPrint('ForceUpdateHelper initialized with custom provider');
      debugPrint('  Current version: $_currentVersion');

      return true;
    } catch (e) {
      debugPrint('ForceUpdateHelper initialization error: $e');
      return false;
    }
  }

  /// Create provider based on config
  VersionProvider _createProvider(ForceUpdateConfig config) {
    switch (config.providerType) {
      case VersionProviderType.configFile:
        return ConfigFileProvider(
          configPath: config.configFilePath ?? 'assets/app_config.json',
        );
      case VersionProviderType.api:
        if (config.apiEndpoint == null) {
          throw ArgumentError('API endpoint is required for API provider');
        }
        return ApiVersionProvider(endpoint: config.apiEndpoint!);
      case VersionProviderType.remoteConfig:
        throw ArgumentError(
          'Remote Config provider requires a RemoteConfigAdapter. '
          'Use initializeWithProvider() instead.',
        );
      case VersionProviderType.custom:
        throw ArgumentError(
          'Custom provider requires using initializeWithProvider()',
        );
    }
  }

  /// Check for updates
  Future<UpdateInfo> checkForUpdate() async {
    if (!isInitialized) {
      throw StateError('ForceUpdateHelper is not initialized');
    }

    try {
      // Check if we need to refresh (respect check interval)
      if (_cachedUpdateInfo != null && _lastCheckTime != null) {
        final timeSinceLastCheck = DateTime.now().difference(_lastCheckTime!);
        if (timeSinceLastCheck < _config!.checkInterval) {
          return _cachedUpdateInfo!;
        }
      }

      // Fetch version info from provider
      final versionData = await _provider!.fetchVersionInfo();

      // Determine update type
      final updateType = _determineUpdateType(
        currentVersion: _currentVersion!,
        latestVersion: versionData.latestVersion,
        minimumVersion: versionData.minimumVersion,
      );

      // Merge store configs (provider config takes precedence)
      final storeConfig = versionData.storeConfig ?? _config!.storeConfig;

      // Update store redirector with new config
      _storeRedirector = StoreRedirector(config: storeConfig);

      // Create update info
      _cachedUpdateInfo = UpdateInfo(
        currentVersion: _currentVersion!,
        latestVersion: versionData.latestVersion,
        minimumVersion: versionData.minimumVersion,
        updateType: updateType,
        releaseNotes: versionData.releaseNotes,
        storeConfig: storeConfig,
        customMessage: versionData.customMessage,
        features: versionData.features,
        showLaterButton: updateType != UpdateType.force,
        showSkipButton: updateType == UpdateType.optional,
      );

      _lastCheckTime = DateTime.now();

      debugPrint('Update check result: ${updateType.name}');
      debugPrint('  Current: $_currentVersion');
      debugPrint('  Latest: ${versionData.latestVersion}');
      debugPrint('  Minimum: ${versionData.minimumVersion ?? 'none'}');

      return _cachedUpdateInfo!;
    } catch (e) {
      debugPrint('Error checking for update: $e');
      rethrow;
    }
  }

  /// Determine the type of update required
  UpdateType _determineUpdateType({
    required String currentVersion,
    required String latestVersion,
    String? minimumVersion,
  }) {
    // Check if force update is required
    if (minimumVersion != null &&
        VersionComparator.isOlderThan(currentVersion, minimumVersion)) {
      return UpdateType.force;
    }

    // Check if any update is available
    if (VersionComparator.isOlderThan(currentVersion, latestVersion)) {
      // If minimum version is set but current is above it, it's recommended
      if (minimumVersion != null) {
        return UpdateType.recommended;
      }
      return UpdateType.optional;
    }

    return UpdateType.none;
  }

  /// Show update UI based on config and update type
  Future<void> showUpdateUI(
    BuildContext context,
    UpdateInfo info, {
    UpdateUIType? uiType,
    OnUpdateCallback? onUpdate,
    OnLaterCallback? onLater,
    OnSkipCallback? onSkip,
  }) async {
    if (!isInitialized) {
      throw StateError('ForceUpdateHelper is not initialized');
    }

    // Determine UI type
    final effectiveUIType = uiType ?? _getDefaultUIType(info);

    switch (effectiveUIType) {
      case UpdateUIType.dialog:
        await showUpdateDialog(
          context,
          info,
          onUpdate: onUpdate,
          onLater: onLater,
          onSkip: onSkip,
        );
        break;
      case UpdateUIType.bottomSheet:
        await showUpdateBottomSheet(
          context,
          info,
          onUpdate: onUpdate,
          onLater: onLater,
          onSkip: onSkip,
        );
        break;
      case UpdateUIType.fullScreen:
        await showForceUpdateScreen(
          context,
          info,
          onUpdate: onUpdate,
        );
        break;
    }
  }

  /// Get default UI type based on update type
  UpdateUIType _getDefaultUIType(UpdateInfo info) {
    if (info.updateType == UpdateType.force) {
      return UpdateUIType.fullScreen;
    }
    return _config?.defaultUIType ?? UpdateUIType.dialog;
  }

  /// Show update dialog
  Future<void> showUpdateDialog(
    BuildContext context,
    UpdateInfo info, {
    OnUpdateCallback? onUpdate,
    OnLaterCallback? onLater,
    OnSkipCallback? onSkip,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: info.isDismissible,
      builder: (context) => UpdateAlertDialog(
        info: info,
        strings: _config?.strings ?? const ForceUpdateStrings(),
        onUpdate: () {
          onUpdate?.call(info);
          openStore();
        },
        onLater: info.showLaterButton
            ? () {
                onLater?.call(info);
                Navigator.of(context).pop();
              }
            : null,
        onSkip: info.showSkipButton
            ? () {
                onSkip?.call(info);
                Navigator.of(context).pop();
              }
            : null,
      ),
    );
  }

  /// Show update bottom sheet
  Future<void> showUpdateBottomSheet(
    BuildContext context,
    UpdateInfo info, {
    OnUpdateCallback? onUpdate,
    OnLaterCallback? onLater,
    OnSkipCallback? onSkip,
  }) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: info.isDismissible,
      enableDrag: info.isDismissible,
      isScrollControlled: true,
      builder: (context) => UpdateBottomSheet(
        info: info,
        strings: _config?.strings ?? const ForceUpdateStrings(),
        onUpdate: () {
          onUpdate?.call(info);
          openStore();
        },
        onLater: info.showLaterButton
            ? () {
                onLater?.call(info);
                Navigator.of(context).pop();
              }
            : null,
        onSkip: info.showSkipButton
            ? () {
                onSkip?.call(info);
                Navigator.of(context).pop();
              }
            : null,
      ),
    );
  }

  /// Show force update full screen
  Future<void> showForceUpdateScreen(
    BuildContext context,
    UpdateInfo info, {
    OnUpdateCallback? onUpdate,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForceUpdateScreen(
          info: info,
          strings: _config?.strings ?? const ForceUpdateStrings(),
          onUpdate: () {
            onUpdate?.call(info);
            openStore();
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  /// Open the app store
  Future<bool> openStore() async {
    if (_storeRedirector == null) {
      debugPrint('Store redirector not initialized');
      return false;
    }
    return _storeRedirector!.openStoreNative();
  }

  /// Open a custom URL
  Future<bool> openUrl(String url) async {
    if (_storeRedirector == null) {
      debugPrint('Store redirector not initialized');
      return false;
    }
    return _storeRedirector!.openUrl(url);
  }

  /// Clear cached update info
  void clearCache() {
    _cachedUpdateInfo = null;
    _lastCheckTime = null;
  }

  /// Dispose of resources
  void dispose() {
    _provider?.dispose();
    _provider = null;
    _config = null;
    _storeRedirector = null;
    _cachedUpdateInfo = null;
    _lastCheckTime = null;
    _currentVersion = null;
  }
}
