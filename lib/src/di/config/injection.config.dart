// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:masterfabric_core/src/di/config/core_module.dart' as _i369;
import 'package:masterfabric_core/src/helper/device_info_helper.dart' as _i872;
import 'package:masterfabric_core/src/helper/network_info_helper.dart' as _i471;
import 'package:masterfabric_core/src/helper/onboarding_helper.dart' as _i707;
import 'package:masterfabric_core/src/helper/package_info_helper.dart' as _i476;
import 'package:masterfabric_core/src/helper/permission_handler_helper/permission_handler_helper.dart'
    as _i422;
import 'package:masterfabric_core/src/helper/search/search_provider.dart'
    as _i391;
import 'package:masterfabric_core/src/views/account/cubit/account_cubit.dart'
    as _i924;
import 'package:masterfabric_core/src/views/auth/cubit/auth_cubit.dart'
    as _i282;
import 'package:masterfabric_core/src/views/empty_view/cubit/empty_view_cubit.dart'
    as _i347;
import 'package:masterfabric_core/src/views/error_handling/cubit/error_handling_cubit.dart'
    as _i730;
import 'package:masterfabric_core/src/views/image_detail/cubit/image_detail_cubit.dart'
    as _i534;
import 'package:masterfabric_core/src/views/info_bottom_sheet/cubit/info_bottom_sheet_cubit.dart'
    as _i728;
import 'package:masterfabric_core/src/views/loading/cubit/loading_cubit.dart'
    as _i188;
import 'package:masterfabric_core/src/views/onboarding/cubit/onboarding_cubit.dart'
    as _i1049;
import 'package:masterfabric_core/src/views/permissions/cubit/permissions_cubit.dart'
    as _i898;
import 'package:masterfabric_core/src/views/search/cubit/search_cubit.dart'
    as _i355;
import 'package:masterfabric_core/src/views/splash/cubit/splash_cubit.dart'
    as _i175;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final coreHelperModule = _$CoreHelperModule();
    gh.factory<_i924.AccountCubit>(() => _i924.AccountCubit());
    gh.factory<_i282.AuthCubit>(() => _i282.AuthCubit());
    gh.factory<_i347.EmptyViewCubit>(() => _i347.EmptyViewCubit());
    gh.factory<_i730.ErrorHandlingCubit>(() => _i730.ErrorHandlingCubit());
    gh.factory<_i534.ImageDetailCubit>(() => _i534.ImageDetailCubit());
    gh.factory<_i728.InfoBottomSheetCubit>(() => _i728.InfoBottomSheetCubit());
    gh.factory<_i188.LoadingCubit>(() => _i188.LoadingCubit());
    gh.factory<_i1049.OnboardingCubit>(() => _i1049.OnboardingCubit());
    gh.factory<_i898.PermissionsCubit>(() => _i898.PermissionsCubit());
    gh.factory<_i355.SearchCubit>(() => _i355.SearchCubit());
    gh.factory<_i175.SplashCubit>(() => _i175.SplashCubit());
    gh.lazySingleton<_i422.PermissionHandlerHelper>(
      () => coreHelperModule.permissionHandlerHelper,
    );
    gh.lazySingleton<_i872.DeviceInfoHelper>(
      () => coreHelperModule.deviceInfoHelper,
    );
    gh.lazySingleton<_i476.PackageInfoHelper>(
      () => coreHelperModule.packageInfoHelper,
    );
    gh.lazySingleton<_i471.NetworkInfoHelper>(
      () => coreHelperModule.networkInfoHelper,
    );
    gh.lazySingleton<_i707.OnboardingStorageHelper>(
      () => coreHelperModule.onboardingStorageHelper,
    );
    gh.lazySingleton<_i391.SearchProvider>(
      () => coreHelperModule.searchProvider,
    );
    return this;
  }
}

class _$CoreHelperModule extends _i369.CoreHelperModule {}
