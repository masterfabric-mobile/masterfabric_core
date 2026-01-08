import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/profile/cubit/profile_cubit.dart';
import 'package:masterfabric_core_example/features/profile/cubit/profile_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

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
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.settings, size: 18),
                  onPressed: () => viewModel.showSettings(),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
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
    return BlocBuilder<ProfileCubit, ProfileState>(
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

        if (state.showSettingsDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSettings(context, viewModel, state);
          });
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User info
            Container(
              decoration: AppTheme.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.bg,
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
                      style: AppTheme.mono
                          .copyWith(fontSize: 11, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Device info
            Text('Device', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              decoration: AppTheme.cardDecoration,
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
              decoration: AppTheme.cardDecoration,
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
      },
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
                    AppTheme.mono.copyWith(fontSize: 10, color: AppTheme.textMuted)),
          ),
          Expanded(
            child: Text(value ?? '-', style: AppTheme.mono.copyWith(fontSize: 11)),
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
              Icon(icon, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      Text(title, style: Theme.of(context).textTheme.titleSmall)),
              const Icon(LucideIcons.chevronRight,
                  size: 14, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(
      BuildContext context, ProfileCubit viewModel, ProfileState state) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                SwitchListTile(
                  dense: true,
                  title: const Text('Notifications'),
                  value: state.notificationsEnabled,
                  onChanged: (v) {
                    viewModel.toggleNotifications(v);
                    setState(() {});
                  },
                ),
                const Divider(),
                const Text('Theme', style: TextStyle(fontSize: 12)),
                RadioListTile<String>(
                  dense: true,
                  title: const Text('Light'),
                  value: 'light',
                  groupValue: state.themeMode,
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.updateThemeMode(v);
                      setState(() {});
                    }
                  },
                ),
                RadioListTile<String>(
                  dense: true,
                  title: const Text('Dark'),
                  value: 'dark',
                  groupValue: state.themeMode,
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.updateThemeMode(v);
                      setState(() {});
                    }
                  },
                ),
                RadioListTile<String>(
                  dense: true,
                  title: const Text('System'),
                  value: 'system',
                  groupValue: state.themeMode,
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.updateThemeMode(v);
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      viewModel.hideSettings();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) => viewModel.hideSettings());
  }
}
