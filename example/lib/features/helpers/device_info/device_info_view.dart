import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/device_info/cubit/device_info_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/device_info/cubit/device_info_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

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
              title: const Text('Device Info'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
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
    return BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
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
                  onPressed: () => viewModel.loadDeviceInfo(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final items = [
          _InfoItem('platform', state.platform),
          _InfoItem('device_name', state.deviceName),
          _InfoItem('device_id', state.deviceId),
          _InfoItem('manufacturer', state.manufacturer),
          _InfoItem('model', state.model),
          _InfoItem('system_version', state.systemVersion),
        ];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: AppTheme.cardDecoration,
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
                                style: AppTheme.mono.copyWith(
                                    fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item.value ?? '-',
                                style: AppTheme.mono.copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < items.length - 1) const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoItem {
  final String key;
  final String? value;

  _InfoItem(this.key, this.value);
}
