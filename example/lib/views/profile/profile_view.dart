import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../app/routes.dart' as app_routes;
import '../../theme/app_theme.dart';
import '../../theme/theme_helper.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

/// Profile View - Minimalist design
class ProfileView extends MasterViewCubit<ProfileCubit, ProfileState> {
  ProfileView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Profile'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                        size: 18,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
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
                  onPressed: () => viewModel.loadProfile(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      ProfileCubit viewModel, BuildContext context) async {
    await viewModel.loadProfile();
  }

  @override
  Widget viewContent(
      BuildContext context, ProfileCubit viewModel, ProfileState state) {
    // Check if profile view is visible
    if (!context.isViewVisible('profile')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile view is hidden',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.themeCubit.toggleViewVisibility('profile', true),
              child: const Text('Show Profile View'),
            ),
          ],
        ),
      );
    }

    if (state.isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User info
            Container(
              decoration: context.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        state.userName?[0].toUpperCase() ?? 'U',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(state.userName ?? 'User',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(state.email ?? '-',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')
                          .copyWith(fontSize: 11, color: context.textMutedColor)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Device info
            Text('Device', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              decoration: context.cardDecoration,
              child: Column(
                children: [
                  _infoRow(context, 'platform', state.platform),
                  const Divider(),
                  _infoRow(context, 'device_id', state.deviceId),
                  const Divider(),
                  _infoRow(context, 'manufacturer', state.manufacturer),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Text('Actions', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              decoration: context.cardDecoration,
              child: Column(
                children: [
                  _actionRow(context, 'Sign Out', LucideIcons.logOut,
                      () => viewModel.signOut()),
                  const Divider(),
                  _actionRow(context, 'Refresh', LucideIcons.refreshCw,
                      () => viewModel.loadProfile()),
                ],
              ),
            ),
          ],
        );
  }

  Widget _infoRow(BuildContext context, String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(key,
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
          ),
          Expanded(
            child: Text(value ?? '-', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _actionRow(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ConditionalIcon(
                context: context,
                icon: icon,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      Text(title, style: Theme.of(context).textTheme.titleSmall)),
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
    );
  }

}
