import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'app/app.dart';
import 'app/di/injection.dart' as di;
import 'app/routes.dart' as app_routes;
import 'app/theme/aura_theme_config.dart';
import 'data/fitness_repository.dart';
import 'jobs/aura_activity_jobs.dart';
import 'src/resources/resources.g.dart' as aura;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
    requestTrackingTransparency: false,
  );

  // Prefer device locale when it is in supportedLocales; else config default.
  final supported = AuraThemeConfig.supportedLocales();
  final device = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  if (supported.contains(device)) {
    await aura.LocaleSettings.setLocaleRaw(device);
  } else {
    await aura.LocaleSettings.setLocaleRaw(AuraThemeConfig.defaultLocale());
  }

  await LocalNotificationHelper.initialize(
    iosSettings: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
  );
  di.configureDependencies();
  await di.getIt<FitnessRepository>().load();

  final profile = di.getIt<FitnessRepository>().profile;
  if (profile.permissionsComplete) {
    await di.getIt<AuraActivityJobs>().start();
  }

  final router = app_routes.AppRoutes.createRouter();
  runApp(aura.TranslationProvider(child: App(router: router)));
}
