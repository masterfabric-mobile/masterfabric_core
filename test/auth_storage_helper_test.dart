import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('persists and clears auth session in secure storage', () async {
    await AuthStorageHelper.setUserId('user@example.com');
    await AuthStorageHelper.setAccessToken('token');
    await AuthStorageHelper.setRefreshToken('refresh');
    await AuthStorageHelper.setLoggedIn(true);

    expect(await AuthStorageHelper.getUserId(), 'user@example.com');
    expect(await AuthStorageHelper.getAccessToken(), 'token');
    expect(await AuthStorageHelper.getRefreshToken(), 'refresh');
    expect(await AuthStorageHelper.isLoggedIn(), isTrue);

    await AuthStorageHelper.clearAuth();

    expect(await AuthStorageHelper.getUserId(), isNull);
    expect(await AuthStorageHelper.getAccessToken(), isNull);
    expect(await AuthStorageHelper.isLoggedIn(), isNull);
  });
}
