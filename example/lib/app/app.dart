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
    _applySystemUi(_currentThemeState);

    _themeSubscription = _themeCubit.stream.listen((themeState) {
      if (mounted) {
        setState(() {
          _currentThemeState = themeState;
        });
        _applySystemUi(themeState);
      }
    });
  }

  void _applySystemUi(ThemeState state) {
    final isDark = state.brightness == Brightness.dark;
    final overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );
    SystemChrome.setSystemUIOverlayStyle(overlay);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    _themeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeBuilder.buildTheme(_currentThemeState);
    final darkTheme = ThemeBuilder.buildTheme(
      _currentThemeState.copyWith(brightness: Brightness.dark),
    );

    return example_resources.TranslationProvider(
      child: MasterApp(
        router: widget.router,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: _currentThemeState.brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        shouldSetOrientation: true,
        preferredOrientations: const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        showPerformanceOverlay: false,
        textDirection: TextDirection.ltr,
        fontScale: _currentThemeState.fontScale,
        useBottomSafeArea: false,
        devModeGrid: false,
        devModeSpacer: false,
      ),
    );
  }
}
