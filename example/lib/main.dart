import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'app/app.dart';
import 'app/di/injection.dart' as di;
import 'app/routes.dart' as app_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize MasterApp components FIRST (especially hydrated storage)
  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
  );

  // Configure dependency injection AFTER storage is initialized
  di.configureDependencies();

  // Create router
  final router = app_routes.AppRoutes.createRouter();

  runApp(App(router: router));
}
