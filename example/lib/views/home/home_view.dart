import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../../app/routes.dart' as app_routes;
import '../../theme/theme_helper.dart';
import '../../src/resources/resources.g.dart' as example_resources;
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

/// Home View - MasterFabric Core Showcase
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
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.settings,
                    size: 18,
                  ),
                  onPressed: () => goRoute(app_routes.AppRoutes.settings),
                ),
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.refreshCw,
                    size: 18,
                  ),
                  onPressed: () => viewModel.loadData(),
                ),
              ],
              centerTitle: true,
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
    // Check if home view is visible
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
            TextButton(
              onPressed: () => context.themeCubit.toggleViewVisibility('home', true),
              child: Text(example_resources.resources.home.show_home_view),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Card
        _buildHeroCard(context),
        const SizedBox(height: 20),

        // Quick Navigation
        _buildSectionTitle(context, example_resources.resources.home.quick_navigation),
        const SizedBox(height: 8),
        _buildNavigationCard(context),
        const SizedBox(height: 20),

        // Architecture Overview
        _buildSectionTitle(context, example_resources.resources.home.architecture),
        const SizedBox(height: 8),
        _buildArchitectureCard(context),
        const SizedBox(height: 20),

        // Core Features
        _buildSectionTitle(context, example_resources.resources.home.core_features),
        const SizedBox(height: 8),
        _buildFeaturesCard(context),
        const SizedBox(height: 20),

        // Helper Modules
        _buildSectionTitle(context, example_resources.resources.home.helper_modules),
        const SizedBox(height: 8),
        _buildHelpersCard(context),
        const SizedBox(height: 20),

        // Getting Started
        _buildSectionTitle(context, example_resources.resources.home.getting_started),
        const SizedBox(height: 8),
        _buildGettingStartedCard(context),
        const SizedBox(height: 20),

        // Footer
        _buildFooter(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.accentColor.withValues(alpha: 0.15),
            context.accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ConditionalIcon(
                  context: context,
                  icon: LucideIcons.box,
                  size: 24,
                  color: context.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example_resources.resources.home.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'v0.0.13',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                          fontSize: context.scaledFontSize(11),
                          color: context.successColor,
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
            style: TextStyle(
              fontSize: context.scaledFontSize(13),
              color: Theme.of(context).colorScheme.secondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          _buildAuthorInfo(context),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => UrlLauncherHelper.launchUrl('https://github.com/gurkanfikretgunak'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: context.borderColor),
                ),
                child: Center(
                  child: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.github,
                    size: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gürkan Fikret Günak',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '@gurkanfikretgunak',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                        fontSize: context.scaledFontSize(11),
                        color: context.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              ConditionalIcon(
                context: context,
                icon: LucideIcons.externalLink,
                size: 14,
                color: context.textMutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.textMutedColor,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildNavigationCard(BuildContext context) {
    final items = <Widget>[];
    
    if (context.isViewVisible('products')) {
      items.add(_buildNavItem(
        context,
        example_resources.resources.home.products,
        example_resources.resources.home.products_subtitle,
        LucideIcons.shoppingBag,
        app_routes.AppRoutes.products,
      ));
      items.add(const Divider(height: 1));
    }
    
    if (context.isViewVisible('profile')) {
      items.add(_buildNavItem(
        context,
        example_resources.resources.home.profile,
        example_resources.resources.home.profile_subtitle,
        LucideIcons.user,
        app_routes.AppRoutes.profile,
      ));
      items.add(const Divider(height: 1));
    }
    
    if (context.isViewVisible('helpersHub')) {
      items.add(_buildNavItem(
        context,
        example_resources.resources.home.helper_cases,
        example_resources.resources.home.helper_cases_subtitle,
        LucideIcons.puzzle,
        app_routes.AppRoutes.helpersHub,
      ));
    }
    
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Remove last divider if exists
    if (items.isNotEmpty && items.last is Divider) {
      items.removeLast();
    }
    
    return Container(
      decoration: context.cardDecoration,
      child: Column(children: items),
    );
  }

  Widget _buildArchitectureCard(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArchItem(
            context,
            example_resources.resources.home.masterview_cubit,
            example_resources.resources.home.masterview_cubit_desc,
            LucideIcons.layers,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            example_resources.resources.home.base_viewmodel_cubit,
            example_resources.resources.home.base_viewmodel_cubit_desc,
            LucideIcons.gitBranch,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            example_resources.resources.home.injectable_di,
            example_resources.resources.home.injectable_di_desc,
            LucideIcons.plug,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            example_resources.resources.home.gorouter_navigation,
            example_resources.resources.home.gorouter_navigation_desc,
            LucideIcons.navigation,
          ),
        ],
      ),
    );
  }

  Widget _buildArchItem(
      BuildContext context, String title, String desc, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ConditionalIcon(
            context: context,
            icon: icon,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: context.scaledFontSize(12),
                  color: context.textMutedColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesCard(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: [
          _buildFeatureRow(context, example_resources.resources.home.state_management,
              example_resources.resources.home.state_management_desc, LucideIcons.database),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.prebuilt_views,
              example_resources.resources.home.prebuilt_views_desc, LucideIcons.layoutGrid),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.storage_solutions,
              example_resources.resources.home.storage_solutions_desc, LucideIcons.hardDrive),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.theme_system,
              example_resources.resources.home.theme_system_desc, LucideIcons.palette),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.localization,
              example_resources.resources.home.localization_desc, LucideIcons.globe),
        ],
      ),
    );
  }

  Widget _buildHelpersCard(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: [
          _buildFeatureRow(context, example_resources.resources.home.push_notifications,
              example_resources.resources.home.push_notifications_desc, LucideIcons.bell),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.webviewer,
              example_resources.resources.home.webviewer_desc, LucideIcons.globe),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.svg_helper,
              example_resources.resources.home.svg_helper_desc, LucideIcons.image),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.force_update,
              example_resources.resources.home.force_update_desc, LucideIcons.download),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.skeleton_loading,
              example_resources.resources.home.skeleton_loading_desc, LucideIcons.loader),
          const Divider(height: 1),
          _buildFeatureRow(context, example_resources.resources.home.utilities,
              example_resources.resources.home.utilities_desc, LucideIcons.wrench),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
      BuildContext context, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          ConditionalIcon(
            context: context,
            icon: icon,
            size: 16,
            color: context.successColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  desc,
                  style: TextStyle(fontSize: context.scaledFontSize(11), color: context.textMutedColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGettingStartedCard(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeStep(
            context,
            '1',
            example_resources.resources.home.add_dependency,
            'masterfabric_core: ^0.0.13',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '2',
            example_resources.resources.home.initialize_main,
            'await MasterApp.runBefore(...)',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '3',
            example_resources.resources.home.create_views,
            'class MyView extends MasterViewCubit<MyCubit, MyState>',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '4',
            example_resources.resources.home.configure_routes,
            'GoRouter(routes: [...])',
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep(
      BuildContext context, String step, String title, String code) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: context.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                fontSize: context.scaledFontSize(12),
                fontWeight: FontWeight.bold,
                color: context.accentColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: context.scaledFontSize(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: context.codeBlockDecoration,
                child: Text(
                  code,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: context.scaledFontSize(11)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String subtitle,
      IconData icon, String route) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => super.goRoute(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ConditionalIcon(
                  context: context,
                  icon: icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      subtitle,
                      style:
                          TextStyle(fontSize: context.scaledFontSize(11), color: context.textMutedColor),
                    ),
                  ],
                ),
              ),
              ConditionalIcon(
                context: context,
                icon: LucideIcons.chevronRight,
                size: 16,
                color: context.textMutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConditionalIcon(
                context: context,
                icon: LucideIcons.heart,
                size: 14,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 6),
              Text(
                example_resources.resources.home.built_with,
                style: TextStyle(
                  fontSize: context.scaledFontSize(12),
                  color: context.textMutedColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            example_resources.resources.home.flutter_framework,
            style: TextStyle(
              fontSize: context.scaledFontSize(11),
              color: context.textMutedColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
