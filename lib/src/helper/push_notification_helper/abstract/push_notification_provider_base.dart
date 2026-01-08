import 'dart:async';

import 'package:masterfabric_core/src/helper/push_notification_helper/models/push_notification_models.dart';

/// Push Notification Provider Base
///
/// Abstract base class that defines the contract for all push notification providers.
/// Implement this class to add support for new notification services.
///
/// **Usage Example:**
/// ```dart
/// class MyCustomProvider extends PushNotificationProviderBase {
///   @override
///   PushNotificationProviderType get providerType => PushNotificationProviderType.custom;
///
///   @override
///   Future<bool> initialize(ProviderConfig config) async {
///     // Initialize your provider
///     return true;
///   }
///   // ... implement other methods
/// }
/// ```
abstract class PushNotificationProviderBase {
  /// The type of this provider
  PushNotificationProviderType get providerType;

  /// Whether this provider has been initialized
  bool get isInitialized;

  /// Stream of received notifications
  ///
  /// Emits [PushNotificationData] when a notification is received.
  /// This includes both foreground and background notifications.
  Stream<PushNotificationData> get onNotificationReceived;

  /// Stream of notification actions (when user taps notification)
  ///
  /// Emits [NotificationActionResult] when user interacts with a notification.
  Stream<NotificationActionResult> get onNotificationOpened;

  /// Initialize the provider with configuration
  ///
  /// [config] - Provider-specific configuration from app_config.json
  ///
  /// Returns `true` if initialization was successful, `false` otherwise.
  Future<bool> initialize(ProviderConfig config);

  /// Request notification permissions from the user
  ///
  /// Returns the resulting [NotificationPermissionStatus].
  Future<NotificationPermissionStatus> requestPermission();

  /// Get current permission status
  ///
  /// Returns the current [NotificationPermissionStatus] without prompting.
  Future<NotificationPermissionStatus> getPermissionStatus();

  /// Subscribe to a topic for receiving topic-based notifications
  ///
  /// [topic] - The topic name to subscribe to.
  ///
  /// Returns `true` if subscription was successful.
  Future<bool> subscribeToTopic(String topic);

  /// Unsubscribe from a topic
  ///
  /// [topic] - The topic name to unsubscribe from.
  ///
  /// Returns `true` if unsubscription was successful.
  Future<bool> unsubscribeFromTopic(String topic);

  /// Set the external user ID for targeting specific users
  ///
  /// [userId] - The user ID from your system.
  ///
  /// Returns `true` if the user ID was set successfully.
  Future<bool> setExternalUserId(String userId);

  /// Remove the external user ID
  ///
  /// Call this when user logs out.
  ///
  /// Returns `true` if removal was successful.
  Future<bool> removeExternalUserId();

  /// Get the device push token
  ///
  /// Returns the device token/registration ID, or `null` if not available.
  Future<String?> getDeviceToken();

  /// Set tags/attributes for the user
  ///
  /// [tags] - Key-value pairs of user attributes.
  ///
  /// Returns `true` if tags were set successfully.
  Future<bool> setTags(Map<String, dynamic> tags);

  /// Remove specific tags
  ///
  /// [keys] - List of tag keys to remove.
  ///
  /// Returns `true` if tags were removed successfully.
  Future<bool> removeTags(List<String> keys);

  /// Get all tags for the current user
  ///
  /// Returns a map of all tags, or empty map if none.
  Future<Map<String, dynamic>> getTags();

  /// Opt user in to push notifications
  ///
  /// Enables push notifications for the user.
  Future<void> optIn();

  /// Opt user out of push notifications
  ///
  /// Disables push notifications for the user without removing their data.
  Future<void> optOut();

  /// Check if user is opted in
  ///
  /// Returns `true` if the user has opted in to notifications.
  Future<bool> isOptedIn();

  /// Clear all notification data (for privacy/logout)
  ///
  /// Removes all user data from the notification provider.
  Future<void> clearAllData();

  /// Dispose of provider resources
  ///
  /// Call this when the provider is no longer needed.
  Future<void> dispose();
}
