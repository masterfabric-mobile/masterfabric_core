import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/src/helper/device_info_helper.dart';
import 'package:masterfabric_core/src/helper/onboarding_helper.dart';
import 'package:masterfabric_core/src/helper/package_info_helper.dart';
import 'package:masterfabric_core/src/helper/permission_handler_helper/permission_handler_helper.dart';
import 'package:masterfabric_core/src/helper/search/search_provider.dart';
import 'package:masterfabric_core/src/helper/network_info_helper.dart';

/// Injectable module that exposes core helper singletons to GetIt.
@module
abstract class CoreHelperModule {
  @lazySingleton
  PermissionHandlerHelper get permissionHandlerHelper =>
      PermissionHandlerHelper.instance;

  @lazySingleton
  DeviceInfoHelper get deviceInfoHelper => DeviceInfoHelper.instance;

  @lazySingleton
  PackageInfoHelper get packageInfoHelper => PackageInfoHelper.instance;

  @lazySingleton
  NetworkInfoHelper get networkInfoHelper => NetworkInfoHelper.instance;

  @lazySingleton
  OnboardingStorageHelper get onboardingStorageHelper =>
      OnboardingStorageHelper();

  @lazySingleton
  SearchProvider get searchProvider => DefaultSearchProvider();
}
