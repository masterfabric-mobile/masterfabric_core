/// Push Notification Provider Types
///
/// Defines the available push notification service providers.
/// New providers can be added here when integrating additional services.
enum PushNotificationProviderType {
  /// OneSignal push notification service
  onesignal,

  /// Firebase Cloud Messaging (FCM)
  firebase,

  /// Custom provider for future integrations
  custom,
}

/// Extension to convert string to PushNotificationProviderType
extension PushNotificationProviderTypeExtension on PushNotificationProviderType {
  /// Get the string name of the provider
  String get name {
    switch (this) {
      case PushNotificationProviderType.onesignal:
        return 'onesignal';
      case PushNotificationProviderType.firebase:
        return 'firebase';
      case PushNotificationProviderType.custom:
        return 'custom';
    }
  }

  /// Create provider type from string
  static PushNotificationProviderType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'onesignal':
        return PushNotificationProviderType.onesignal;
      case 'firebase':
        return PushNotificationProviderType.firebase;
      case 'custom':
        return PushNotificationProviderType.custom;
      default:
        return PushNotificationProviderType.onesignal;
    }
  }
}

/// Push Notification Data
///
/// Represents a notification payload received from any provider.
/// Contains common fields that are normalized across all providers.
class PushNotificationData {
  /// Notification title
  final String? title;

  /// Notification body/message
  final String? body;

  /// Additional custom data attached to the notification
  final Map<String, dynamic>? additionalData;

  /// The provider that delivered this notification
  final PushNotificationProviderType source;

  /// Notification ID (if available)
  final String? notificationId;

  /// Image URL for rich notifications
  final String? imageUrl;

  /// Deep link or action URL
  final String? actionUrl;

  /// Whether the notification was received in foreground
  final bool isInForeground;

  /// Raw payload from the provider (for advanced use cases)
  final Map<String, dynamic>? rawPayload;

  /// Timestamp when notification was received
  final DateTime receivedAt;

  /// Creates a PushNotificationData instance
  const PushNotificationData({
    this.title,
    this.body,
    this.additionalData,
    required this.source,
    this.notificationId,
    this.imageUrl,
    this.actionUrl,
    this.isInForeground = false,
    this.rawPayload,
    required this.receivedAt,
  });

  /// Creates a copy with modified fields
  PushNotificationData copyWith({
    String? title,
    String? body,
    Map<String, dynamic>? additionalData,
    PushNotificationProviderType? source,
    String? notificationId,
    String? imageUrl,
    String? actionUrl,
    bool? isInForeground,
    Map<String, dynamic>? rawPayload,
    DateTime? receivedAt,
  }) {
    return PushNotificationData(
      title: title ?? this.title,
      body: body ?? this.body,
      additionalData: additionalData ?? this.additionalData,
      source: source ?? this.source,
      notificationId: notificationId ?? this.notificationId,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      isInForeground: isInForeground ?? this.isInForeground,
      rawPayload: rawPayload ?? this.rawPayload,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  @override
  String toString() {
    return 'PushNotificationData(title: $title, body: $body, source: $source, isInForeground: $isInForeground)';
  }
}

/// Provider Configuration
///
/// Configuration for individual push notification providers.
class ProviderConfig {
  /// Whether this provider is enabled
  final bool enabled;

  /// Provider-specific settings
  final Map<String, dynamic> settings;

  /// Creates a ProviderConfig instance
  const ProviderConfig({
    this.enabled = false,
    this.settings = const {},
  });

  /// Creates from JSON map
  factory ProviderConfig.fromJson(Map<String, dynamic> json) {
    return ProviderConfig(
      enabled: json['enabled'] as bool? ?? false,
      settings: Map<String, dynamic>.from(json)..remove('enabled'),
    );
  }

  /// Converts to JSON map
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      ...settings,
    };
  }
}

/// Push Notification Configuration
///
/// Main configuration class for the push notification system.
/// Loaded from app_config.json and used to initialize providers.
class PushNotificationConfig {
  /// Whether push notifications are enabled globally
  final bool enabled;

  /// Default provider to use when not specified
  final PushNotificationProviderType defaultProvider;

  /// Whether to automatically initialize enabled providers on app start
  final bool autoInitialize;

  /// OneSignal specific configuration
  final ProviderConfig oneSignalConfig;

  /// Firebase specific configuration
  final ProviderConfig firebaseConfig;

  /// Custom provider configuration (for future use)
  final ProviderConfig customConfig;

  /// Creates a PushNotificationConfig instance
  const PushNotificationConfig({
    this.enabled = true,
    this.defaultProvider = PushNotificationProviderType.onesignal,
    this.autoInitialize = true,
    this.oneSignalConfig = const ProviderConfig(),
    this.firebaseConfig = const ProviderConfig(),
    this.customConfig = const ProviderConfig(),
  });

  /// Creates from JSON map (from app_config.json)
  factory PushNotificationConfig.fromJson(Map<String, dynamic> json) {
    final providers = json['providers'] as Map<String, dynamic>? ?? {};

    return PushNotificationConfig(
      enabled: json['enabled'] as bool? ?? true,
      defaultProvider: PushNotificationProviderTypeExtension.fromString(
        json['defaultProvider'] as String? ?? 'onesignal',
      ),
      autoInitialize: json['autoInitialize'] as bool? ?? true,
      oneSignalConfig: providers['onesignal'] != null
          ? ProviderConfig.fromJson(providers['onesignal'] as Map<String, dynamic>)
          : const ProviderConfig(),
      firebaseConfig: providers['firebase'] != null
          ? ProviderConfig.fromJson(providers['firebase'] as Map<String, dynamic>)
          : const ProviderConfig(),
      customConfig: providers['custom'] != null
          ? ProviderConfig.fromJson(providers['custom'] as Map<String, dynamic>)
          : const ProviderConfig(),
    );
  }

  /// Converts to JSON map
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'defaultProvider': defaultProvider.name,
      'autoInitialize': autoInitialize,
      'providers': {
        'onesignal': oneSignalConfig.toJson(),
        'firebase': firebaseConfig.toJson(),
        'custom': customConfig.toJson(),
      },
    };
  }

  /// Default configuration
  static const PushNotificationConfig defaultConfig = PushNotificationConfig();

  /// Get config for a specific provider
  ProviderConfig getProviderConfig(PushNotificationProviderType type) {
    switch (type) {
      case PushNotificationProviderType.onesignal:
        return oneSignalConfig;
      case PushNotificationProviderType.firebase:
        return firebaseConfig;
      case PushNotificationProviderType.custom:
        return customConfig;
    }
  }

  /// Check if a specific provider is enabled
  bool isProviderEnabled(PushNotificationProviderType type) {
    return enabled && getProviderConfig(type).enabled;
  }
}

/// Notification Permission Status
///
/// Represents the current permission status for push notifications.
enum NotificationPermissionStatus {
  /// Permission not yet requested
  notDetermined,

  /// User denied permission
  denied,

  /// User granted permission
  authorized,

  /// User granted provisional permission (iOS only)
  provisional,

  /// Unknown status
  unknown,
}

/// Notification Action Result
///
/// Result of a notification action (e.g., user tapped notification).
class NotificationActionResult {
  /// The notification data
  final PushNotificationData notification;

  /// Action identifier (if using action buttons)
  final String? actionId;

  /// Whether notification was dismissed without action
  final bool isDismissed;

  /// Creates a NotificationActionResult instance
  const NotificationActionResult({
    required this.notification,
    this.actionId,
    this.isDismissed = false,
  });

  @override
  String toString() {
    return 'NotificationActionResult(actionId: $actionId, isDismissed: $isDismissed, notification: $notification)';
  }
}
