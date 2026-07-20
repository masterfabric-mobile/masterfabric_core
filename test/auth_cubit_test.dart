import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masterfabric_core/src/views/auth/cubit/auth_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthCubit', () {
    test('is marked as demo auth', () {
      expect(AuthCubit.isDemoAuth, isTrue);
    });

    test('signIn rejects invalid email', () async {
      final cubit = AuthCubit();
      await cubit.signIn('not-an-email', 'password1');
      expect(cubit.state.isAuthenticated, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
      await cubit.close();
    });

    test('signIn persists demo session for valid credentials', () async {
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
