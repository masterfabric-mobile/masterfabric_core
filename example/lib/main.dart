import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'app/app.dart';
import 'app/di/injection.dart' as di;
import 'app/routes.dart' as app_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependency injection
  di.configureDependencies();

  // Initialize MasterApp components
  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
  );

  // Create router
  final router = app_routes.AppRoutes.createRouter();

  runApp(App(router: router));
}
