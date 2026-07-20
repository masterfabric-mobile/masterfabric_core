import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    LocalStorageHelper.resetForTest();
    SharedPreferences.setMockInitialValues({});
    LocalStorageHelper.setStorageType(LocalStorageType.sharedPreferences);
    await LocalStorageHelper.init();
  });

  test('persists and clears auth session', () async {
    await AuthStorageHelper.setUserId('user@example.com');
    await AuthStorageHelper.setAccessToken('token');
    await AuthStorageHelper.setRefreshToken('refresh');
    await AuthStorageHelper.setLoggedIn(true);

    expect(AuthStorageHelper.getUserId(), 'user@example.com');
    expect(AuthStorageHelper.getAccessToken(), 'token');
    expect(AuthStorageHelper.getRefreshToken(), 'refresh');
    expect(AuthStorageHelper.isLoggedIn(), isTrue);

    await AuthStorageHelper.clearAuth();

    expect(AuthStorageHelper.getUserId(), isNull);
    expect(AuthStorageHelper.getAccessToken(), isNull);
    expect(AuthStorageHelper.isLoggedIn(), isNull);
  });
}
