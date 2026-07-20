import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';
import 'package:masterfabric_core/src/views/auth/cubit/auth_state.dart';
import 'package:masterfabric_core/src/resources/resources.g.dart';
import 'package:injectable/injectable.dart';

/// Authentication Cubit — persists session via [AuthStorageHelper].
///
/// Host apps that need remote auth can subclass or replace this registration
/// in GetIt after [configureDependencies].
@injectable
class AuthCubit extends BaseViewModelCubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void switchTab(AuthTabType tab) {
    stateChanger(state.copyWith(currentTab: tab, errorMessage: null));
  }

  Future<void> signIn(String email, String password) async {
    try {
      stateChanger(state.copyWith(isLoading: true, errorMessage: null));

      final normalizedEmail = email.trim();
      if (!_isValidCredentials(normalizedEmail, password)) {
        stateChanger(state.copyWith(
          isLoading: false,
          errorMessage: resources.auth.sign_in_failed,
        ));
        return;
      }

      await _persistSession(normalizedEmail);

      stateChanger(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        navigationTarget: '/home',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: '${resources.auth.sign_in_failed}: $e',
      ));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      stateChanger(state.copyWith(isLoading: true, errorMessage: null));

      final normalizedEmail = email.trim();
      if (!_isValidCredentials(normalizedEmail, password)) {
        stateChanger(state.copyWith(
          isLoading: false,
          errorMessage: resources.auth.sign_up_failed,
        ));
        return;
      }

      await _persistSession(normalizedEmail);

      stateChanger(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        navigationTarget: '/home',
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        errorMessage: '${resources.auth.sign_up_failed}: $e',
      ));
    }
  }

  Future<void> signOut() async {
    await AuthStorageHelper.clearAuth();
    stateChanger(state.copyWith(
      isAuthenticated: false,
      navigationTarget: '/auth',
    ));
  }

  Future<void> restoreSession() async {
    final loggedIn = AuthStorageHelper.isLoggedIn() ?? false;
    stateChanger(state.copyWith(isAuthenticated: loggedIn));
  }

  bool _isValidCredentials(String email, String password) {
    return email.contains('@') && password.trim().length >= 4;
  }

  Future<void> _persistSession(String email) async {
    await AuthStorageHelper.setUserId(email);
    await AuthStorageHelper.setAccessToken(
      'local_${email.hashCode.toRadixString(16)}',
    );
    await AuthStorageHelper.setLoggedIn(true);
  }
}
