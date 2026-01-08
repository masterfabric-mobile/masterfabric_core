import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'version_provider.dart';

/// Configuration for Firebase Remote Config provider
class RemoteConfigSettings {
  /// Key for latest version
  final String latestVersionKey;

  /// Key for minimum version
  final String minimumVersionKey;

  /// Key for release notes
  final String releaseNotesKey;

  /// Key for store config JSON
  final String storeConfigKey;

  /// Key for features JSON array
  final String featuresKey;

  const RemoteConfigSettings({
    this.latestVersionKey = 'force_update_latest_version',
    this.minimumVersionKey = 'force_update_minimum_version',
    this.releaseNotesKey = 'force_update_release_notes',
    this.storeConfigKey = 'force_update_store_config',
    this.featuresKey = 'force_update_features',
  });
}

/// Abstract interface for Firebase Remote Config
/// This allows the helper to work without a hard dependency on Firebase
abstract class RemoteConfigAdapter {
  /// Fetch and activate remote config
  Future<bool> fetchAndActivate();

  /// Get a string value
  String getString(String key);

  /// Get all values as a map
  Map<String, dynamic> getAll();
}

/// Version provider that uses Firebase Remote Config
/// 
/// Usage:
/// ```dart
/// // Implement RemoteConfigAdapter with your Firebase instance
/// class MyRemoteConfigAdapter implements RemoteConfigAdapter {
///   final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;
///   
///   @override
///   Future<bool> fetchAndActivate() => _config.fetchAndActivate();
///   
///   @override
///   String getString(String key) => _config.getString(key);
///   
///   @override
///   Map<String, dynamic> getAll() => _config.getAll().map(
///     (key, value) => MapEntry(key, value.asString()),
///   );
/// }
/// 
/// // Use in provider
/// final provider = RemoteConfigProvider(
///   adapter: MyRemoteConfigAdapter(),
/// );
/// ```
class RemoteConfigProvider implements VersionProvider {
  /// Remote config adapter
  final RemoteConfigAdapter adapter;

  /// Remote config key settings
  final RemoteConfigSettings settings;

  RemoteConfigProvider({
    required this.adapter,
    this.settings = const RemoteConfigSettings(),
  });

  @override
  Future<VersionData> fetchVersionInfo() async {
    try {
      await adapter.fetchAndActivate();

      final latestVersion = adapter.getString(settings.latestVersionKey);

      if (latestVersion.isEmpty) {
        throw Exception('Latest version not found in Remote Config');
      }

      final minimumVersion = adapter.getString(settings.minimumVersionKey);
      final releaseNotes = adapter.getString(settings.releaseNotesKey);
      final storeConfigJson = adapter.getString(settings.storeConfigKey);
      final featuresJson = adapter.getString(settings.featuresKey);

      return VersionData(
        latestVersion: latestVersion,
        minimumVersion: minimumVersion.isNotEmpty ? minimumVersion : null,
        releaseNotes: releaseNotes.isNotEmpty ? releaseNotes : null,
        storeConfig: storeConfigJson.isNotEmpty
            ? _parseStoreConfig(storeConfigJson)
            : null,
        features: featuresJson.isNotEmpty ? _parseFeatures(featuresJson) : null,
      );
    } catch (e) {
      debugPrint('RemoteConfigProvider error: $e');
      rethrow;
    }
  }

  dynamic _parseStoreConfig(String jsonString) {
    try {
      final data = json.decode(jsonString);
      if (data is Map<String, dynamic>) {
        return data;
      }
    } catch (e) {
      debugPrint('Failed to parse store config: $e');
    }
    return null;
  }

  List<String>? _parseFeatures(String jsonString) {
    try {
      final data = json.decode(jsonString);
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
    } catch (e) {
      debugPrint('Failed to parse features: $e');
    }
    return null;
  }

  @override
  Future<bool> isAvailable() async {
    try {
      await adapter.fetchAndActivate();
      final version = adapter.getString(settings.latestVersionKey);
      return version.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    // No resources to dispose
  }
}
