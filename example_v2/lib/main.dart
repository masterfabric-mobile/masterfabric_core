import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'app/app.dart';
import 'app/di/injection.dart' as di;
import 'app/routes.dart' as app_routes;
import 'data/fitness_repository.dart';
import 'jobs/aura_activity_jobs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
    requestTrackingTransparency: false,
  );

  // Do not request notification permission here — second onboarding queue owns it.
  await LocalNotificationHelper.initialize(
    iosSettings: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
  );
  di.configureDependencies();
  await di.getIt<FitnessRepository>().load();

  // Activity jobs start after permissions queue (or immediately if already done).
  final profile = di.getIt<FitnessRepository>().profile;
  if (profile.permissionsComplete) {
    await di.getIt<AuraActivityJobs>().start();
  }

  final router = app_routes.AppRoutes.createRouter();
  runApp(App(router: router));
}
