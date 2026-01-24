import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import 'cubit/device_info_cubit.dart';
import 'cubit/device_info_state.dart';

/// Device Info Helper View - Minimalist design
class DeviceInfoView
    extends MasterViewCubit<DeviceInfoCubit, DeviceInfoState> {
  DeviceInfoView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.device_info.title),
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
                  onPressed: () => viewModel.loadDeviceInfo(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      DeviceInfoCubit viewModel, BuildContext context) async {
    await viewModel.loadDeviceInfo();
  }

  @override
  Widget viewContent(
      BuildContext context, DeviceInfoCubit viewModel, DeviceInfoState state) {
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
            Text(state.errorMessage ?? example_resources.resources.common.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => viewModel.loadDeviceInfo(),
              child: Text(example_resources.resources.common.retry),
            ),
          ],
        ),
      );
    }

    final items = [
          _InfoItem(example_resources.resources.device_info.platform, state.platform),
          _InfoItem(example_resources.resources.device_info.device_name, state.deviceName),
          _InfoItem(example_resources.resources.device_info.device_id, state.deviceId),
          _InfoItem(example_resources.resources.device_info.manufacturer, state.manufacturer),
          _InfoItem(example_resources.resources.device_info.model, state.model),
          _InfoItem(example_resources.resources.device_info.system_version, state.systemVersion),
        ];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: context.cardDecoration,
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                item.key,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                                    fontSize: 11, color: context.textMutedColor),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item.value ?? '-',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < items.length - 1) Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
  }
}

class _InfoItem {
  final String key;
  final String? value;

  _InfoItem(this.key, this.value);
}
