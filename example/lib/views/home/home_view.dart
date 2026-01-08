import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../../app/routes.dart' as app_routes;
import '../../theme/app_theme.dart';
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
              title: const Text('MasterFabric Core'),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Card
        _buildHeroCard(context),
        const SizedBox(height: 20),

        // Quick Navigation
        _buildSectionTitle(context, 'Quick Navigation'),
        const SizedBox(height: 8),
        _buildNavigationCard(context),
        const SizedBox(height: 20),

        // Architecture Overview
        _buildSectionTitle(context, 'Architecture'),
        const SizedBox(height: 8),
        _buildArchitectureCard(context),
        const SizedBox(height: 20),

        // Core Features
        _buildSectionTitle(context, 'Core Features'),
        const SizedBox(height: 8),
        _buildFeaturesCard(context),
        const SizedBox(height: 20),

        // Helper Modules
        _buildSectionTitle(context, 'Helper Modules'),
        const SizedBox(height: 8),
        _buildHelpersCard(context),
        const SizedBox(height: 20),

        // Getting Started
        _buildSectionTitle(context, 'Getting Started'),
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
            AppTheme.accent.withValues(alpha: 0.15),
            AppTheme.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.box, size: 24, color: AppTheme.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MasterFabric Core',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'v0.0.11',
                        style: AppTheme.mono.copyWith(
                          fontSize: 11,
                          color: AppTheme.success,
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
            'A comprehensive Flutter framework for building scalable, '
            'maintainable mobile applications with pre-built components, '
            'state management patterns, and utility helpers.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
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
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Center(
                  child: Icon(LucideIcons.github, size: 18, color: AppTheme.textSecondary),
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
                      style: AppTheme.mono.copyWith(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.externalLink,
                size: 14,
                color: AppTheme.textMuted,
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
            color: AppTheme.textMuted,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildNavigationCard(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _buildNavItem(
            context,
            'Products',
            'Sample product list with search',
            LucideIcons.shoppingBag,
            app_routes.AppRoutes.products,
          ),
          const Divider(height: 1),
          _buildNavItem(
            context,
            'Profile',
            'User profile with device info',
            LucideIcons.user,
            app_routes.AppRoutes.profile,
          ),
          const Divider(height: 1),
          _buildNavItem(
            context,
            'Helper Cases',
            'Explore all utility helpers',
            LucideIcons.puzzle,
            app_routes.AppRoutes.helpersHub,
          ),
        ],
      ),
    );
  }

  Widget _buildArchitectureCard(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArchItem(
            context,
            'MasterViewCubit',
            'Base view class with integrated Cubit state management, '
                'lifecycle hooks, and common UI patterns.',
            LucideIcons.layers,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            'BaseViewModelCubit',
            'Extended Cubit with stateChanger pattern for clean '
                'state transitions and business logic separation.',
            LucideIcons.gitBranch,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            'Injectable DI',
            'Automatic dependency injection with GetIt and '
                'injectable annotations for clean service resolution.',
            LucideIcons.plug,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildArchItem(
            context,
            'GoRouter Navigation',
            'Declarative routing with type-safe navigation, '
                'deep linking, and route guards support.',
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
            color: AppTheme.bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppTheme.textSecondary),
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
                  fontSize: 12,
                  color: AppTheme.textMuted,
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
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _buildFeatureRow(context, 'State Management',
              'Cubit, HydratedCubit, BLoC patterns', LucideIcons.database),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Pre-built Views',
              'Splash, Auth, Onboarding, Error, Empty', LucideIcons.layoutGrid),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Storage Solutions',
              'SharedPreferences, HiveCE, Secure Storage', LucideIcons.hardDrive),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Theme System',
              'Light/Dark themes, custom styling', LucideIcons.palette),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Localization',
              'i18n support with slang', LucideIcons.globe),
        ],
      ),
    );
  }

  Widget _buildHelpersCard(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _buildFeatureRow(context, 'Push Notifications',
              'OneSignal & Firebase FCM integration', LucideIcons.bell),
          const Divider(height: 1),
          _buildFeatureRow(context, 'WebViewer',
              'HTML rendering & WebView support', LucideIcons.globe),
          const Divider(height: 1),
          _buildFeatureRow(context, 'SVG Helper',
              'Asset, network, string SVG sources', LucideIcons.image),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Force Update',
              'Version check & store redirect', LucideIcons.download),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Skeleton Loading',
              '10 animation styles for loading states', LucideIcons.loader),
          const Divider(height: 1),
          _buildFeatureRow(context, 'Utilities',
              'DateTime, URL, Share, Download, Permissions', LucideIcons.wrench),
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
          Icon(icon, size: 16, color: AppTheme.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
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
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeStep(
            context,
            '1',
            'Add dependency',
            'masterfabric_core: ^0.0.11',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '2',
            'Initialize in main.dart',
            'await MasterApp.runBefore(...)',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '3',
            'Create views extending MasterViewCubit',
            'class MyView extends MasterViewCubit<MyCubit, MyState>',
          ),
          const SizedBox(height: 12),
          _buildCodeStep(
            context,
            '4',
            'Configure routes with GoRouter',
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
            color: AppTheme.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.accent,
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: AppTheme.codeBlock,
                child: Text(
                  code,
                  style: AppTheme.mono.copyWith(fontSize: 11),
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
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: AppTheme.textSecondary),
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
                          const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight,
                  size: 16, color: AppTheme.textMuted),
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
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.heart, size: 14, color: AppTheme.error),
              const SizedBox(width: 6),
              Text(
                'Built with MasterFabric Core',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Framework for Enterprise Apps',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
