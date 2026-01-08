import '../models/force_update_models.dart';

/// Abstract interface for version providers
abstract class VersionProvider {
  /// Fetch the latest version information from the provider
  Future<VersionData> fetchVersionInfo();

  /// Check if the provider is available
  Future<bool> isAvailable();

  /// Dispose of any resources
  void dispose() {}
}

/// Raw version data from a provider
class VersionData {
  /// Latest available version
  final String latestVersion;

  /// Minimum required version (triggers force update)
  final String? minimumVersion;

  /// Release notes or changelog
  final String? releaseNotes;

  /// Store URLs
  final StoreConfig? storeConfig;

  /// Custom message
  final String? customMessage;

  /// Features list
  final List<String>? features;

  /// Raw response data (for debugging)
  final Map<String, dynamic>? rawData;

  const VersionData({
    required this.latestVersion,
    this.minimumVersion,
    this.releaseNotes,
    this.storeConfig,
    this.customMessage,
    this.features,
    this.rawData,
  });

  /// Create from JSON
  factory VersionData.fromJson(Map<String, dynamic> json) {
    return VersionData(
      latestVersion: json['latestVersion'] as String? ?? '0.0.0',
      minimumVersion: json['minimumVersion'] as String?,
      releaseNotes: json['releaseNotes'] as String?,
      storeConfig: json['storeConfig'] != null ||
              json['storeUrl'] != null ||
              json['iosStoreUrl'] != null ||
              json['androidStoreUrl'] != null
          ? _parseStoreConfig(json)
          : null,
      customMessage: json['customMessage'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rawData: json,
    );
  }

  static StoreConfig _parseStoreConfig(Map<String, dynamic> json) {
    // Handle nested storeConfig object
    if (json['storeConfig'] != null) {
      return StoreConfig.fromJson(json['storeConfig'] as Map<String, dynamic>);
    }

    // Handle flat storeUrl object
    if (json['storeUrl'] != null && json['storeUrl'] is Map) {
      final storeUrl = json['storeUrl'] as Map<String, dynamic>;
      return StoreConfig(
        iosStoreUrl: storeUrl['ios'] as String?,
        androidStoreUrl: storeUrl['android'] as String?,
        customUrl: storeUrl['custom'] as String?,
      );
    }

    // Handle direct URLs
    return StoreConfig(
      iosStoreUrl: json['iosStoreUrl'] as String?,
      androidStoreUrl: json['androidStoreUrl'] as String?,
      customUrl: json['customUrl'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      if (minimumVersion != null) 'minimumVersion': minimumVersion,
      if (releaseNotes != null) 'releaseNotes': releaseNotes,
      if (storeConfig != null) 'storeConfig': storeConfig!.toJson(),
      if (customMessage != null) 'customMessage': customMessage,
      if (features != null) 'features': features,
    };
  }
}
