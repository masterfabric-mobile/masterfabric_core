import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../app/routes.dart' as app_routes;
import '../../theme/theme_helper.dart';
import '../../src/resources/resources.g.dart' as example_resources;
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
          extendBodyBehindAppBar: false,
          extendBody: false,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.profile.title),
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
              example_resources.resources.profile.profile_view_hidden,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.themeCubit.toggleViewVisibility('profile', true),
              child: Text(example_resources.resources.profile.show_profile_view),
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
                        state.userName?[0].toUpperCase() ?? example_resources.resources.common.user[0].toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(state.userName ?? example_resources.resources.common.user,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(state.email ?? '-',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')
                          .copyWith(fontSize: 11, color: context.textMutedColor)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Device info
            Text(example_resources.resources.profile.device, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              decoration: context.cardDecoration,
              child: Column(
                children: [
                  _infoRow(context, example_resources.resources.profile.platform, state.platform),
                  const Divider(),
                  _infoRow(context, example_resources.resources.profile.device_id, state.deviceId),
                  const Divider(),
                  _infoRow(context, example_resources.resources.profile.manufacturer, state.manufacturer),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Text(example_resources.resources.profile.actions, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              decoration: context.cardDecoration,
              child: Column(
                children: [
                  _actionRow(context, example_resources.resources.account.sign_out, LucideIcons.logOut,
                      () => viewModel.signOut()),
                  const Divider(),
                  _actionRow(context, example_resources.resources.common.refresh, LucideIcons.refreshCw,
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
