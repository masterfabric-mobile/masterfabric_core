import 'package:flutter/foundation.dart';

import '../../asset_config_helper.dart';
import 'version_provider.dart';

/// Version provider that reads from app_config.json
class ConfigFileProvider implements VersionProvider {
  /// Config file path
  final String configPath;

  /// Config key for force update data
  final String configKey;

  /// Asset config helper instance
  final AssetConfigHelper _configHelper;

  ConfigFileProvider({
    this.configPath = 'assets/app_config.json',
    this.configKey = 'forceUpdateConfiguration',
  }) : _configHelper = AssetConfigHelper();

  @override
  Future<VersionData> fetchVersionInfo() async {
    try {
      await _configHelper.loadConfig(configPath);
      final config = _configHelper.getAllConfig();

      if (config == null) {
        throw Exception('Failed to load config from $configPath');
      }

      final updateConfig = config[configKey] as Map<String, dynamic>?;

      if (updateConfig == null) {
        throw Exception('Key "$configKey" not found in config');
      }

      return VersionData.fromJson(updateConfig);
    } catch (e) {
      debugPrint('ConfigFileProvider error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      await _configHelper.loadConfig(configPath);
      final config = _configHelper.getAllConfig();
      return config != null && config[configKey] != null;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    // No resources to dispose
  }
}
