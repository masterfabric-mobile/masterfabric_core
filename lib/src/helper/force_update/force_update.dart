/// Force Update Helper
/// 
/// A flexible module for managing app version checks and update prompts.
/// 
/// Features:
/// - Multiple version providers (config file, API, Remote Config, custom)
/// - Multiple UI styles (dialog, bottom sheet, full screen)
/// - Semantic version comparison
/// - Store redirects (App Store, Play Store, custom URLs)
/// - Customizable strings for localization
/// 
/// Example:
/// ```dart
/// // Initialize
/// await ForceUpdateHelper.instance.initialize(
///   ForceUpdateConfig(
///     providerType: VersionProviderType.configFile,
///     storeConfig: StoreConfig(
///       appStoreId: '123456789',
///       playStorePackage: 'com.example.app',
///     ),
///   ),
/// );
/// 
/// // Check for updates
/// final updateInfo = await ForceUpdateHelper.instance.checkForUpdate();
/// 
/// // Show UI if needed
/// if (updateInfo.hasUpdate) {
///   await ForceUpdateHelper.instance.showUpdateUI(context, updateInfo);
/// }
/// ```

export 'models/force_update_models.dart';
export 'providers/force_update_providers.dart';
export 'widgets/force_update_widgets.dart';
export 'version_comparator.dart';
export 'store_redirector.dart';
export 'force_update_helper.dart';
