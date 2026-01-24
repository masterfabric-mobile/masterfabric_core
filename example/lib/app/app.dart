import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../theme/theme_builder.dart';
import '../views/settings/cubit/theme_cubit.dart';
import '../views/settings/cubit/theme_state.dart';
import '../src/resources/resources.g.dart' as example_resources;
import 'di/injection.dart' as di;

/// Main application widget
class App extends StatefulWidget {
  final GoRouter router;

  const App({
    super.key,
    required this.router,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeCubit _themeCubit;
  StreamSubscription<ThemeState>? _themeSubscription;
  ThemeState _currentThemeState = const ThemeState();

  @override
  void initState() {
    super.initState();
    _themeCubit = di.getIt<ThemeCubit>();
    _currentThemeState = _themeCubit.state;
    
    // Listen to theme changes
    _themeSubscription = _themeCubit.stream.listen((themeState) {
      if (mounted) {
        setState(() {
          _currentThemeState = themeState;
        });
      }
    });
  }

  @override
  void dispose() {
    _themeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return example_resources.TranslationProvider(
      child: Theme(
        data: ThemeBuilder.buildTheme(_currentThemeState),
        child: MasterApp(
          router: widget.router,
          shouldSetOrientation: true,
          preferredOrientations: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          showPerformanceOverlay: false,
          textDirection: TextDirection.ltr,
          fontScale: _currentThemeState.fontScale,
        ),
      ),
    );
  }
}
