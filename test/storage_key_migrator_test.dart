import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_type.dart';
import 'package:masterfabric_core/src/helper/storage_key_migrator.dart';
import 'package:masterfabric_core/src/helper/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    LocalStorageHelper.resetForTest();
    SharedPreferences.setMockInitialValues({
      'osmea_onboarding_seen': true,
      'osmea_cf_ip': '1.2.3.4',
    });
    LocalStorageHelper.setStorageType(LocalStorageType.sharedPreferences);
    await LocalStorageHelper.init();
  });

  test('migrates legacy osmea_* keys to mf_* once', () async {
    await StorageKeyMigrator.migrateOsmeaToMf();

    expect(
      await LocalStorageHelper.getItem(StorageKeys.onboardingSeen),
      isTrue,
    );
    expect(await LocalStorageHelper.getItem(StorageKeys.cfIp), '1.2.3.4');
    expect(await LocalStorageHelper.getItem('osmea_onboarding_seen'), isNull);
    expect(
      await LocalStorageHelper.getItem(StorageKeys.migrationDone),
      isTrue,
    );

    // Second run is a no-op
    await LocalStorageHelper.setItem(StorageKeys.onboardingSeen, false);
    await StorageKeyMigrator.migrateOsmeaToMf();
    expect(
      await LocalStorageHelper.getItem(StorageKeys.onboardingSeen),
      isFalse,
    );
  });
}
