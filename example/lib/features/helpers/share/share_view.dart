import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/share/cubit/share_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/share/cubit/share_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

/// Share View - Minimalist design
class ShareView extends MasterViewCubit<ShareCubit, ShareState> {
  ShareView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Share'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(
      ShareCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, ShareCubit viewModel, ShareState state) {
    return BlocBuilder<ShareCubit, ShareState>(
      bloc: viewModel,
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ShareTextSection(
              onShare: (text) =>
                  viewModel.shareText(text, subject: 'MasterFabric Core'),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.border)),
                    ),
                    child: Text('Share File',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Use ApplicationShareHelper.shareFile() to share files',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: AppTheme.codeBlock,
                          child: Text(
                            "ApplicationShareHelper.shareFile('/path/to/file.pdf');",
                            style: AppTheme.mono.copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShareTextSection extends StatefulWidget {
  final Function(String) onShare;

  const _ShareTextSection({required this.onShare});

  @override
  State<_ShareTextSection> createState() => _ShareTextSectionState();
}

class _ShareTextSectionState extends State<_ShareTextSection> {
  final _ctrl = TextEditingController(
    text: 'Check out MasterFabric Core - A comprehensive Flutter package!',
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child:
                Text('Share Text', style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _ctrl,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Enter text'),
                  style: AppTheme.mono,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_ctrl.text.isNotEmpty) widget.onShare(_ctrl.text);
                    },
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
