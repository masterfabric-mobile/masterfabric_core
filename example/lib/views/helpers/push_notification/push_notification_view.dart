import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
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
              title: Text(example_resources.resources.push_notification.title),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.refreshCw,
                    size: 18,
                  ),
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
            _buildSectionTitle(context, example_resources.resources.push_notification.status),
            _buildStatusCard(context, state, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.active_providers),
            _buildProvidersCard(context, state),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.permissions),
            _buildPermissionsCard(context, state, viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.device_tokens),
            _buildTokensCard(context, state),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.topic_subscriptions),
            _TopicsCard(state: state, viewModel: viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.user_targeting),
            _UserIdCard(viewModel: viewModel),
            const SizedBox(height: 24),
            _buildSectionTitle(context, example_resources.resources.push_notification.actions),
            _buildActionsCard(context, viewModel),
            const SizedBox(height: 32),
          ],
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
        color: isError ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1) : context.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isError ? Theme.of(context).colorScheme.error.withValues(alpha: 0.3) : context.successColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(isError ? LucideIcons.circleAlert : LucideIcons.circleCheck, size: 16, color: isError ? Theme.of(context).colorScheme.error : context.successColor),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(fontSize: 12, color: isError ? Theme.of(context).colorScheme.error : context.successColor))),
          GestureDetector(onTap: onDismiss, child: Icon(LucideIcons.x, size: 14, color: isError ? Theme.of(context).colorScheme.error : context.successColor)),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, PushNotificationDemoState state, PushNotificationCubit viewModel) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(state.isInitialized ? LucideIcons.circleCheck : LucideIcons.circleAlert, size: 20, color: state.isInitialized ? context.successColor : context.warningColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.isInitialized ? example_resources.resources.push_notification.initialized : example_resources.resources.push_notification.not_initialized, style: Theme.of(context).textTheme.titleSmall),
                    Text(state.isInitialized ? '${state.activeProviders.length} ${example_resources.resources.push_notification.providers_active}' : example_resources.resources.push_notification.tap_to_initialize, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                  ],
                ),
              ),
              if (!state.isInitialized)
                OutlinedButton(
                  onPressed: state.isLoading ? null : viewModel.initialize,
                  child: state.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(example_resources.resources.common.initialize),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersCard(BuildContext context, PushNotificationDemoState state) {
    if (!state.isInitialized) return _buildEmptyCard(context, example_resources.resources.push_notification.initialize_to_see_providers);
    if (state.activeProviders.isEmpty) return _buildEmptyCard(context, example_resources.resources.push_notification.no_providers_configured);

    return Container(
      decoration: context.cardDecoration,
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
                    Icon(_getProviderIcon(provider), size: 16, color: context.successColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                          Text(provider.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                        ],
                      ),
                    ),
                    Icon(LucideIcons.check, size: 16, color: context.successColor),
                  ],
                ),
              ),
              if (index < state.activeProviders.length - 1) Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPermissionsCard(BuildContext context, PushNotificationDemoState state, PushNotificationCubit viewModel) {
    if (!state.isInitialized) return _buildEmptyCard(context, example_resources.resources.push_notification.initialize_to_check_permissions);

    return Container(
      decoration: context.cardDecoration,
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
                  Icon(isGranted ? LucideIcons.bell : LucideIcons.bellOff, size: 16, color: isGranted ? context.successColor : context.warningColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                        Text(status.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.isLoading ? null : viewModel.requestPermissions,
                icon: Icon(LucideIcons.shield, size: 16),
                label: Text(example_resources.resources.permissions.request_permissions),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokensCard(BuildContext context, PushNotificationDemoState state) {
    if (!state.isInitialized) return _buildEmptyCard(context, example_resources.resources.push_notification.initialize_to_see_tokens);

    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: state.deviceTokens.entries.map((entry) {
          final provider = entry.key;
          final token = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(LucideIcons.key, size: 16, color: token != null ? context.successColor : context.textMutedColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getProviderName(provider), style: Theme.of(context).textTheme.titleSmall),
                      Text(token != null ? '${token.length > 20 ? token.substring(0, 20) : token}...' : example_resources.resources.push_notification.no_token, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                    ],
                  ),
                ),
                if (token != null)
                  IconButton(
                    icon: Icon(LucideIcons.copy, size: 14),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: token));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(example_resources.resources.push_notification.token_copied)));
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
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: viewModel.optIn, icon: Icon(LucideIcons.bellRing, size: 16), label: Text(example_resources.resources.push_notification.opt_in))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: viewModel.optOut, icon: Icon(LucideIcons.bellOff, size: 16), label: Text(example_resources.resources.push_notification.opt_out))),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: viewModel.clearAllData,
              icon: Icon(LucideIcons.trash2, size: 16),
              label: Text(example_resources.resources.push_notification.clear_all_data),
              style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String message) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(message, style: TextStyle(fontSize: 12, color: context.textMutedColor))),
    );
  }

  String _getProviderName(PushNotificationProviderType type) {
    switch (type) {
      case PushNotificationProviderType.onesignal: return example_resources.resources.push_notification.onesignal;
      case PushNotificationProviderType.firebase: return example_resources.resources.push_notification.firebase;
      case PushNotificationProviderType.custom: return example_resources.resources.push_notification.custom;
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
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _topicController,
                  decoration: InputDecoration(hintText: example_resources.resources.push_notification.enter_topic_name, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  style: TextStyle(fontSize: 14),
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
                child: Text(example_resources.resources.common.subscribe),
              ),
            ],
          ),
          if (widget.state.subscribedTopics.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.state.subscribedTopics.map((topic) {
                return Chip(label: Text(topic, style: TextStyle(fontSize: 12)), deleteIcon: Icon(LucideIcons.x, size: 14), onDeleted: () => widget.viewModel.unsubscribeFromTopic(topic));
              }).toList(),
            ),
          ],
          if (widget.state.subscribedTopics.isEmpty)
            Padding(padding: EdgeInsets.only(top: 12), child: Text(example_resources.resources.push_notification.no_topics_subscribed, style: TextStyle(fontSize: 12, color: context.textMutedColor))),
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
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _userIdController,
                  decoration: InputDecoration(hintText: example_resources.resources.push_notification.enter_user_id, isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  widget.viewModel.setUserId(_userIdController.text.trim());
                  _userIdController.clear();
                },
                child: Text(example_resources.resources.common.set),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(onPressed: widget.viewModel.removeUserId, icon: Icon(LucideIcons.logOut, size: 14), label: Text(example_resources.resources.push_notification.remove_user_id)),
          ),
        ],
      ),
    );
  }
}
