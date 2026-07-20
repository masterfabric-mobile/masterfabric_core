import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../../app/routes.dart' as app_routes;
import '../../theme/app_theme.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/example_ui.dart';
import '../../src/resources/resources.g.dart' as example_resources;
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

/// Home — MasterFabric Core showcase (modern layout).
class HomeView extends MasterViewCubit<HomeCubit, HomeState> {
  HomeView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.home.title),
              actions: [
                IconButton(
                  tooltip: 'Settings',
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.settings,
                    size: 20,
                  ),
                  onPressed: () => goRoute(app_routes.AppRoutes.settings),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      HomeCubit viewModel, BuildContext context) async {
    await viewModel.loadData();
  }

  @override
  Widget viewContent(
      BuildContext context, HomeCubit viewModel, HomeState state) {
    if (!context.isViewVisible('home')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              example_resources.resources.home.home_view_hidden,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.themeCubit.toggleViewVisibility('home', true),
              child: Text(example_resources.resources.home.show_home_view),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _buildHero(context),
        const SizedBox(height: 28),
        ExampleUi.sectionLabel(
          context,
          example_resources.resources.home.quick_navigation,
        ),
        const SizedBox(height: 12),
        _buildQuickNavGrid(context),
        const SizedBox(height: 28),
        ExampleUi.sectionLabel(context, 'Core demos'),
        const SizedBox(height: 12),
        _buildCoreDemos(context),
        const SizedBox(height: 28),
        ExampleUi.sectionLabel(
          context,
          example_resources.resources.home.architecture,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(context, [
          (
            LucideIcons.layers,
            example_resources.resources.home.masterview_cubit,
            example_resources.resources.home.masterview_cubit_desc
          ),
          (
            LucideIcons.gitBranch,
            example_resources.resources.home.base_viewmodel_cubit,
            example_resources.resources.home.base_viewmodel_cubit_desc
          ),
          (
            LucideIcons.plug,
            example_resources.resources.home.injectable_di,
            example_resources.resources.home.injectable_di_desc
          ),
          (
            LucideIcons.navigation,
            example_resources.resources.home.gorouter_navigation,
            example_resources.resources.home.gorouter_navigation_desc
          ),
        ]),
        const SizedBox(height: 28),
        ExampleUi.sectionLabel(
          context,
          example_resources.resources.home.getting_started,
        ),
        const SizedBox(height: 12),
        _buildGettingStarted(context),
        const SizedBox(height: 28),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    final accent = context.accentColor;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            accent.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.surface,
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExampleUi.iconBadge(context, icon: LucideIcons.boxes),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'masterfabric_core',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'v2.0.0 · Flutter 3.44',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            example_resources.resources.home.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.textMutedColor,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, 'BLoC / Cubit'),
              _chip(context, 'GoRouter'),
              _chip(context, 'Secure storage'),
              _chip(context, 'Helpers'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label) {
    return Chip(label: Text(label));
  }

  Widget _buildQuickNavGrid(BuildContext context) {
    final tiles = <Widget>[];

    if (context.isViewVisible('products')) {
      tiles.add(ExampleUi.navTile(
        context,
        title: example_resources.resources.home.products,
        subtitle: example_resources.resources.home.products_subtitle,
        icon: LucideIcons.shoppingBag,
        onTap: () => goRoute(app_routes.AppRoutes.products),
      ));
    }
    if (context.isViewVisible('profile')) {
      tiles.add(ExampleUi.navTile(
        context,
        title: example_resources.resources.home.profile,
        subtitle: example_resources.resources.home.profile_subtitle,
        icon: LucideIcons.user,
        onTap: () => goRoute(app_routes.AppRoutes.profile),
      ));
    }
    if (context.isViewVisible('helpersHub')) {
      tiles.add(ExampleUi.navTile(
        context,
        title: example_resources.resources.home.helper_cases,
        subtitle: example_resources.resources.home.helper_cases_subtitle,
        icon: LucideIcons.puzzle,
        onTap: () => goRoute(app_routes.AppRoutes.helpersHub),
      ));
    }
    if (context.isViewVisible('settings')) {
      tiles.add(ExampleUi.navTile(
        context,
        title: example_resources.resources.settings.title,
        subtitle: 'Theme, language & visibility',
        icon: LucideIcons.slidersHorizontal,
        onTap: () => goRoute(app_routes.AppRoutes.settings),
      ));
    }

    if (tiles.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: tiles,
    );
  }

  Widget _buildCoreDemos(BuildContext context) {
    final demos = [
      (
        'Auth',
        'Demo sign-in / sign-up',
        LucideIcons.lock,
        app_routes.AppRoutes.auth
      ),
      (
        'Account',
        'Account sample screen',
        LucideIcons.circleUser,
        app_routes.AppRoutes.account
      ),
      (
        'Search',
        'Pluggable search provider',
        LucideIcons.search,
        app_routes.AppRoutes.search
      ),
      (
        'Permissions',
        'Core permissions view',
        LucideIcons.shield,
        app_routes.AppRoutes.corePermissions
      ),
      (
        'Empty',
        'Empty state scaffold',
        LucideIcons.inbox,
        app_routes.AppRoutes.empty
      ),
      (
        'Error',
        'Error handling view',
        LucideIcons.circleAlert,
        app_routes.AppRoutes.error
      ),
      (
        'Loading',
        'Loading state view',
        LucideIcons.loader,
        app_routes.AppRoutes.loading
      ),
      (
        'Info',
        'Info bottom sheet',
        LucideIcons.info,
        app_routes.AppRoutes.info
      ),
      (
        'Onboarding',
        'Onboarding flow',
        LucideIcons.waypoints,
        app_routes.AppRoutes.onboarding
      ),
    ];

    return Container(
      decoration: context.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < demos.length; i++) ...[
            ExampleUi.listRow(
              context,
              title: demos[i].$1,
              subtitle: demos[i].$2,
              icon: demos[i].$3,
              showChevron: true,
              onTap: () => goRoute(demos[i].$4),
            ),
            if (i < demos.length - 1)
              Divider(height: 1, color: context.borderColor),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    List<(IconData, String, String)> items,
  ) {
    return Container(
      decoration: context.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ExampleUi.listRow(
              context,
              title: items[i].$2,
              subtitle: items[i].$3,
              icon: items[i].$1,
            ),
            if (i < items.length - 1)
              Divider(height: 1, color: context.borderColor),
          ],
        ],
      ),
    );
  }

  Widget _buildGettingStarted(BuildContext context) {
    final steps = [
      (
        '1',
        example_resources.resources.home.add_dependency,
        'masterfabric_core: ^2.0.0'
      ),
      (
        '2',
        example_resources.resources.home.initialize_main,
        'await MasterApp.runBefore(...)'
      ),
      (
        '3',
        example_resources.resources.home.create_views,
        'class MyView extends MasterViewCubit<...>'
      ),
      (
        '4',
        example_resources.resources.home.configure_routes,
        'GoRouter(routes: [...])'
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: context.cardDecoration,
      child: Column(
        children: [
          for (final step in steps) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    step.$1,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: context.accentColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.$2,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: context.codeBlockDecoration,
                        child: Text(
                          step.$3,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (step != steps.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          example_resources.resources.home.built_with,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.textMutedColor,
              ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => UrlLauncherHelper.launchUrl(
            'https://academy.masterfabric.co',
          ),
          icon: const Icon(LucideIcons.graduationCap, size: 18),
          label: const Text('MasterFabric Academy'),
        ),
      ],
    );
  }
}
