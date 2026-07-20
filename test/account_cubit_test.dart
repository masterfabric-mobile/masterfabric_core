import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_type.dart';
import 'package:masterfabric_core/src/views/account/cubit/account_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    LocalStorageHelper.resetForTest();
    SharedPreferences.setMockInitialValues({});
    LocalStorageHelper.setStorageType(LocalStorageType.sharedPreferences);
    await LocalStorageHelper.init();
  });

  test('init redirects to auth when not logged in', () async {
    final cubit = AccountCubit();
    await cubit.init();
    expect(cubit.state.navigationTarget, '/auth');
    await cubit.close();
  });

  test('init loads user from AuthStorageHelper', () async {
    await AuthStorageHelper.setUserId('jane@example.com');
    await AuthStorageHelper.setLoggedIn(true);

    final cubit = AccountCubit();
    await cubit.init();
    expect(cubit.state.userEmail, 'jane@example.com');
    expect(cubit.state.userName, 'jane');
    await cubit.close();
  });

  test('logout clears session and navigates to auth', () async {
    await AuthStorageHelper.setUserId('jane@example.com');
    await AuthStorageHelper.setLoggedIn(true);

    final cubit = AccountCubit();
    await cubit.init();
    await cubit.logout();

    expect(cubit.state.navigationTarget, '/auth');
    expect(cubit.state.userEmail, isNull);
    expect(AuthStorageHelper.isLoggedIn(), isNull);
    await cubit.close();
  });
}
