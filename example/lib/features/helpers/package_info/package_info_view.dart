import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/package_info/cubit/package_info_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/package_info/cubit/package_info_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

/// Package Info View - Minimalist design
class PackageInfoView
    extends MasterViewCubit<PackageInfoCubit, PackageInfoState> {
  PackageInfoView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Package Info'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  onPressed: () => viewModel.loadPackageInfo(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      PackageInfoCubit viewModel, BuildContext context) async {
    await viewModel.loadPackageInfo();
  }

  @override
  Widget viewContent(BuildContext context, PackageInfoCubit viewModel,
      PackageInfoState state) {
    return BlocBuilder<PackageInfoCubit, PackageInfoState>(
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
                  onPressed: () => viewModel.loadPackageInfo(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final items = [
          _Item('app_name', state.appName),
          _Item('package_name', state.packageName),
          _Item('version', state.version),
          _Item('build_number', state.buildNumber),
          _Item('version_build', state.versionAndBuild),
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
                              width: 100,
                              child: Text(
                                item.key,
                                style: AppTheme.mono.copyWith(
                                    fontSize: 10, color: AppTheme.textMuted),
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

class _Item {
  final String key;
  final String? value;

  _Item(this.key, this.value);
}
