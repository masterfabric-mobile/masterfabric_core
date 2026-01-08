import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
import 'cubit/push_notification_cubit.dart';
import 'cubit/push_notification_state.dart';

/// Push Notification Demo View
class PushNotificationView
    extends MasterViewCubit<PushNotificationCubit, PushNotificationDemoState> {
  PushNotificationView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Push Notifications'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  onPressed: () => viewModel.refreshTokens(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      PushNotificationCubit viewModel, BuildContext context) async {
    await viewModel.initialize();
  }

  @override
  Widget viewContent(BuildContext context, PushNotificationCubit viewModel,
      PushNotificationDemoState state) {
    return BlocBuilder<PushNotificationCubit, PushNotificationDemoState>(
      bloc: viewModel,
      builder: (context, state) {
        if (state.isLoading && !state.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.errorMessage != null)
              _buildMessageCard(context, state.errorMessage!, isError: true, onDismiss: viewModel.clearMessages),
            if (state.statusMessage != null && state.errorMessage == null)
              _buildMessageCard(context, state.statusMessage!, isError: false, onDismiss: viewModel.clearMessages),
            _buildSectionTitle(context, 'Status'),
            _buildStatusCard(context, state, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Active Providers'),
            _buildProvidersCard(context, state),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Permissions'),
            _buildPermissionsCard(context, state, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Device Tokens'),
            _buildTokensCard(context, state),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Topic Subscriptions'),
            _TopicsCard(state: state, viewModel: viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'User Targeting'),
            _UserIdCard(viewModel: viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Actions'),
            _buildActionsCard(context, viewModel),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _buildMessageCard(BuildContext context, String message, {required bool isError, required VoidCallback onDismiss}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? AppTheme.error.withValues(alpha: 0.1) : AppTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isError ? AppTheme.error.withValues(alpha: 0.3) : AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(isError ? LucideIcons.circleAlert : LucideIcons.circleCheck, size: 16, color: isError ? AppTheme.error : AppTheme.success),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(fontSize: 12, color: isError ? AppTheme.error : AppTheme.success))),
          GestureDetector(onTap: onDismiss, child: Icon(LucideIcons.x, size: 14, color: isError ? AppTheme.error : AppTheme.success)),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, PushNotificationDemoState state, PushNotificationCubit viewModel) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(state.isInitialized ? LucideIcons.circleCheck : LucideIcons.circleAlert, size: 20, color: state.isInitialized ? AppTheme.success : AppTheme.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.isInitialized ? 'Initialized' : 'Not Initialized', style: Theme.of(context).textTheme.titleSmall),
                    Text(state.isInitialized ? '${state.activeProviders.length} provider(s) active' : 'Tap to initialize', style: AppTheme.mono.copyWith(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              if (!state.isInitialized)
                OutlinedButton(
                  onPressed: state.isLoading ? null : viewModel.initialize,
                  child: state.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Initialize'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersCard(BuildContext context, PushNotificationDemoState state) {
    if (!state.isInitialized) return _buildEmptyCard('Initialize to see active providers');
    if (state.activeProviders.isEmpty) return _buildEmptyCard('No providers configured');

    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: state.activeProviders.asMap().entries.map((entry) {
          final index = entry.key;
          final provider = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(_getProviderIcon(provider), size: 16, color: AppTheme.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                          Text(provider.name, style: AppTheme.mono.copyWith(fontSize: 10, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.check, size: 16, color: AppTheme.success),
                  ],
                ),
              ),
              if (index < state.activeProviders.length - 1) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPermissionsCard(BuildContext context, PushNotificationDemoState state, PushNotificationCubit viewModel) {
    if (!state.isInitialized) return _buildEmptyCard('Initialize to check permissions');

    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          ...state.permissionStatuses.entries.map((entry) {
            final provider = entry.key;
            final status = entry.value;
            final isGranted = status == NotificationPermissionStatus.authorized;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(isGranted ? LucideIcons.bell : LucideIcons.bellOff, size: 16, color: isGranted ? AppTheme.success : AppTheme.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                        Text(status.name, style: AppTheme.mono.copyWith(fontSize: 10, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.isLoading ? null : viewModel.requestPermissions,
                icon: const Icon(LucideIcons.shield, size: 16),
                label: const Text('Request Permissions'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokensCard(BuildContext context, PushNotificationDemoState state) {
    if (!state.isInitialized) return _buildEmptyCard('Initialize to see device tokens');

    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: state.deviceTokens.entries.map((entry) {
          final provider = entry.key;
          final token = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(LucideIcons.key, size: 16, color: token != null ? AppTheme.success : AppTheme.textMuted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                      Text(token != null ? '${token.length > 20 ? token.substring(0, 20) : token}...' : 'No token', style: AppTheme.mono.copyWith(fontSize: 10, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                if (token != null)
                  IconButton(
                    icon: const Icon(LucideIcons.copy, size: 14),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: token));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token copied to clipboard')));
                    },
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, PushNotificationCubit viewModel) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: viewModel.optIn, icon: const Icon(LucideIcons.bellRing, size: 16), label: const Text('Opt In'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: viewModel.optOut, icon: const Icon(LucideIcons.bellOff, size: 16), label: const Text('Opt Out'))),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: viewModel.clearAllData,
              icon: const Icon(LucideIcons.trash2, size: 16),
              label: const Text('Clear All Data'),
              style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(message, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted))),
    );
  }

  String _getProviderName(PushNotificationProviderType type) {
    switch (type) {
      case PushNotificationProviderType.onesignal: return 'OneSignal';
      case PushNotificationProviderType.firebase: return 'Firebase';
      case PushNotificationProviderType.custom: return 'Custom';
    }
  }

  IconData _getProviderIcon(PushNotificationProviderType type) {
    switch (type) {
      case PushNotificationProviderType.onesignal: return LucideIcons.signal;
      case PushNotificationProviderType.firebase: return LucideIcons.flame;
      case PushNotificationProviderType.custom: return LucideIcons.puzzle;
    }
  }
}

class _TopicsCard extends StatefulWidget {
  final PushNotificationDemoState state;
  final PushNotificationCubit viewModel;

  const _TopicsCard({required this.state, required this.viewModel});

  @override
  State<_TopicsCard> createState() => _TopicsCardState();
}

class _TopicsCardState extends State<_TopicsCard> {
  final TextEditingController _topicController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _topicController,
                  decoration: const InputDecoration(hintText: 'Enter topic name', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: widget.state.isInitialized && !widget.state.isLoading
                    ? () {
                        widget.viewModel.subscribeToTopic(_topicController.text.trim());
                        _topicController.clear();
                      }
                    : null,
                child: const Text('Subscribe'),
              ),
            ],
          ),
          if (widget.state.subscribedTopics.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.state.subscribedTopics.map((topic) {
                return Chip(label: Text(topic, style: const TextStyle(fontSize: 12)), deleteIcon: const Icon(LucideIcons.x, size: 14), onDeleted: () => widget.viewModel.unsubscribeFromTopic(topic));
              }).toList(),
            ),
          ],
          if (widget.state.subscribedTopics.isEmpty)
            const Padding(padding: EdgeInsets.only(top: 12), child: Text('No topics subscribed', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))),
        ],
      ),
    );
  }
}

class _UserIdCard extends StatefulWidget {
  final PushNotificationCubit viewModel;

  const _UserIdCard({required this.viewModel});

  @override
  State<_UserIdCard> createState() => _UserIdCardState();
}

class _UserIdCardState extends State<_UserIdCard> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(hintText: 'Enter user ID', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  widget.viewModel.setUserId(_userIdController.text.trim());
                  _userIdController.clear();
                },
                child: const Text('Set'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(onPressed: widget.viewModel.removeUserId, icon: const Icon(LucideIcons.logOut, size: 14), label: const Text('Remove User ID (Logout)')),
          ),
        ],
      ),
    );
  }
}
