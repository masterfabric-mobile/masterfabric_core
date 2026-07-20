import 'package:flutter/foundation.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_helper.dart';
import 'package:masterfabric_core/src/helper/storage_keys.dart';

/// One-time migration of legacy `osmea_*` keys to `mf_*`.
class StorageKeyMigrator {
  StorageKeyMigrator._();

  /// Copies each legacy key to its [StorageKeys] counterpart when the new key
  /// is missing, then removes the legacy key. Idempotent via [StorageKeys.migrationDone].
  static Future<void> migrateOsmeaToMf() async {
    await LocalStorageHelper.init();

    final alreadyDone =
        await LocalStorageHelper.getItem(StorageKeys.migrationDone);
    if (alreadyDone == true || alreadyDone == 'true') {
      return;
    }

    var migrated = 0;
    for (final entry in StorageKeys.legacyToCurrent.entries) {
      final legacyKey = entry.key;
      final newKey = entry.value;
      final legacyValue = await LocalStorageHelper.getItem(legacyKey);
      if (legacyValue == null) continue;

      final existing = await LocalStorageHelper.getItem(newKey);
      if (existing == null) {
        await LocalStorageHelper.setItem(newKey, legacyValue);
        migrated++;
      }
      await LocalStorageHelper.removeItem(legacyKey);
    }

    await LocalStorageHelper.setItem(StorageKeys.migrationDone, true);
    debugPrint(
      'StorageKeyMigrator: migrated $migrated legacy osmea_* keys to mf_*',
    );
  }
}
