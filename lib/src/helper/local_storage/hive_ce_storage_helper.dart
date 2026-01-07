import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// Helper class for local storage operations using HiveCE
class HiveCeStorageHelper {
  static bool _initialized = false;
  static Box? _box;
  static const String _boxName = 'masterfabric_storage';

  /// Initialize HiveCE
  static Future<void> init() async {
    if (_initialized && _box != null) {
      return;
    }

    try {
      if (!_initialized) {
        if (kIsWeb) {
          // For web, use in-memory storage
          Hive.init('');
        } else {
          // For mobile/desktop, use application documents directory
          final appDir = await getApplicationDocumentsDirectory();
          Hive.init(appDir.path);
        }
        _initialized = true;
      }

      // Open or get existing box
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox(_boxName);
      } else {
        _box = Hive.box(_boxName);
      }
    } catch (e) {
      debugPrint('❌ Error initializing HiveCE: $e');
      rethrow;
    }
  }

  /// Get Hive box instance
  static Box? get instance => _box;

  /// Save a string value
  static Future<bool> setString(String key, String value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Get a string value
  static String? getString(String key) {
    if (_box == null) return null;
    return _box!.get(key) as String?;
  }

  /// Save an integer value
  static Future<bool> setInt(String key, int value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Get an integer value
  static int? getInt(String key) {
    if (_box == null) return null;
    return _box!.get(key) as int?;
  }

  /// Save a boolean value
  static Future<bool> setBool(String key, bool value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Get a boolean value
  static bool? getBool(String key) {
    if (_box == null) return null;
    return _box!.get(key) as bool?;
  }

  /// Save a double value
  static Future<bool> setDouble(String key, double value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Get a double value
  static double? getDouble(String key) {
    if (_box == null) return null;
    final value = _box!.get(key);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null;
  }

  /// Save a string list
  static Future<bool> setStringList(String key, List<String> value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Get a string list
  static List<String>? getStringList(String key) {
    if (_box == null) return null;
    final value = _box!.get(key);
    if (value is List) {
      return value.cast<String>();
    }
    return null;
  }

  /// Remove a key
  static Future<bool> remove(String key) async {
    await init();
    if (_box == null) return false;
    await _box!.delete(key);
    return true;
  }

  /// Clear all data
  static Future<bool> clear() async {
    await init();
    if (_box == null) return false;
    await _box!.clear();
    return true;
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    if (_box == null) return false;
    return _box!.containsKey(key);
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    if (_box == null) return {};
    return _box!.keys.cast<String>().toSet();
  }

  /// Get an item by key (supports all types)
  static Future<dynamic> getItem(String key) async {
    await init();
    if (_box == null) return null;
    return _box!.get(key);
  }

  /// Set an item by key (supports all types)
  static Future<bool> setItem(String key, dynamic value) async {
    await init();
    if (_box == null) return false;
    await _box!.put(key, value);
    return true;
  }

  /// Remove an item by key
  static Future<bool> removeItem(String key) async {
    return await remove(key);
  }

  /// Get all items as a map
  static Future<Map<String, dynamic>> getAllItems() async {
    await init();
    if (_box == null) return {};
    
    final Map<String, dynamic> items = {};
    for (final key in _box!.keys) {
      items[key.toString()] = _box!.get(key);
    }
    
    return items;
  }

  /// Close the box (cleanup)
  static Future<void> close() async {
    if (_box != null && Hive.isBoxOpen(_boxName)) {
      await _box!.close();
      _box = null;
    }
  }
}

