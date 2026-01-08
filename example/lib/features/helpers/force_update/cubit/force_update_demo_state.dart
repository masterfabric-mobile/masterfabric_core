import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

/// Force Update Demo State
class ForceUpdateDemoState extends Equatable {
  /// Whether the helper is initialized
  final bool isInitialized;

  /// Whether a check is in progress
  final bool isLoading;

  /// Current app version
  final String? currentVersion;

  /// Update info from last check
  final UpdateInfo? updateInfo;

  /// Error message
  final String? errorMessage;

  /// Status message
  final String? statusMessage;

  /// Selected UI type for preview
  final UpdateUIType selectedUIType;

  /// Demo mode configuration
  final DemoConfig demoConfig;

  const ForceUpdateDemoState({
    this.isInitialized = false,
    this.isLoading = false,
    this.currentVersion,
    this.updateInfo,
    this.errorMessage,
    this.statusMessage,
    this.selectedUIType = UpdateUIType.dialog,
    this.demoConfig = const DemoConfig(),
  });

  /// Initial state
  const ForceUpdateDemoState.initial() : this();

  @override
  List<Object?> get props => [
        isInitialized,
        isLoading,
        currentVersion,
        updateInfo,
        errorMessage,
        statusMessage,
        selectedUIType,
        demoConfig,
      ];

  ForceUpdateDemoState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? currentVersion,
    UpdateInfo? updateInfo,
    String? errorMessage,
    String? statusMessage,
    UpdateUIType? selectedUIType,
    DemoConfig? demoConfig,
    bool clearError = false,
    bool clearStatus = false,
    bool clearUpdateInfo = false,
  }) {
    return ForceUpdateDemoState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      currentVersion: currentVersion ?? this.currentVersion,
      updateInfo: clearUpdateInfo ? null : (updateInfo ?? this.updateInfo),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      selectedUIType: selectedUIType ?? this.selectedUIType,
      demoConfig: demoConfig ?? this.demoConfig,
    );
  }
}

/// Demo configuration for testing different scenarios
class DemoConfig extends Equatable {
  /// Simulated current version
  final String simulatedCurrentVersion;

  /// Simulated latest version
  final String simulatedLatestVersion;

  /// Simulated minimum version
  final String? simulatedMinimumVersion;

  /// Whether to use simulated versions instead of real check
  final bool useSimulation;

  const DemoConfig({
    this.simulatedCurrentVersion = '1.0.0',
    this.simulatedLatestVersion = '2.0.0',
    this.simulatedMinimumVersion,
    this.useSimulation = false,
  });

  @override
  List<Object?> get props => [
        simulatedCurrentVersion,
        simulatedLatestVersion,
        simulatedMinimumVersion,
        useSimulation,
      ];

  DemoConfig copyWith({
    String? simulatedCurrentVersion,
    String? simulatedLatestVersion,
    String? simulatedMinimumVersion,
    bool? useSimulation,
    bool clearMinimumVersion = false,
  }) {
    return DemoConfig(
      simulatedCurrentVersion:
          simulatedCurrentVersion ?? this.simulatedCurrentVersion,
      simulatedLatestVersion:
          simulatedLatestVersion ?? this.simulatedLatestVersion,
      simulatedMinimumVersion: clearMinimumVersion
          ? null
          : (simulatedMinimumVersion ?? this.simulatedMinimumVersion),
      useSimulation: useSimulation ?? this.useSimulation,
    );
  }
}
