import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/src/models/info_models.dart';
import 'package:masterfabric_core/src/views/account/account_view.dart';
import 'package:masterfabric_core/src/views/auth/auth_view.dart';
import 'package:masterfabric_core/src/views/counter/counter_view.dart';
import 'package:masterfabric_core/src/views/empty_view/empty_view.dart';
import 'package:masterfabric_core/src/views/error_handling/error_handling_view.dart';
import 'package:masterfabric_core/src/views/image_detail/image_detail_view.dart';
import 'package:masterfabric_core/src/views/info_bottom_sheet/info_bottom_sheet_view.dart';
import 'package:masterfabric_core/src/views/loading/loading_view.dart';
import 'package:masterfabric_core/src/views/onboarding/onboarding_view.dart';
import 'package:masterfabric_core/src/views/permissions/permissions_view.dart';
import 'package:masterfabric_core/src/views/search/search_view.dart';
import 'package:masterfabric_core/src/views/splash/splash_view.dart';
import 'package:permission_handler/permission_handler.dart';

/// Route definitions for the app
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String account = '/account';
  static const String permissions = '/permissions';
  static const String search = '/search';
  static const String imageDetail = '/image-detail';
  static const String empty = '/empty';
  static const String error = '/error';
  static const String loading = '/loading';
  static const String info = '/info';
  /// Official [MasterView] (Bloc) sample.
  static const String counter = '/counter';

  /// Create GoRouter configuration
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => SplashView(
            goRoute: (path) => context.go(path),
          ),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go(account),
                    child: const Text('Account'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go(search),
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => OnboardingView(
            config: null,
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: auth,
          builder: (context, state) => AuthView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: account,
          builder: (context, state) => AccountView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: permissions,
          builder: (context, state) => PermissionsView(
            permissions: state.uri.queryParameters['permissions']
                    ?.split(',')
                    .map((p) => Permission.values.firstWhere(
                          (perm) =>
                              perm.toString() == p ||
                              perm.toString().endsWith('.$p'),
                          orElse: () => Permission.camera,
                        ))
                    .toList() ??
                const [Permission.camera, Permission.notification],
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: search,
          builder: (context, state) => SearchView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: imageDetail,
          builder: (context, state) => ImageDetailView(
            imageUrl: state.uri.queryParameters['url'] ?? '',
            title: state.uri.queryParameters['title'],
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: empty,
          builder: (context, state) => EmptyView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: error,
          builder: (context, state) => ErrorHandlingView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        GoRoute(
          path: loading,
          builder: (context, state) => LoadingView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
            initialMessage: state.uri.queryParameters['message'],
          ),
        ),
        GoRoute(
          path: info,
          builder: (context, state) => InfoBottomSheetView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
            infoModel: InfoModel(
              title: state.uri.queryParameters['title'] ?? 'Info',
              description: state.uri.queryParameters['description'],
            ),
          ),
        ),
        GoRoute(
          path: counter,
          builder: (context, state) => CounterView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
      ],
    );
  }
}
