import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, PermissionsView;
import 'package:masterfabric_core_example/features/home/home_view.dart';
import 'package:masterfabric_core_example/features/products/products_view.dart';
import 'package:masterfabric_core_example/features/profile/profile_view.dart';
import 'package:masterfabric_core_example/features/helpers/helpers_hub_view.dart';
import 'package:masterfabric_core_example/features/helpers/device_info/device_info_view.dart';
import 'package:masterfabric_core_example/features/helpers/storage/storage_view.dart';
import 'package:masterfabric_core_example/features/helpers/datetime/datetime_view.dart';
import 'package:masterfabric_core_example/features/helpers/url_launcher/url_launcher_view.dart';
import 'package:masterfabric_core_example/features/helpers/permissions/permissions_view.dart';
import 'package:masterfabric_core_example/features/helpers/share/share_view.dart';
import 'package:masterfabric_core_example/features/helpers/download/download_view.dart';
import 'package:masterfabric_core_example/features/helpers/config/config_view.dart';
import 'package:masterfabric_core_example/features/helpers/package_info/package_info_view.dart';
import 'package:masterfabric_core_example/features/helpers/storage/hive_ce/hive_ce_storage_view.dart';
import 'package:masterfabric_core_example/features/helpers/svg/svg_view.dart';
import 'package:masterfabric_core_example/features/helpers/web_viewer/web_viewer_demo_view.dart';
import 'package:masterfabric_core_example/features/helpers/push_notification/push_notification_view.dart';
import 'package:masterfabric_core_example/features/helpers/force_update/force_update_view.dart';

/// Application routes
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String products = '/products';
  static const String profile = '/profile';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String helpersHub = '/helpers';
  static const String deviceInfoDemo = '/helpers/device-info';
  static const String storageDemo = '/helpers/storage';
  static const String datetimeDemo = '/helpers/datetime';
  static const String urlLauncherDemo = '/helpers/url-launcher';
  static const String permissionsDemo = '/helpers/permissions';
  static const String shareDemo = '/helpers/share';
  static const String downloadDemo = '/helpers/download';
  static const String configDemo = '/helpers/config';
  static const String packageInfoDemo = '/helpers/package-info';
  static const String hiveCeStorageDemo = '/helpers/storage/hivece';
  static const String svgDemo = '/helpers/svg';
  static const String webViewerDemo = '/helpers/web-viewer';
  static const String pushNotificationDemo = '/helpers/push-notification';
  static const String forceUpdateDemo = '/helpers/force-update';

  /// Create GoRouter configuration
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        // Splash Screen (from masterfabric_core)
        GoRoute(
          path: splash,
          builder: (context, state) => SplashView(
            goRoute: (path) => context.go(path),
          ),
        ),
        
        // Onboarding (from masterfabric_core)
        GoRoute(
          path: onboarding,
          builder: (context, state) => OnboardingView(
            config: null, // Configure as needed
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        
        // Auth (from masterfabric_core)
        GoRoute(
          path: auth,
          builder: (context, state) => AuthView(
            goRoute: (path) => context.go(path),
            arguments: state.uri.queryParameters,
          ),
        ),
        
        // Home (custom view)
        GoRoute(
          path: home,
          builder: (context, state) => HomeView(
            goRoute: (path) => context.push(path),
          ),
        ),
        
        // Products (custom view)
        GoRoute(
          path: products,
          builder: (context, state) => ProductsView(
            goRoute: (path) => context.push(path),
          ),
        ),
        
        // Profile (custom view)
        GoRoute(
          path: profile,
          builder: (context, state) => ProfileView(
            goRoute: (path) => context.push(path),
          ),
        ),
        
        // Helpers Hub
        GoRoute(
          path: helpersHub,
          builder: (context, state) => HelpersHubView(
            goRoute: (path) => context.push(path),
          ),
        ),
        
        // Helper Demos - use push() so they can be popped
        GoRoute(
          path: deviceInfoDemo,
          builder: (context, state) => DeviceInfoView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: storageDemo,
          builder: (context, state) => StorageView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: datetimeDemo,
          builder: (context, state) => DateTimeView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: urlLauncherDemo,
          builder: (context, state) => UrlLauncherView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: permissionsDemo,
          builder: (context, state) => PermissionsView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: shareDemo,
          builder: (context, state) => ShareView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: downloadDemo,
          builder: (context, state) => DownloadView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: configDemo,
          builder: (context, state) => ConfigView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: packageInfoDemo,
          builder: (context, state) => PackageInfoView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: hiveCeStorageDemo,
          builder: (context, state) => HiveCeStorageView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: svgDemo,
          builder: (context, state) => SvgView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: webViewerDemo,
          builder: (context, state) => WebViewerDemoView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: pushNotificationDemo,
          builder: (context, state) => PushNotificationView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: forceUpdateDemo,
          builder: (context, state) => ForceUpdateView(
            goRoute: (path) => context.push(path),
          ),
        ),
      ],
    );
  }
}

