import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_helper.dart';
import 'package:masterfabric_core/src/helper/local_storage/local_storage_type.dart';
import 'package:masterfabric_core/src/views/auth/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    LocalStorageHelper.resetForTest();
    SharedPreferences.setMockInitialValues({});
    LocalStorageHelper.setStorageType(LocalStorageType.sharedPreferences);
    await LocalStorageHelper.init();
  });

  group('AuthCubit', () {
    test('signIn rejects invalid email', () async {
      final cubit = AuthCubit();
      await cubit.signIn('not-an-email', 'password1');
      expect(cubit.state.isAuthenticated, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      await cubit.close();
    });

    test('signIn persists session for valid credentials', () async {
      final cubit = AuthCubit();
      await cubit.signIn('user@example.com', 'secret');
      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.navigationTarget, '/home');
      await cubit.close();
    });

    test('signOut clears authentication', () async {
      final cubit = AuthCubit();
      await cubit.signIn('user@example.com', 'secret');
      await cubit.signOut();
      expect(cubit.state.isAuthenticated, isFalse);
      expect(cubit.state.navigationTarget, '/auth');
      await cubit.close();
    });
  });
}
