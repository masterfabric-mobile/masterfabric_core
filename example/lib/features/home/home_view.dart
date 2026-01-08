import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;
import 'package:masterfabric_core_example/app/routes.dart' as app_routes;
import 'package:masterfabric_core_example/features/home/cubit/home_cubit.dart';
import 'package:masterfabric_core_example/features/home/cubit/home_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

/// Home View - Minimalist design
class HomeView extends MasterViewCubit<HomeCubit, HomeState> {
  HomeView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('MasterFabric'),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  onPressed: () => viewModel.loadData(),
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
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: viewModel,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Error',
                    style: const TextStyle(color: AppTheme.error)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => viewModel.loadData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Quick nav
            Text('Navigate',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Container(
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  _buildNavItem(context, 'Products', LucideIcons.shoppingBag,
                      app_routes.AppRoutes.products),
                  const Divider(),
                  _buildNavItem(context, 'Profile', LucideIcons.user,
                      app_routes.AppRoutes.profile),
                  const Divider(),
                  _buildNavItem(
                      context, 'Auth', LucideIcons.logIn, app_routes.AppRoutes.auth),
                  const Divider(),
                  _buildNavItem(context, 'Helpers', LucideIcons.puzzle,
                      app_routes.AppRoutes.helpersHub),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features
            Text('Package Features',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Container(
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  _buildFeature(context, 'State Management',
                      'Cubit pattern with MasterViewCubit'),
                  const Divider(),
                  _buildFeature(context, 'Navigation',
                      'GoRouter integration'),
                  const Divider(),
                  _buildFeature(context, 'Helpers',
                      'Storage, DeviceInfo, Permissions'),
                  const Divider(),
                  _buildFeature(context, 'Pre-built Views',
                      'Splash, Auth, Onboarding'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavItem(
      BuildContext context, String title, IconData icon, String route) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => super.goRoute(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleSmall),
              ),
              const Icon(LucideIcons.chevronRight,
                  size: 14, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.check, size: 14, color: AppTheme.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
