import 'package:flutter/foundation.dart';
import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';
import 'package:masterfabric_core/src/views/auth/cubit/auth_state.dart';
import 'package:masterfabric_core/src/resources/resources.g.dart';
import 'package:injectable/injectable.dart';

/// Demo / sample authentication cubit — **not production security**.
///
/// Validates email/password shape only, then persists a synthetic local token
/// in secure storage. Host apps **must** replace this cubit (or override the
/// GetIt registration) with a real IdP/API-backed implementation before
/// shipping.
@injectable
class AuthCubit extends BaseViewModelCubit<AuthState> {
  /// Marks this implementation as demo-only local auth.
  static const bool isDemoAuth = true;

  AuthCubit() : super(const AuthState()) {
    if (kDebugMode) {
      debugPrint(
        'AuthCubit: DEMO auth active — replace with a real IdP for production.',
      );
    }
  }

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

      await _persistDemoSession(normalizedEmail);

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

      await _persistDemoSession(normalizedEmail);

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
    final loggedIn = await AuthStorageHelper.isLoggedIn() ?? false;
    stateChanger(state.copyWith(isAuthenticated: loggedIn));
  }

  bool _isValidCredentials(String email, String password) {
    return email.contains('@') && password.trim().length >= 4;
  }

  Future<void> _persistDemoSession(String email) async {
    await AuthStorageHelper.setUserId(email);
    // Synthetic demo token — not a real credential.
    await AuthStorageHelper.setAccessToken(
      'demo_${email.hashCode.toRadixString(16)}',
    );
    await AuthStorageHelper.setLoggedIn(true);
  }
}
