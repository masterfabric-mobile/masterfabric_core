import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/config/cubit/config_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/config/cubit/config_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

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
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
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
    return BlocBuilder<ConfigCubit, ConfigState>(
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
                style: AppTheme.mono.copyWith(
                    fontSize: 10, color: AppTheme.textMuted)),
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
      },
    );
  }

  Widget _buildSection(
      BuildContext context, String title, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Text(title, style: AppTheme.mono.copyWith(fontSize: 12)),
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
                            style: AppTheme.mono.copyWith(
                                fontSize: 10, color: AppTheme.textMuted)),
                      ),
                      Expanded(
                        child: Text(
                          _formatValue(item.value),
                          style: AppTheme.mono.copyWith(fontSize: 11),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < data.length - 1)
                  const Divider(indent: 12, endIndent: 12),
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
