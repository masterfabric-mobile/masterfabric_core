import 'store_config.dart';
import 'update_ui_type.dart';

/// Provider type for version checking
enum VersionProviderType {
  /// Config file provider (app_config.json)
  configFile,

  /// API endpoint provider
  api,

  /// Firebase Remote Config provider
  remoteConfig,

  /// Custom provider
  custom,
}

/// Configuration for ForceUpdateHelper
class ForceUpdateConfig {
  /// Version provider type to use
  final VersionProviderType providerType;

  /// Default UI type for update prompts
  final UpdateUIType defaultUIType;

  /// Whether to automatically check for updates on init
  final bool autoCheck;

  /// Interval between automatic checks
  final Duration checkInterval;

  /// Store configuration
  final StoreConfig storeConfig;

  /// API endpoint URL (for API provider)
  final String? apiEndpoint;

  /// Config file path (for config file provider)
  final String? configFilePath;

  /// Custom strings for localization
  final ForceUpdateStrings strings;

  const ForceUpdateConfig({
    this.providerType = VersionProviderType.configFile,
    this.defaultUIType = UpdateUIType.dialog,
    this.autoCheck = false,
    this.checkInterval = const Duration(hours: 24),
    this.storeConfig = StoreConfig.empty,
    this.apiEndpoint,
    this.configFilePath,
    this.strings = const ForceUpdateStrings(),
  });

  /// Create from JSON
  factory ForceUpdateConfig.fromJson(Map<String, dynamic> json) {
    return ForceUpdateConfig(
      providerType: _providerTypeFromJson(json['providerType'] as String?),
      defaultUIType:
          UpdateUITypeExtension.fromJson(json['defaultUIType'] as String?),
      autoCheck: json['autoCheck'] as bool? ?? false,
      checkInterval: json['checkIntervalHours'] != null
          ? Duration(hours: json['checkIntervalHours'] as int)
          : const Duration(hours: 24),
      storeConfig: json['storeConfig'] != null
          ? StoreConfig.fromJson(json['storeConfig'] as Map<String, dynamic>)
          : StoreConfig.empty,
      apiEndpoint: json['apiEndpoint'] as String?,
      configFilePath: json['configFilePath'] as String?,
      strings: json['strings'] != null
          ? ForceUpdateStrings.fromJson(json['strings'] as Map<String, dynamic>)
          : const ForceUpdateStrings(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'providerType': providerType.name,
      'defaultUIType': defaultUIType.toJson(),
      'autoCheck': autoCheck,
      'checkIntervalHours': checkInterval.inHours,
      'storeConfig': storeConfig.toJson(),
      if (apiEndpoint != null) 'apiEndpoint': apiEndpoint,
      if (configFilePath != null) 'configFilePath': configFilePath,
      'strings': strings.toJson(),
    };
  }

  static VersionProviderType _providerTypeFromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'api':
        return VersionProviderType.api;
      case 'remoteconfig':
        return VersionProviderType.remoteConfig;
      case 'custom':
        return VersionProviderType.custom;
      default:
        return VersionProviderType.configFile;
    }
  }

  /// Copy with modifications
  ForceUpdateConfig copyWith({
    VersionProviderType? providerType,
    UpdateUIType? defaultUIType,
    bool? autoCheck,
    Duration? checkInterval,
    StoreConfig? storeConfig,
    String? apiEndpoint,
    String? configFilePath,
    ForceUpdateStrings? strings,
  }) {
    return ForceUpdateConfig(
      providerType: providerType ?? this.providerType,
      defaultUIType: defaultUIType ?? this.defaultUIType,
      autoCheck: autoCheck ?? this.autoCheck,
      checkInterval: checkInterval ?? this.checkInterval,
      storeConfig: storeConfig ?? this.storeConfig,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      configFilePath: configFilePath ?? this.configFilePath,
      strings: strings ?? this.strings,
    );
  }
}

/// Customizable strings for the update UI
class ForceUpdateStrings {
  final String updateAvailableTitle;
  final String forceUpdateTitle;
  final String updateNowButton;
  final String laterButton;
  final String skipButton;
  final String whatsNewTitle;
  final String versionLabel;

  const ForceUpdateStrings({
    this.updateAvailableTitle = 'Update Available',
    this.forceUpdateTitle = 'Update Required',
    this.updateNowButton = 'Update Now',
    this.laterButton = 'Later',
    this.skipButton = 'Skip This Version',
    this.whatsNewTitle = "What's New",
    this.versionLabel = 'Version',
  });

  /// Create from JSON
  factory ForceUpdateStrings.fromJson(Map<String, dynamic> json) {
    return ForceUpdateStrings(
      updateAvailableTitle:
          json['updateAvailableTitle'] as String? ?? 'Update Available',
      forceUpdateTitle:
          json['forceUpdateTitle'] as String? ?? 'Update Required',
      updateNowButton: json['updateNowButton'] as String? ?? 'Update Now',
      laterButton: json['laterButton'] as String? ?? 'Later',
      skipButton: json['skipButton'] as String? ?? 'Skip This Version',
      whatsNewTitle: json['whatsNewTitle'] as String? ?? "What's New",
      versionLabel: json['versionLabel'] as String? ?? 'Version',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'updateAvailableTitle': updateAvailableTitle,
      'forceUpdateTitle': forceUpdateTitle,
      'updateNowButton': updateNowButton,
      'laterButton': laterButton,
      'skipButton': skipButton,
      'whatsNewTitle': whatsNewTitle,
      'versionLabel': versionLabel,
    };
  }
}
