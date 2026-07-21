import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../jobs/aura_activity_jobs.dart';
import '../platform/aura_platform.dart';
import 'di/injection.dart' as di;
import 'theme/aura_theme.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MasterApp(
      router: widget.router,
      theme: AuraTheme.light(),
      darkTheme: AuraTheme.light(),
      themeMode: ThemeMode.light,
      shouldSetOrientation: true,
      preferredOrientations: const [
        DeviceOrientation.portraitUp,
      ],
      showPerformanceOverlay: false,
      textDirection: TextDirection.ltr,
      fontScale: 1.0,
      useBottomSafeArea: false,
      devModeGrid: false,
      devModeSpacer: false,
    );
  }
}
