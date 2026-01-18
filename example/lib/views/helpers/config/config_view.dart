import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/theme_helper.dart';
import 'cubit/config_cubit.dart';
import 'cubit/config_state.dart';

/// App Config View - Minimalist design
class ConfigView extends MasterViewCubit<ConfigCubit, ConfigState> {
  ConfigView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('App Config'),
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
                  onPressed: () => viewModel.loadConfig(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      ConfigCubit viewModel, BuildContext context) async {
    await viewModel.loadConfig();
  }

  @override
  Widget viewContent(
      BuildContext context, ConfigCubit viewModel, ConfigState state) {
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
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => viewModel.loadConfig(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('assets/app_config.json',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                    fontSize: 10, color: context.textMutedColor)),
            const SizedBox(height: 12),
            if (state.config != null) ...[
              _buildSection(context, 'appSettings',
                  state.config!['appSettings'] as Map<String, dynamic>?),
              _buildSection(context, 'uiConfiguration',
                  state.config!['uiConfiguration'] as Map<String, dynamic>?),
              _buildSection(context, 'splashConfiguration',
                  state.config!['splashConfiguration'] as Map<String, dynamic>?),
              _buildSection(context, 'apiConfiguration',
                  state.config!['apiConfiguration'] as Map<String, dynamic>?),
              _buildSection(context, 'storageConfiguration',
                  state.config!['storageConfiguration'] as Map<String, dynamic>?),
            ],
          ],
        );
  }

  Widget _buildSection(
      BuildContext context, String title, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 12)),
          ),
          ...data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.key,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                                fontSize: 10, color: context.textMutedColor)),
                      ),
                      Expanded(
                        child: Text(
                          _formatValue(item.value),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < data.length - 1)
                  Divider(indent: 12, endIndent: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    if (value is List) return '[${value.length} items]';
    if (value is Map) return '{${value.length} keys}';
    return value.toString();
  }
}
