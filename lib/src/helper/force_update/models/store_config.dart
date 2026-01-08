/// Configuration for app store URLs
class StoreConfig {
  /// iOS App Store URL
  final String? iosStoreUrl;

  /// Android Play Store URL
  final String? androidStoreUrl;

  /// Custom URL (for enterprise apps or alternative stores)
  final String? customUrl;

  /// App Store app ID (for generating default iOS URL)
  final String? appStoreId;

  /// Play Store package name (for generating default Android URL)
  final String? playStorePackage;

  const StoreConfig({
    this.iosStoreUrl,
    this.androidStoreUrl,
    this.customUrl,
    this.appStoreId,
    this.playStorePackage,
  });

  /// Create from JSON
  factory StoreConfig.fromJson(Map<String, dynamic> json) {
    return StoreConfig(
      iosStoreUrl: json['iosStoreUrl'] as String?,
      androidStoreUrl: json['androidStoreUrl'] as String?,
      customUrl: json['customUrl'] as String?,
      appStoreId: json['appStoreId'] as String?,
      playStorePackage: json['playStorePackage'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (iosStoreUrl != null) 'iosStoreUrl': iosStoreUrl,
      if (androidStoreUrl != null) 'androidStoreUrl': androidStoreUrl,
      if (customUrl != null) 'customUrl': customUrl,
      if (appStoreId != null) 'appStoreId': appStoreId,
      if (playStorePackage != null) 'playStorePackage': playStorePackage,
    };
  }

  /// Get the iOS store URL (generated or custom)
  String? get effectiveIosUrl {
    if (iosStoreUrl != null) return iosStoreUrl;
    if (appStoreId != null) {
      return 'https://apps.apple.com/app/id$appStoreId';
    }
    return customUrl;
  }

  /// Get the Android store URL (generated or custom)
  String? get effectiveAndroidUrl {
    if (androidStoreUrl != null) return androidStoreUrl;
    if (playStorePackage != null) {
      return 'https://play.google.com/store/apps/details?id=$playStorePackage';
    }
    return customUrl;
  }

  /// Empty config
  static const StoreConfig empty = StoreConfig();

  /// Copy with modifications
  StoreConfig copyWith({
    String? iosStoreUrl,
    String? androidStoreUrl,
    String? customUrl,
    String? appStoreId,
    String? playStorePackage,
  }) {
    return StoreConfig(
      iosStoreUrl: iosStoreUrl ?? this.iosStoreUrl,
      androidStoreUrl: androidStoreUrl ?? this.androidStoreUrl,
      customUrl: customUrl ?? this.customUrl,
      appStoreId: appStoreId ?? this.appStoreId,
      playStorePackage: playStorePackage ?? this.playStorePackage,
    );
  }
}
