import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masterfabric_core/src/helper/storage_keys.dart';
import 'package:uuid/uuid.dart';

/// Persists a per-installation UUID in secure storage (Keychain / Keystore).
///
/// Prefer this over Android build fingerprint for device binding.
class InstallIdStore {
  InstallIdStore._();

  static const FlutterSecureStorage _secure = FlutterSecureStorage(
    aOptions: AndroidOptions.defaultOptions,
  );

  static const _uuid = Uuid();

  /// Returns the existing install id or creates and stores a new one.
  static Future<String> getOrCreate() async {
    final existing = await _secure.read(key: StorageKeys.installId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final id = _uuid.v4();
    await _secure.write(key: StorageKeys.installId, value: id);
    return id;
  }

  /// Clears the install id (tests / logout of device binding).
  static Future<void> clear() => _secure.delete(key: StorageKeys.installId);
}
