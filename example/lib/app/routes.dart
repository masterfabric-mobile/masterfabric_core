import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes, PermissionsView;

// Views - organized by feature following lib/src/views pattern
import 'package:masterfabric_core_example/views/home/home_view.dart';
import 'package:masterfabric_core_example/views/products/products_view.dart';
import 'package:masterfabric_core_example/views/profile/profile_view.dart';
import 'package:masterfabric_core_example/views/settings/settings_view.dart';
import 'package:masterfabric_core_example/views/helpers/helpers_hub_view.dart';
import 'package:masterfabric_core_example/views/helpers/config/config_view.dart';
import 'package:masterfabric_core_example/views/helpers/datetime/datetime_view.dart';
import 'package:masterfabric_core_example/views/helpers/device_info/device_info_view.dart';
import 'package:masterfabric_core_example/views/helpers/download/download_view.dart';
import 'package:masterfabric_core_example/views/helpers/force_update/force_update_view.dart';
import 'package:masterfabric_core_example/views/helpers/package_info/package_info_view.dart';
import 'package:masterfabric_core_example/views/helpers/permissions/permissions_view.dart';
import 'package:masterfabric_core_example/views/helpers/push_notification/push_notification_view.dart';
import 'package:masterfabric_core_example/views/helpers/share/share_view.dart';
import 'package:masterfabric_core_example/views/helpers/skeleton/skeleton_view.dart';
import 'package:masterfabric_core_example/views/helpers/storage/storage_view.dart';
import 'package:masterfabric_core_example/views/helpers/storage/hive_ce/hive_ce_storage_view.dart';
import 'package:masterfabric_core_example/views/helpers/svg/svg_view.dart';
import 'package:masterfabric_core_example/views/helpers/url_launcher/url_launcher_view.dart';
import 'package:masterfabric_core_example/views/helpers/network_info/network_info_view.dart';
import 'package:masterfabric_core_example/views/helpers/web_viewer/web_viewer_cases_view.dart';

/// Application routes
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String products = '/products';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String helpersHub = '/helpers';
  static const String deviceInfoCases = '/helpers/device-info';
  static const String storageCases = '/helpers/storage';
  static const String datetimeCases = '/helpers/datetime';
  static const String urlLauncherCases = '/helpers/url-launcher';
  static const String permissionsCases = '/helpers/permissions';
  static const String shareCases = '/helpers/share';
  static const String downloadCases = '/helpers/download';
  static const String configCases = '/helpers/config';
  static const String packageInfoCases = '/helpers/package-info';
  static const String hiveCeStorageCases = '/helpers/storage/hivece';
  static const String svgCases = '/helpers/svg';
  static const String webViewerCases = '/helpers/web-viewer';
  static const String pushNotificationCases = '/helpers/push-notification';
  static const String forceUpdateCases = '/helpers/force-update';
  static const String skeletonCases = '/helpers/skeleton';
  static const String networkInfoCases = '/helpers/network-info';

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
        
        // Settings (custom view)
        GoRoute(
          path: settings,
          builder: (context, state) => SettingView(
            goRoute: (path) => context.push(path),
            arguments: state.extra as Map<String, dynamic>? ?? {'view': 'settings'},
          ),
        ),
        
        // Helpers Hub
        GoRoute(
          path: helpersHub,
          builder: (context, state) => HelpersHubView(
            goRoute: (path) => context.push(path),
          ),
        ),
        
        // Helper Cases - use push() so they can be popped
        GoRoute(
          path: deviceInfoCases,
          builder: (context, state) => DeviceInfoView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: storageCases,
          builder: (context, state) => StorageView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: datetimeCases,
          builder: (context, state) => DateTimeView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: urlLauncherCases,
          builder: (context, state) => UrlLauncherView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: permissionsCases,
          builder: (context, state) => PermissionsView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: shareCases,
          builder: (context, state) => ShareView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: downloadCases,
          builder: (context, state) => DownloadView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: configCases,
          builder: (context, state) => ConfigView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: packageInfoCases,
          builder: (context, state) => PackageInfoView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: hiveCeStorageCases,
          builder: (context, state) => HiveCeStorageView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: svgCases,
          builder: (context, state) => SvgView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: webViewerCases,
          builder: (context, state) => WebViewerCasesView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: pushNotificationCases,
          builder: (context, state) => PushNotificationView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: forceUpdateCases,
          builder: (context, state) => ForceUpdateView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: skeletonCases,
          builder: (context, state) => SkeletonView(
            goRoute: (path) => context.push(path),
          ),
        ),
        GoRoute(
          path: networkInfoCases,
          builder: (context, state) => NetworkInfoView(
            goRoute: (path) => context.push(path),
          ),
        ),
      ],
    );
  }
}

