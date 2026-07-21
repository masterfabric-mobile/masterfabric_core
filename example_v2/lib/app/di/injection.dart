import 'package:get_it/get_it.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../data/fitness_repository.dart';
import '../../jobs/aura_activity_jobs.dart';
import '../../views/body/cubit/body_cubit.dart';
import '../../views/coach/cubit/coach_cubit.dart';
import '../../views/log/cubit/log_cubit.dart';
import '../../views/today/cubit/today_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  _registerCore();
  _registerAura();
}

void _registerCore() {
  if (!getIt.isRegistered<SplashCubit>()) {
    getIt.registerFactory<SplashCubit>(() => SplashCubit());
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
  if (!getIt.isRegistered<LoadingCubit>()) {
    getIt.registerFactory<LoadingCubit>(() => LoadingCubit());
  }
}

void _registerAura() {
  if (!getIt.isRegistered<FitnessRepository>()) {
    getIt.registerSingleton<FitnessRepository>(FitnessRepository());
  }
  if (!getIt.isRegistered<AuraActivityJobs>()) {
    getIt.registerSingleton<AuraActivityJobs>(
      AuraActivityJobs(getIt<FitnessRepository>()),
    );
  }
  if (!getIt.isRegistered<TodayCubit>()) {
    getIt.registerFactory<TodayCubit>(
      () => TodayCubit(getIt<FitnessRepository>()),
    );
  }
  if (!getIt.isRegistered<LogCubit>()) {
    getIt.registerFactory<LogCubit>(
      () => LogCubit(getIt<FitnessRepository>()),
    );
  }
  if (!getIt.isRegistered<BodyCubit>()) {
    getIt.registerFactory<BodyCubit>(
      () => BodyCubit(getIt<FitnessRepository>()),
    );
  }
  if (!getIt.isRegistered<CoachCubit>()) {
    getIt.registerFactory<CoachCubit>(
      () => CoachCubit(getIt<FitnessRepository>()),
    );
  }
}
