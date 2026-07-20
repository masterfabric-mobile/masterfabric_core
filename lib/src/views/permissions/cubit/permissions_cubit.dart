import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/helper/permission_handler_helper/permission_handler_helper.dart';
import 'package:masterfabric_core/src/views/permissions/cubit/permissions_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';

/// Permissions Cubit — uses [PermissionHandlerHelper] for real requests.
@injectable
class PermissionsCubit extends BaseViewModelCubit<PermissionsState> {
  PermissionsCubit() : super(const PermissionsState());

  final PermissionHandlerHelper _permissionHelper =
      PermissionHandlerHelper.instance;

  List<Permission> _permissions = const [];

  /// Called from [PermissionsView.initialContent] with the route permissions.
  void setPermissions(List<Permission> permissions) {
    _permissions = List<Permission>.unmodifiable(permissions);
  }

  Future<void> checkPermissions() async {
    if (_permissions.isEmpty) return;
    stateChanger(state.copyWith(isLoading: true));
    final statuses = <Permission, bool>{};
    for (final permission in _permissions) {
      statuses[permission] = await _permissionHelper.isGranted(permission);
    }
    stateChanger(state.copyWith(
      permissionStatuses: statuses,
      isLoading: false,
    ));
  }

  Future<void> requestPermissions() async {
    stateChanger(state.copyWith(isLoading: true));
    final results =
        await _permissionHelper.requestPermissions(_permissions);
    stateChanger(state.copyWith(
      permissionStatuses: results,
      isLoading: false,
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final granted = await _permissionHelper.requestPermission(permission);
    stateChanger(state.copyWith(
      permissionStatuses: {
        ...state.permissionStatuses,
        permission: granted,
      },
    ));
  }

  Future<bool> openSettings() => _permissionHelper.openAppSettings();
}
