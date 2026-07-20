import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists authentication secrets in platform secure storage
/// (Android Keystore-backed prefs / iOS Keychain).
///
/// Do not store access/refresh tokens in SharedPreferences or plain Hive.
class AuthStorageHelper {
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyIsLoggedIn = 'auth_is_logged_in';

  static const FlutterSecureStorage _secure = FlutterSecureStorage(
    aOptions: AndroidOptions.defaultOptions,
  );

  /// Save access token
  static Future<bool> setAccessToken(String token) async {
    await _secure.write(key: _keyAccessToken, value: token);
    return true;
  }

  /// Get access token
  static Future<String?> getAccessToken() =>
      _secure.read(key: _keyAccessToken);

  /// Save refresh token
  static Future<bool> setRefreshToken(String token) async {
    await _secure.write(key: _keyRefreshToken, value: token);
    return true;
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() =>
      _secure.read(key: _keyRefreshToken);

  /// Save user ID
  static Future<bool> setUserId(String userId) async {
    await _secure.write(key: _keyUserId, value: userId);
    return true;
  }

  /// Get user ID
  static Future<String?> getUserId() => _secure.read(key: _keyUserId);

  /// Set logged in status
  static Future<bool> setLoggedIn(bool isLoggedIn) async {
    await _secure.write(
      key: _keyIsLoggedIn,
      value: isLoggedIn ? 'true' : 'false',
    );
    return true;
  }

  /// Get logged in status
  static Future<bool?> isLoggedIn() async {
    final value = await _secure.read(key: _keyIsLoggedIn);
    if (value == null) return null;
    return value == 'true';
  }

  /// Clear all auth data
  static Future<bool> clearAuth() async {
    await Future.wait([
      _secure.delete(key: _keyAccessToken),
      _secure.delete(key: _keyRefreshToken),
      _secure.delete(key: _keyUserId),
      _secure.delete(key: _keyIsLoggedIn),
    ]);
    return true;
  }
}
