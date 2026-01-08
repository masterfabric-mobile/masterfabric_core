import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

/// Push Notification Demo State
class PushNotificationDemoState extends Equatable {
  /// Whether the helper is initialized
  final bool isInitialized;

  /// Whether initialization is in progress
  final bool isLoading;

  /// Current configuration
  final PushNotificationConfig? config;

  /// Permission statuses per provider
  final Map<PushNotificationProviderType, NotificationPermissionStatus> permissionStatuses;

  /// Device tokens per provider
  final Map<PushNotificationProviderType, String?> deviceTokens;

  /// Subscribed topics
  final List<String> subscribedTopics;

  /// Recent notifications received
  final List<PushNotificationData> recentNotifications;

  /// Error message if any
  final String? errorMessage;

  /// Status message for user feedback
  final String? statusMessage;

  /// Active providers
  final List<PushNotificationProviderType> activeProviders;

  const PushNotificationDemoState({
    this.isInitialized = false,
    this.isLoading = false,
    this.config,
    this.permissionStatuses = const {},
    this.deviceTokens = const {},
    this.subscribedTopics = const [],
    this.recentNotifications = const [],
    this.errorMessage,
    this.statusMessage,
    this.activeProviders = const [],
  });

  const PushNotificationDemoState.initial()
      : isInitialized = false,
        isLoading = false,
        config = null,
        permissionStatuses = const {},
        deviceTokens = const {},
        subscribedTopics = const [],
        recentNotifications = const [],
        errorMessage = null,
        statusMessage = null,
        activeProviders = const [];

  PushNotificationDemoState copyWith({
    bool? isInitialized,
    bool? isLoading,
    PushNotificationConfig? config,
    Map<PushNotificationProviderType, NotificationPermissionStatus>? permissionStatuses,
    Map<PushNotificationProviderType, String?>? deviceTokens,
    List<String>? subscribedTopics,
    List<PushNotificationData>? recentNotifications,
    String? errorMessage,
    String? statusMessage,
    List<PushNotificationProviderType>? activeProviders,
    bool clearError = false,
    bool clearStatus = false,
  }) {
    return PushNotificationDemoState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      config: config ?? this.config,
      permissionStatuses: permissionStatuses ?? this.permissionStatuses,
      deviceTokens: deviceTokens ?? this.deviceTokens,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      recentNotifications: recentNotifications ?? this.recentNotifications,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      activeProviders: activeProviders ?? this.activeProviders,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        isLoading,
        config,
        permissionStatuses,
        deviceTokens,
        subscribedTopics,
        recentNotifications,
        errorMessage,
        statusMessage,
        activeProviders,
      ];
}
