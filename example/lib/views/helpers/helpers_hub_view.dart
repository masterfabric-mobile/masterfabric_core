import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/routes.dart' as app_routes;
import '../../widgets/platform_scaffold.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_helper.dart';

/// Helpers Hub View - Minimalist developer-friendly design
class HelpersHubView extends StatelessWidget {
  const HelpersHubView({
    super.key,
    required this.goRoute,
  });

  final Function(String) goRoute;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: AppBar(
        title: const Text('Helpers'),
        leading: GoRouter.of(context).canPop()
            ? IconButton(
                icon: ConditionalIcon(
                  context: context,
                  icon: LucideIcons.arrowLeft,
                ),
                onPressed: () => GoRouter.of(context).pop(),
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Core Utilities',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _buildHelperList(context),
        ],
      ),
    );
  }

  Widget _buildHelperList(BuildContext context) {
    final helpers = [
      _Helper('Device Info', 'device_info_plus', LucideIcons.smartphone,
          app_routes.AppRoutes.deviceInfoCases),
      _Helper('Local Storage', 'shared_preferences', LucideIcons.database,
          app_routes.AppRoutes.storageCases),
      _Helper('HiveCE', 'hive_ce', LucideIcons.hardDrive,
          app_routes.AppRoutes.hiveCeStorageCases),
      _Helper('Date & Time', 'intl', LucideIcons.calendar,
          app_routes.AppRoutes.datetimeCases),
      _Helper('URL Launcher', 'url_launcher', LucideIcons.externalLink,
          app_routes.AppRoutes.urlLauncherCases),
      _Helper('Permissions', 'permission_handler', LucideIcons.shield,
          app_routes.AppRoutes.permissionsCases),
      _Helper('Share', 'share_plus', LucideIcons.share2,
          app_routes.AppRoutes.shareCases),
      _Helper('File Download', 'dio', LucideIcons.download,
          app_routes.AppRoutes.downloadCases),
      _Helper('App Config', 'json', LucideIcons.settings,
          app_routes.AppRoutes.configCases),
      _Helper('Package Info', 'package_info_plus', LucideIcons.package,
          app_routes.AppRoutes.packageInfoCases),
      _Helper('SVG Helper', 'flutter_svg', LucideIcons.image,
          app_routes.AppRoutes.svgCases),
      _Helper('Web Viewer', 'flutter_html + inappwebview', LucideIcons.globe,
          app_routes.AppRoutes.webViewerCases),
      _Helper('Push Notifications', 'onesignal + firebase', LucideIcons.bell,
          app_routes.AppRoutes.pushNotificationCases),
      _Helper('Force Update', 'version check + store redirect', LucideIcons.download,
          app_routes.AppRoutes.forceUpdateCases),
      _Helper('Skeleton Loading', 'shimmer + pulse + wave', LucideIcons.loader,
          app_routes.AppRoutes.skeletonCases),
    ];

    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: helpers.asMap().entries.map((entry) {
          final index = entry.key;
          final helper = entry.value;
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => goRoute(helper.route),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        ConditionalIcon(
                          context: context,
                          icon: helper.icon,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(helper.title,
                                  style: Theme.of(context).textTheme.titleSmall),
                              Text(helper.pkg,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                                      fontSize: 10, color: context.textMutedColor)),
                            ],
                          ),
                        ),
                        ConditionalIcon(
                          context: context,
                          icon: LucideIcons.chevronRight,
                          size: 14,
                          color: context.textMutedColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (index < helpers.length - 1) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _Helper {
  final String title;
  final String pkg;
  final IconData icon;
  final String route;

  _Helper(this.title, this.pkg, this.icon, this.route);
}
