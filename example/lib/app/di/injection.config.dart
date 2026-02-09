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

import '../../views/helpers/config/cubit/config_cubit.dart' as _i52;
import '../../views/helpers/datetime/cubit/datetime_cubit.dart' as _i746;
import '../../views/helpers/device_info/cubit/device_info_cubit.dart' as _i314;
import '../../views/helpers/download/cubit/download_cubit.dart' as _i305;
import '../../views/helpers/force_update/cubit/force_update_demo_cubit.dart'
    as _i892;
import '../../views/helpers/network_info/cubit/network_info_cubit.dart'
    as _i532;
import '../../views/helpers/package_info/cubit/package_info_cubit.dart'
    as _i191;
import '../../views/helpers/permissions/cubit/permissions_cubit.dart' as _i28;
import '../../views/helpers/push_notification/cubit/push_notification_cubit.dart'
    as _i209;
import '../../views/helpers/share/cubit/share_cubit.dart' as _i37;
import '../../views/helpers/skeleton/cubit/skeleton_demo_cubit.dart' as _i107;
import '../../views/helpers/storage/cubit/storage_cubit.dart' as _i581;
import '../../views/helpers/storage/hive_ce/cubit/hive_ce_storage_cubit.dart'
    as _i819;
import '../../views/helpers/svg/cubit/svg_cubit.dart' as _i776;
import '../../views/helpers/url_launcher/cubit/url_launcher_cubit.dart'
    as _i816;
import '../../views/helpers/web_viewer/cubit/web_viewer_cases_cubit.dart'
    as _i890;
import '../../views/home/cubit/home_cubit.dart' as _i565;
import '../../views/products/cubit/products_cubit.dart' as _i567;
import '../../views/profile/cubit/profile_cubit.dart' as _i777;
import '../../views/settings/cubit/theme_cubit.dart' as _i478;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i52.ConfigCubit>(() => _i52.ConfigCubit());
    gh.factory<_i746.DateTimeCubit>(() => _i746.DateTimeCubit());
    gh.factory<_i314.DeviceInfoCubit>(() => _i314.DeviceInfoCubit());
    gh.factory<_i305.DownloadCubit>(() => _i305.DownloadCubit());
    gh.factory<_i892.ForceUpdateDemoCubit>(() => _i892.ForceUpdateDemoCubit());
    gh.factory<_i532.NetworkInfoCubit>(() => _i532.NetworkInfoCubit());
    gh.factory<_i191.PackageInfoCubit>(() => _i191.PackageInfoCubit());
    gh.factory<_i28.HelperPermissionsCubit>(
      () => _i28.HelperPermissionsCubit(),
    );
    gh.factory<_i209.PushNotificationCubit>(
      () => _i209.PushNotificationCubit(),
    );
    gh.factory<_i37.ShareCubit>(() => _i37.ShareCubit());
    gh.factory<_i107.SkeletonDemoCubit>(() => _i107.SkeletonDemoCubit());
    gh.factory<_i581.StorageCubit>(() => _i581.StorageCubit());
    gh.factory<_i819.HiveCeStorageCubit>(() => _i819.HiveCeStorageCubit());
    gh.factory<_i776.SvgCubit>(() => _i776.SvgCubit());
    gh.factory<_i816.UrlLauncherCubit>(() => _i816.UrlLauncherCubit());
    gh.factory<_i890.WebViewerCasesCubit>(() => _i890.WebViewerCasesCubit());
    gh.factory<_i565.HomeCubit>(() => _i565.HomeCubit());
    gh.factory<_i567.ProductsCubit>(() => _i567.ProductsCubit());
    gh.factory<_i777.ProfileCubit>(() => _i777.ProfileCubit());
    gh.factory<_i478.ThemeCubit>(() => _i478.ThemeCubit());
    return this;
  }
}
