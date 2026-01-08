import 'update_type.dart';
import 'store_config.dart';

/// Contains information about an available update
class UpdateInfo {
  /// Current app version
  final String currentVersion;

  /// Latest available version
  final String latestVersion;

  /// Minimum required version (for force update)
  final String? minimumVersion;

  /// Type of update required
  final UpdateType updateType;

  /// Release notes or changelog
  final String? releaseNotes;

  /// Store configuration for redirects
  final StoreConfig storeConfig;

  /// Custom message to display
  final String? customMessage;

  /// Features in the new version
  final List<String>? features;

  /// Whether to show the "Later" button
  final bool showLaterButton;

  /// Whether to show the "Skip" button
  final bool showSkipButton;

  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    this.minimumVersion,
    required this.updateType,
    this.releaseNotes,
    this.storeConfig = StoreConfig.empty,
    this.customMessage,
    this.features,
    this.showLaterButton = true,
    this.showSkipButton = false,
  });

  /// Create from JSON
  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      currentVersion: json['currentVersion'] as String? ?? '0.0.0',
      latestVersion: json['latestVersion'] as String? ?? '0.0.0',
      minimumVersion: json['minimumVersion'] as String?,
      updateType: UpdateTypeExtension.fromJson(json['updateType'] as String?),
      releaseNotes: json['releaseNotes'] as String?,
      storeConfig: json['storeConfig'] != null
          ? StoreConfig.fromJson(json['storeConfig'] as Map<String, dynamic>)
          : StoreConfig.empty,
      customMessage: json['customMessage'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      showLaterButton: json['showLaterButton'] as bool? ?? true,
      showSkipButton: json['showSkipButton'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'currentVersion': currentVersion,
      'latestVersion': latestVersion,
      if (minimumVersion != null) 'minimumVersion': minimumVersion,
      'updateType': updateType.toJson(),
      if (releaseNotes != null) 'releaseNotes': releaseNotes,
      'storeConfig': storeConfig.toJson(),
      if (customMessage != null) 'customMessage': customMessage,
      if (features != null) 'features': features,
      'showLaterButton': showLaterButton,
      'showSkipButton': showSkipButton,
    };
  }

  /// Check if an update is available
  bool get hasUpdate => updateType != UpdateType.none;

  /// Check if the update is blocking (force update)
  bool get isBlocking => updateType.isBlocking;

  /// Check if the user can dismiss the update prompt
  bool get isDismissible => updateType.isDismissible;

  /// No update available
  static UpdateInfo noUpdate({required String currentVersion}) {
    return UpdateInfo(
      currentVersion: currentVersion,
      latestVersion: currentVersion,
      updateType: UpdateType.none,
    );
  }

  /// Copy with modifications
  UpdateInfo copyWith({
    String? currentVersion,
    String? latestVersion,
    String? minimumVersion,
    UpdateType? updateType,
    String? releaseNotes,
    StoreConfig? storeConfig,
    String? customMessage,
    List<String>? features,
    bool? showLaterButton,
    bool? showSkipButton,
  }) {
    return UpdateInfo(
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion ?? this.latestVersion,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      updateType: updateType ?? this.updateType,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      storeConfig: storeConfig ?? this.storeConfig,
      customMessage: customMessage ?? this.customMessage,
      features: features ?? this.features,
      showLaterButton: showLaterButton ?? this.showLaterButton,
      showSkipButton: showSkipButton ?? this.showSkipButton,
    );
  }
}
