import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../jobs/aura_activity_jobs.dart';
import '../platform/aura_platform.dart';
import 'di/injection.dart' as di;
import 'theme/aura_theme_config.dart';

class App extends StatefulWidget {
  const App({super.key, required this.router});

  final GoRouter router;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AuraPlatform.listenDeepLinks((route) {
      widget.router.go(route);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      di.getIt<AuraActivityJobs>().reschedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = AuraThemeConfig.themeMode();
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final isDark =
        mode == ThemeMode.dark || (mode == ThemeMode.system && platformDark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return MasterApp(
      router: widget.router,
      theme: AuraThemeConfig.light(),
      darkTheme: AuraThemeConfig.dark(),
      themeMode: mode,
      shouldSetOrientation: true,
      preferredOrientations: const [
        DeviceOrientation.portraitUp,
      ],
      showPerformanceOverlay: false,
      textDirection: TextDirection.ltr,
      fontScale: AuraThemeConfig.fontScale(),
      useBottomSafeArea: false,
      devModeGrid: AuraThemeConfig.devModeGrid(),
      devModeSpacer: AuraThemeConfig.devModeSpacer(),
    );
  }
}
