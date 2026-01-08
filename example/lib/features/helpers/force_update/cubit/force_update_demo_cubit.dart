import 'package:flutter/foundation.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'force_update_demo_state.dart';

/// Force Update Demo Cubit
class ForceUpdateDemoCubit extends BaseViewModelCubit<ForceUpdateDemoState> {
  final ForceUpdateHelper _helper = ForceUpdateHelper.instance;

  ForceUpdateDemoCubit() : super(const ForceUpdateDemoState.initial());

  /// Initialize the helper
  Future<void> initialize() async {
    stateChanger(state.copyWith(isLoading: true, clearError: true));

    try {
      // Get current version
      final packageInfo = await PackageInfo.fromPlatform();

      // Initialize with config file provider
      final success = await _helper.initialize(
        const ForceUpdateConfig(
          providerType: VersionProviderType.configFile,
          configFilePath: 'assets/app_config.json',
          storeConfig: StoreConfig(
            appStoreId: '123456789',
            playStorePackage: 'com.masterfabric.example',
          ),
        ),
      );

      if (success) {
        stateChanger(state.copyWith(
          isInitialized: true,
          isLoading: false,
          currentVersion: packageInfo.version,
          statusMessage: 'Helper initialized successfully',
        ));
      } else {
        stateChanger(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to initialize helper',
        ));
      }
    } catch (e) {
      debugPrint('Error initializing: $e');
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error: $e',
      ));
    }
  }

  /// Check for updates
  Future<void> checkForUpdate() async {
    if (!state.isInitialized) {
      stateChanger(state.copyWith(
        errorMessage: 'Helper not initialized',
      ));
      return;
    }

    stateChanger(state.copyWith(isLoading: true, clearError: true));

    try {
      final updateInfo = await _helper.checkForUpdate();

      stateChanger(state.copyWith(
        isLoading: false,
        updateInfo: updateInfo,
        statusMessage: updateInfo.hasUpdate
            ? 'Update available: ${updateInfo.latestVersion}'
            : 'No update available',
      ));
    } catch (e) {
      debugPrint('Error checking for update: $e');
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: 'Error checking for update: $e',
      ));
    }
  }

  /// Create a simulated update info for demo purposes
  UpdateInfo createSimulatedUpdateInfo() {
    final config = state.demoConfig;
    
    // Determine update type based on versions
    UpdateType updateType;
    if (config.simulatedMinimumVersion != null &&
        VersionComparator.isOlderThan(
            config.simulatedCurrentVersion, config.simulatedMinimumVersion!)) {
      updateType = UpdateType.force;
    } else if (VersionComparator.isOlderThan(
        config.simulatedCurrentVersion, config.simulatedLatestVersion)) {
      updateType = config.simulatedMinimumVersion != null
          ? UpdateType.recommended
          : UpdateType.optional;
    } else {
      updateType = UpdateType.none;
    }

    return UpdateInfo(
      currentVersion: config.simulatedCurrentVersion,
      latestVersion: config.simulatedLatestVersion,
      minimumVersion: config.simulatedMinimumVersion,
      updateType: updateType,
      releaseNotes: 'This is a demo update with simulated version data.',
      features: [
        'New exciting feature',
        'Performance improvements',
        'Bug fixes',
        'UI enhancements',
      ],
      storeConfig: const StoreConfig(
        appStoreId: '123456789',
        playStorePackage: 'com.masterfabric.example',
      ),
      showLaterButton: updateType != UpdateType.force,
      showSkipButton: updateType == UpdateType.optional,
    );
  }

  /// Set selected UI type
  void setUIType(UpdateUIType type) {
    stateChanger(state.copyWith(selectedUIType: type));
  }

  /// Update demo config
  void updateDemoConfig(DemoConfig config) {
    stateChanger(state.copyWith(demoConfig: config));
  }

  /// Toggle simulation mode
  void toggleSimulationMode() {
    final newConfig = state.demoConfig.copyWith(
      useSimulation: !state.demoConfig.useSimulation,
    );
    stateChanger(state.copyWith(demoConfig: newConfig));
  }

  /// Set simulated current version
  void setSimulatedCurrentVersion(String version) {
    final newConfig = state.demoConfig.copyWith(
      simulatedCurrentVersion: version,
    );
    stateChanger(state.copyWith(demoConfig: newConfig));
  }

  /// Set simulated latest version
  void setSimulatedLatestVersion(String version) {
    final newConfig = state.demoConfig.copyWith(
      simulatedLatestVersion: version,
    );
    stateChanger(state.copyWith(demoConfig: newConfig));
  }

  /// Set simulated minimum version
  void setSimulatedMinimumVersion(String? version) {
    final newConfig = state.demoConfig.copyWith(
      simulatedMinimumVersion: version,
      clearMinimumVersion: version == null,
    );
    stateChanger(state.copyWith(demoConfig: newConfig));
  }

  /// Clear messages
  void clearMessages() {
    stateChanger(state.copyWith(clearError: true, clearStatus: true));
  }

  /// Open store
  Future<void> openStore() async {
    final success = await _helper.openStore();
    if (!success) {
      stateChanger(state.copyWith(
        errorMessage: 'Could not open store',
      ));
    }
  }
}
