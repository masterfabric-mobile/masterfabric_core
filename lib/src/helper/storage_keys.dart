/// Canonical MasterFabric local-storage key names (`mf_*`).
///
/// Legacy `osmea_*` keys are migrated once via [StorageKeyMigrator].
abstract final class StorageKeys {
  static const String migrationDone = 'mf_storage_key_migration_v1';

  static const String onboardingSeen = 'mf_onboarding_seen';
  static const String trackingAuthorized = 'mf_tracking_authorized';

  static const String configLoaded = 'mf_config_loaded';
  static const String configSource = 'mf_config_source';
  static const String configIsFallback = 'mf_config_is_fallback';

  static const String deviceId = 'mf_device_id';
  static const String packageVersion = 'mf_package_version';
  static const String packageBuildNumber = 'mf_package_build_number';
  static const String packageAppName = 'mf_package_app_name';
  static const String packagePackageName = 'mf_package_package_name';
  static const String packageVersionAndBuildNumber =
      'mf_package_version_and_build_number';
  static const String packageManufacturer = 'mf_package_manufacturer';
  static const String packageDeviceName = 'mf_package_device_name';
  static const String packageDeviceId = 'mf_package_device_id';
  static const String packageDeviceModel = 'mf_package_device_model';
  static const String packageDevicePhysical = 'mf_package_device_physical';
  static const String packageDeviceSystemVersion =
      'mf_package_device_system_version';

  static const String cfIp = 'mf_cf_ip';
  static const String cfLocation = 'mf_cf_location';
  static const String cfColo = 'mf_cf_colo';
  static const String cfTls = 'mf_cf_tls';
  static const String cfHttp = 'mf_cf_http';
  static const String cfWarp = 'mf_cf_warp';

  static const String publicIp = 'mf_public_ip';
  static const String connectionType = 'mf_connection_type';
  static const String isConnected = 'mf_is_connected';
  static const String wifiName = 'mf_wifi_name';
  static const String wifiIp = 'mf_wifi_ip';
  static const String wifiGateway = 'mf_wifi_gateway';

  /// Legacy OSMEA key → new MasterFabric key.
  static const Map<String, String> legacyToCurrent = {
    'osmea_onboarding_seen': onboardingSeen,
    'osmea_tracking_authorized': trackingAuthorized,
    'osmea_config_loaded': configLoaded,
    'osmea_config_source': configSource,
    'osmea_config_is_fallback': configIsFallback,
    'osmea_device_id': deviceId,
    'osmea_package_version': packageVersion,
    'osmea_package_build_number': packageBuildNumber,
    'osmea_package_app_name': packageAppName,
    'osmea_package_package_name': packagePackageName,
    'osmea_package_version_and_build_number': packageVersionAndBuildNumber,
    'osmea_package_manufacturer': packageManufacturer,
    'osmea_package_device_name': packageDeviceName,
    'osmea_package_device_id': packageDeviceId,
    'osmea_package_device_model': packageDeviceModel,
    'osmea_package_device_physical': packageDevicePhysical,
    'osmea_package_device_system_version': packageDeviceSystemVersion,
    'osmea_cf_ip': cfIp,
    'osmea_cf_location': cfLocation,
    'osmea_cf_colo': cfColo,
    'osmea_cf_tls': cfTls,
    'osmea_cf_http': cfHttp,
    'osmea_cf_warp': cfWarp,
    'osmea_public_ip': publicIp,
    'osmea_connection_type': connectionType,
    'osmea_is_connected': isConnected,
    'osmea_wifi_name': wifiName,
    'osmea_wifi_ip': wifiIp,
    'osmea_wifi_gateway': wifiGateway,
  };
}
