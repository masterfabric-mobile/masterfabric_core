import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../views/helpers/config/cubit/config_cubit.dart';
import '../../views/helpers/datetime/cubit/datetime_cubit.dart';
import '../../views/helpers/device_info/cubit/device_info_cubit.dart';
import '../../views/helpers/download/cubit/download_cubit.dart';
import '../../views/helpers/force_update/cubit/force_update_demo_cubit.dart';
import '../../views/helpers/network_info/cubit/network_info_cubit.dart';
import '../../views/helpers/package_info/cubit/package_info_cubit.dart';
import '../../views/helpers/permissions/cubit/permissions_cubit.dart';
import '../../views/helpers/push_notification/cubit/push_notification_cubit.dart';
import '../../views/helpers/share/cubit/share_cubit.dart';
import '../../views/helpers/skeleton/cubit/skeleton_demo_cubit.dart';
import '../../views/helpers/storage/cubit/storage_cubit.dart';
import '../../views/helpers/storage/hive_ce/cubit/hive_ce_storage_cubit.dart';
import '../../views/helpers/svg/cubit/svg_cubit.dart';
import '../../views/helpers/url_launcher/cubit/url_launcher_cubit.dart';
import '../../views/helpers/web_viewer/cubit/web_viewer_cases_cubit.dart';
import '../../views/home/cubit/home_cubit.dart';
import '../../views/products/cubit/products_cubit.dart';
import '../../views/profile/cubit/profile_cubit.dart';
import '../../views/settings/cubit/theme_cubit.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
  _registerCoreCubits();
  _registerExampleCubits();
}

/// Register masterfabric_core cubits that are used in routes
/// These are needed because MasterViewCubit uses GetIt to resolve cubits
void _registerCoreCubits() {
  // Core views cubits from masterfabric_core
  if (!getIt.isRegistered<SplashCubit>()) {
    getIt.registerFactory<SplashCubit>(() => SplashCubit());
  }
  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(() => AuthCubit());
  }
  if (!getIt.isRegistered<OnboardingCubit>()) {
    getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  }
  if (!getIt.isRegistered<ErrorHandlingCubit>()) {
    getIt.registerFactory<ErrorHandlingCubit>(() => ErrorHandlingCubit());
  }
  if (!getIt.isRegistered<EmptyViewCubit>()) {
    getIt.registerFactory<EmptyViewCubit>(() => EmptyViewCubit());
  }
  if (!getIt.isRegistered<AccountCubit>()) {
    getIt.registerFactory<AccountCubit>(() => AccountCubit());
  }
  if (!getIt.isRegistered<SearchCubit>()) {
    getIt.registerFactory<SearchCubit>(() => SearchCubit());
  }
  if (!getIt.isRegistered<PermissionsCubit>()) {
    getIt.registerFactory<PermissionsCubit>(() => PermissionsCubit());
  }
  if (!getIt.isRegistered<LoadingCubit>()) {
    getIt.registerFactory<LoadingCubit>(() => LoadingCubit());
  }
  if (!getIt.isRegistered<InfoBottomSheetCubit>()) {
    getIt.registerFactory<InfoBottomSheetCubit>(() => InfoBottomSheetCubit());
  }
  if (!getIt.isRegistered<ImageDetailCubit>()) {
    getIt.registerFactory<ImageDetailCubit>(() => ImageDetailCubit());
  }
  if (!getIt.isRegistered<SearchProvider>()) {
    getIt.registerSingleton<SearchProvider>(DefaultSearchProvider());
  }

  // Register ThemeCubit as singleton for app-wide theme management
  if (!getIt.isRegistered<ThemeCubit>()) {
    getIt.registerSingleton<ThemeCubit>(ThemeCubit());
  }
}

/// Example-app cubits are `@injectable` but missing from generated
/// `injection.config.dart` (codegen only emits core helpers). Register
/// them manually so MasterViewCubit / GetIt.I can resolve them.
void _registerExampleCubits() {
  if (!getIt.isRegistered<HomeCubit>()) {
    getIt.registerFactory<HomeCubit>(() => HomeCubit());
  }
  if (!getIt.isRegistered<ProductsCubit>()) {
    getIt.registerFactory<ProductsCubit>(() => ProductsCubit());
  }
  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(() => ProfileCubit());
  }
  if (!getIt.isRegistered<ConfigCubit>()) {
    getIt.registerFactory<ConfigCubit>(() => ConfigCubit());
  }
  if (!getIt.isRegistered<DateTimeCubit>()) {
    getIt.registerFactory<DateTimeCubit>(() => DateTimeCubit());
  }
  if (!getIt.isRegistered<DeviceInfoCubit>()) {
    getIt.registerFactory<DeviceInfoCubit>(() => DeviceInfoCubit());
  }
  if (!getIt.isRegistered<DownloadCubit>()) {
    getIt.registerFactory<DownloadCubit>(() => DownloadCubit());
  }
  if (!getIt.isRegistered<ForceUpdateDemoCubit>()) {
    getIt.registerFactory<ForceUpdateDemoCubit>(() => ForceUpdateDemoCubit());
  }
  if (!getIt.isRegistered<NetworkInfoCubit>()) {
    getIt.registerFactory<NetworkInfoCubit>(() => NetworkInfoCubit());
  }
  if (!getIt.isRegistered<PackageInfoCubit>()) {
    getIt.registerFactory<PackageInfoCubit>(() => PackageInfoCubit());
  }
  if (!getIt.isRegistered<HelperPermissionsCubit>()) {
    getIt.registerFactory<HelperPermissionsCubit>(
      () => HelperPermissionsCubit(),
    );
  }
  if (!getIt.isRegistered<PushNotificationCubit>()) {
    getIt.registerFactory<PushNotificationCubit>(() => PushNotificationCubit());
  }
  if (!getIt.isRegistered<ShareCubit>()) {
    getIt.registerFactory<ShareCubit>(() => ShareCubit());
  }
  if (!getIt.isRegistered<SkeletonDemoCubit>()) {
    getIt.registerFactory<SkeletonDemoCubit>(() => SkeletonDemoCubit());
  }
  if (!getIt.isRegistered<StorageCubit>()) {
    getIt.registerFactory<StorageCubit>(() => StorageCubit());
  }
  if (!getIt.isRegistered<HiveCeStorageCubit>()) {
    getIt.registerFactory<HiveCeStorageCubit>(() => HiveCeStorageCubit());
  }
  if (!getIt.isRegistered<SvgCubit>()) {
    getIt.registerFactory<SvgCubit>(() => SvgCubit());
  }
  if (!getIt.isRegistered<UrlLauncherCubit>()) {
    getIt.registerFactory<UrlLauncherCubit>(() => UrlLauncherCubit());
  }
  if (!getIt.isRegistered<WebViewerCasesCubit>()) {
    getIt.registerFactory<WebViewerCasesCubit>(() => WebViewerCasesCubit());
  }
}
