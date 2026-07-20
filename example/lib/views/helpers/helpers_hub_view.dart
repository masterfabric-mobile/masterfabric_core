import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/routes.dart' as app_routes;
import '../../widgets/platform_scaffold.dart';
import '../../widgets/example_ui.dart';
import '../../theme/theme_helper.dart';
import '../../src/resources/resources.g.dart' as example_resources;

/// Helpers hub — modern searchable-feeling list of utility demos.
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
        title: Text(example_resources.resources.helpers.title),
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            example_resources.resources.helpers.core_utilities,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.textMutedColor,
                ),
          ),
          const SizedBox(height: 16),
          _buildHelperList(context),
        ],
      ),
    );
  }

  Widget _buildHelperList(BuildContext context) {
    final helpers = [
      _Helper(example_resources.resources.helpers.device_info, 'device_info_plus',
          LucideIcons.smartphone, app_routes.AppRoutes.deviceInfoCases),
      _Helper(example_resources.resources.helpers.local_storage, 'shared_preferences',
          LucideIcons.database, app_routes.AppRoutes.storageCases),
      _Helper(example_resources.resources.helpers.hivece, 'hive_ce',
          LucideIcons.hardDrive, app_routes.AppRoutes.hiveCeStorageCases),
      _Helper(example_resources.resources.helpers.date_time, 'intl',
          LucideIcons.calendar, app_routes.AppRoutes.datetimeCases),
      _Helper(example_resources.resources.helpers.url_launcher, 'url_launcher',
          LucideIcons.externalLink, app_routes.AppRoutes.urlLauncherCases),
      _Helper(example_resources.resources.helpers.permissions, 'permission_handler',
          LucideIcons.shield, app_routes.AppRoutes.permissionsCases),
      _Helper(example_resources.resources.helpers.share, 'share_plus',
          LucideIcons.share2, app_routes.AppRoutes.shareCases),
      _Helper(example_resources.resources.helpers.file_download, 'dio',
          LucideIcons.download, app_routes.AppRoutes.downloadCases),
      _Helper(example_resources.resources.helpers.app_config, 'json',
          LucideIcons.settings, app_routes.AppRoutes.configCases),
      _Helper(example_resources.resources.helpers.package_info, 'package_info_plus',
          LucideIcons.package, app_routes.AppRoutes.packageInfoCases),
      _Helper(example_resources.resources.helpers.svg_helper, 'flutter_svg',
          LucideIcons.image, app_routes.AppRoutes.svgCases),
      _Helper(example_resources.resources.helpers.web_viewer, 'flutter_html + inappwebview',
          LucideIcons.globe, app_routes.AppRoutes.webViewerCases),
      _Helper(example_resources.resources.helpers.push_notifications, 'onesignal + firebase',
          LucideIcons.bell, app_routes.AppRoutes.pushNotificationCases),
      _Helper(example_resources.resources.helpers.force_update, 'version check + store redirect',
          LucideIcons.download, app_routes.AppRoutes.forceUpdateCases),
      _Helper(example_resources.resources.helpers.skeleton_loading, 'shimmer + pulse + wave',
          LucideIcons.loader, app_routes.AppRoutes.skeletonCases),
      _Helper('Network Info', 'network_info_plus + connectivity_plus', LucideIcons.wifi,
          app_routes.AppRoutes.networkInfoCases),
    ];

    return Container(
      decoration: context.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: helpers.asMap().entries.map((entry) {
          final index = entry.key;
          final helper = entry.value;
          return Column(
            children: [
              ExampleUi.listRow(
                context,
                title: helper.title,
                subtitle: helper.pkg,
                icon: helper.icon,
                showChevron: true,
                onTap: () => goRoute(helper.route),
              ),
              if (index < helpers.length - 1)
                Divider(height: 1, color: context.borderColor),
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
