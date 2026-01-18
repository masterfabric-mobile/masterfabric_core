import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/theme_helper.dart';
import 'cubit/force_update_demo_cubit.dart';
import 'cubit/force_update_demo_state.dart';

/// Force Update Demo View
class ForceUpdateView
    extends MasterViewCubit<ForceUpdateDemoCubit, ForceUpdateDemoState> {
  ForceUpdateView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Force Update'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(
      ForceUpdateDemoCubit viewModel, BuildContext context) async {
    await viewModel.initialize();
  }

  @override
  Widget viewContent(BuildContext context, ForceUpdateDemoCubit viewModel,
      ForceUpdateDemoState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.errorMessage != null)
          _buildMessageCard(context, state.errorMessage!, isError: true),
        if (state.statusMessage != null && state.errorMessage == null)
          _buildMessageCard(context, state.statusMessage!, isError: false),
        _buildSectionTitle(context, 'Status'),
        _buildStatusCard(context, state, viewModel),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Preview UI Type'),
        _buildUITypeSelector(context, state, viewModel),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Simulation Mode'),
        _buildSimulationCard(context, state, viewModel),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Preview Update UI'),
        _buildPreviewButtons(context, state, viewModel),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Version Comparison'),
        _buildVersionComparisonCard(context),
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

  Widget _buildMessageCard(BuildContext context, String message, {required bool isError}) {
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
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ForceUpdateDemoState state, ForceUpdateDemoCubit viewModel) {
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
                    Text(state.isInitialized ? 'Initialized' : 'Not Initialized', style: Theme.of(context).textTheme.titleSmall),
                    Text('App Version: ${state.currentVersion ?? 'unknown'}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
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
          Divider(height: 24),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: state.isInitialized && !state.isLoading ? viewModel.checkForUpdate : null, icon: Icon(LucideIcons.refreshCw, size: 16), label: const Text('Check Update'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(onPressed: state.isInitialized ? viewModel.openStore : null, icon: Icon(LucideIcons.store, size: 16), label: const Text('Open Store'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUITypeSelector(BuildContext context, ForceUpdateDemoState state, ForceUpdateDemoCubit viewModel) {
    return Container(
      decoration: context.cardDecoration,
      child: Column(
        children: UpdateUIType.values.map((type) {
          final isSelected = state.selectedUIType == type;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => viewModel.setUIType(type),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(_getUITypeIcon(type), size: 20, color: isSelected ? context.accentColor : context.textMutedColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getUITypeName(type), style: Theme.of(context).textTheme.titleSmall),
                          Text(_getUITypeDescription(type), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                        ],
                      ),
                    ),
                    if (isSelected) Icon(LucideIcons.check, size: 16, color: context.accentColor),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSimulationCard(BuildContext context, ForceUpdateDemoState state, ForceUpdateDemoCubit viewModel) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Use Simulation', style: Theme.of(context).textTheme.titleSmall)),
              Switch(value: state.demoConfig.useSimulation, onChanged: (_) => viewModel.toggleSimulationMode()),
            ],
          ),
          if (state.demoConfig.useSimulation) ...[
            Divider(height: 24),
            _buildVersionInput(context, 'Current Version', state.demoConfig.simulatedCurrentVersion, (value) => viewModel.setSimulatedCurrentVersion(value)),
            const SizedBox(height: 12),
            _buildVersionInput(context, 'Latest Version', state.demoConfig.simulatedLatestVersion, (value) => viewModel.setSimulatedLatestVersion(value)),
            const SizedBox(height: 12),
            _buildVersionInput(context, 'Minimum Version', state.demoConfig.simulatedMinimumVersion ?? '', (value) => viewModel.setSimulatedMinimumVersion(value.isEmpty ? null : value)),
            const SizedBox(height: 16),
            Text('Tip: Set minimum > current for force update', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
          ],
        ],
      ),
    );
  }

  Widget _buildVersionInput(BuildContext context, String label, String initialValue, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(width: 140, child: Text(label, style: TextStyle(fontSize: 12))),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: initialValue),
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 12),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewButtons(BuildContext context, ForceUpdateDemoState state, ForceUpdateDemoCubit viewModel) {
    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPreviewButton(context, 'Optional Update', 'Show dismissible update prompt', LucideIcons.info, () => _showPreview(context, viewModel, UpdateType.optional)),
          Divider(height: 16),
          _buildPreviewButton(context, 'Recommended Update', 'Show recommended update prompt', LucideIcons.triangleAlert, () => _showPreview(context, viewModel, UpdateType.recommended)),
          Divider(height: 16),
          _buildPreviewButton(context, 'Force Update', 'Show blocking update screen', LucideIcons.shieldAlert, () => _showPreview(context, viewModel, UpdateType.force)),
        ],
      ),
    );
  }

  Widget _buildPreviewButton(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: context.accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 20, color: context.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor)),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16, color: context.textMutedColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context, ForceUpdateDemoCubit viewModel, UpdateType updateType) {
    final state = viewModel.state;
    UpdateInfo info;
    if (state.demoConfig.useSimulation) {
      info = viewModel.createSimulatedUpdateInfo().copyWith(
        updateType: updateType,
        showLaterButton: updateType != UpdateType.force,
        showSkipButton: updateType == UpdateType.optional,
      );
    } else {
      info = UpdateInfo(
        currentVersion: state.currentVersion ?? '1.0.0',
        latestVersion: '2.0.0',
        minimumVersion: updateType == UpdateType.force ? '1.5.0' : null,
        updateType: updateType,
        releaseNotes: 'Demo release notes for preview.',
        features: ['New feature 1', 'Performance improvements', 'Bug fixes'],
        storeConfig: const StoreConfig(appStoreId: '123456789', playStorePackage: 'com.masterfabric.example'),
        showLaterButton: updateType != UpdateType.force,
        showSkipButton: updateType == UpdateType.optional,
      );
    }

    switch (state.selectedUIType) {
      case UpdateUIType.dialog:
        showDialog(
          context: context,
          barrierDismissible: info.isDismissible,
          builder: (context) => UpdateAlertDialog(
            info: info,
            strings: const ForceUpdateStrings(),
            onUpdate: () { Navigator.of(context).pop(); viewModel.openStore(); },
            onLater: info.showLaterButton ? () => Navigator.of(context).pop() : null,
            onSkip: info.showSkipButton ? () => Navigator.of(context).pop() : null,
          ),
        );
        break;
      case UpdateUIType.bottomSheet:
        showModalBottomSheet(
          context: context,
          isDismissible: info.isDismissible,
          enableDrag: info.isDismissible,
          isScrollControlled: true,
          builder: (context) => UpdateBottomSheet(
            info: info,
            strings: const ForceUpdateStrings(),
            onUpdate: () { Navigator.of(context).pop(); viewModel.openStore(); },
            onLater: info.showLaterButton ? () => Navigator.of(context).pop() : null,
            onSkip: info.showSkipButton ? () => Navigator.of(context).pop() : null,
          ),
        );
        break;
      case UpdateUIType.fullScreen:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForceUpdateScreen(info: info, strings: const ForceUpdateStrings(), onUpdate: () { Navigator.of(context).pop(); viewModel.openStore(); }),
            fullscreenDialog: true,
          ),
        );
        break;
    }
  }

  Widget _buildVersionComparisonCard(BuildContext context) {
    final comparisons = [('1.0.0', '2.0.0', 'older'), ('2.0.0', '1.0.0', 'newer'), ('1.0.0', '1.0.0', 'equal'), ('1.0.0-beta', '1.0.0', 'older (pre-release)'), ('1.0.0+1', '1.0.0+2', 'older (build)')];

    return Container(
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Version Comparator Examples', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          ...comparisons.map((item) {
            final result = VersionComparator.compare(item.$1, item.$2);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('${item.$1} vs ${item.$2}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11)),
                  const Expanded(child: SizedBox()),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: _getComparisonColor(context, result).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.$3, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono', fontSize: 10, color: _getComparisonColor(context, result))),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getComparisonColor(BuildContext context, int result) {
    if (result < 0) return context.warningColor;
    if (result > 0) return context.successColor;
    return context.accentColor;
  }

  IconData _getUITypeIcon(UpdateUIType type) {
    switch (type) {
      case UpdateUIType.dialog: return LucideIcons.messageSquare;
      case UpdateUIType.bottomSheet: return LucideIcons.panelBottom;
      case UpdateUIType.fullScreen: return LucideIcons.maximize2;
    }
  }

  String _getUITypeName(UpdateUIType type) {
    switch (type) {
      case UpdateUIType.dialog: return 'Alert Dialog';
      case UpdateUIType.bottomSheet: return 'Bottom Sheet';
      case UpdateUIType.fullScreen: return 'Full Screen';
    }
  }

  String _getUITypeDescription(UpdateUIType type) {
    switch (type) {
      case UpdateUIType.dialog: return 'Compact dialog overlay';
      case UpdateUIType.bottomSheet: return 'Modal from bottom';
      case UpdateUIType.fullScreen: return 'Blocking full page';
    }
  }
}
