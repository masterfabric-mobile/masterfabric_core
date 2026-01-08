import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

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
}
