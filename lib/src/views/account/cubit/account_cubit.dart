import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/helper/auth_storage_helper.dart';
import 'package:masterfabric_core/src/views/account/cubit/account_state.dart';
import 'package:injectable/injectable.dart';

/// Account Cubit — loads identity from [AuthStorageHelper].
@injectable
class AccountCubit extends BaseViewModelCubit<AccountState> {
  AccountCubit() : super(const AccountState());

  Future<void> init() async {
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));

    final loggedIn = AuthStorageHelper.isLoggedIn() ?? false;
    final userId = AuthStorageHelper.getUserId();

    if (!loggedIn || userId == null || userId.isEmpty) {
      stateChanger(state.copyWith(
        isLoading: false,
        navigationTarget: '/auth',
      ));
      return;
    }

    final displayName = userId.contains('@')
        ? userId.split('@').first
        : userId;

    stateChanger(state.copyWith(
      isLoading: false,
      userName: displayName,
      userEmail: userId,
    ));
  }

  Future<void> logout() async {
    await AuthStorageHelper.clearAuth();
    stateChanger(state.copyWith(
      clearUser: true,
      clearError: true,
      navigationTarget: '/auth',
    ));
  }
}
