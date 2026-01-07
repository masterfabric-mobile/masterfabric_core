import 'package:shared_preferences/shared_preferences.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_type.dart';
import 'package:masterfabric_core/src/helper/local_storage/hive_ce_storage_helper.dart';

/// Helper class for local storage operations
/// Supports multiple storage backends: SharedPreferences (default) and HiveCE
class LocalStorageHelper {
  static SharedPreferences? _prefs;
  static LocalStorageType _storageType = LocalStorageType.sharedPreferences;

  /// Set the storage type to use
  static void setStorageType(LocalStorageType type) {
    _storageType = type;
  }

  /// Get current storage type
  static LocalStorageType get storageType => _storageType;

  /// Initialize storage based on current storage type
  static Future<void> init() async {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        _prefs ??= await SharedPreferences.getInstance();
        break;
      case LocalStorageType.hiveCe:
        await HiveCeStorageHelper.init();
        break;
    }
  }

  /// Get SharedPreferences instance (only available when using SharedPreferences)
  static SharedPreferences? get instance => _prefs;

  /// Save a string value
  static Future<bool> setString(String key, String value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.setString(key, value);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setString(key, value);
    }
  }

  /// Get a string value
  static String? getString(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getString(key);
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getString(key);
    }
  }

  /// Save an integer value
  static Future<bool> setInt(String key, int value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.setInt(key, value);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setInt(key, value);
    }
  }

  /// Get an integer value
  static int? getInt(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getInt(key);
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getInt(key);
    }
  }

  /// Save a boolean value
  static Future<bool> setBool(String key, bool value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.setBool(key, value);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setBool(key, value);
    }
  }

  /// Get a boolean value
  static bool? getBool(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getBool(key);
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getBool(key);
    }
  }

  /// Save a double value
  static Future<bool> setDouble(String key, double value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.setDouble(key, value);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setDouble(key, value);
    }
  }

  /// Get a double value
  static double? getDouble(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getDouble(key);
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getDouble(key);
    }
  }

  /// Save a string list
  static Future<bool> setStringList(String key, List<String> value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.setStringList(key, value);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setStringList(key, value);
    }
  }

  /// Get a string list
  static List<String>? getStringList(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getStringList(key);
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getStringList(key);
    }
  }

  /// Remove a key
  static Future<bool> remove(String key) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.remove(key);
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.remove(key);
    }
  }

  /// Clear all data
  static Future<bool> clear() async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return await _prefs!.clear();
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.clear();
    }
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.containsKey(key) ?? false;
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.containsKey(key);
    }
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        return _prefs?.getKeys() ?? {};
      case LocalStorageType.hiveCe:
        return HiveCeStorageHelper.getAllKeys();
    }
  }

  /// Get an item by key (supports all types)
  static Future<dynamic> getItem(String key) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        if (_prefs == null) return null;
        if (_prefs!.containsKey(key)) {
          return _prefs!.get(key);
        }
        return null;
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.getItem(key);
    }
  }

  /// Set an item by key (supports all types)
  static Future<bool> setItem(String key, dynamic value) async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        if (_prefs == null) return false;
        if (value is String) {
          return await _prefs!.setString(key, value);
        } else if (value is int) {
          return await _prefs!.setInt(key, value);
        } else if (value is bool) {
          return await _prefs!.setBool(key, value);
        } else if (value is double) {
          return await _prefs!.setDouble(key, value);
        } else if (value is List<String>) {
          return await _prefs!.setStringList(key, value);
        }
        return false;
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.setItem(key, value);
    }
  }

  /// Remove an item by key
  static Future<bool> removeItem(String key) async {
    return await remove(key);
  }

  /// Get all items as a map
  static Future<Map<String, dynamic>> getAllItems() async {
    await init();
    switch (_storageType) {
      case LocalStorageType.sharedPreferences:
        if (_prefs == null) return {};
        final keys = _prefs!.getKeys();
        final Map<String, dynamic> items = {};
        for (final key in keys) {
          items[key] = _prefs!.get(key);
        }
        return items;
      case LocalStorageType.hiveCe:
        return await HiveCeStorageHelper.getAllItems();
    }
  }
}
