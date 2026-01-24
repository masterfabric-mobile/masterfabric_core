import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import 'cubit/share_cubit.dart';
import 'cubit/share_state.dart';

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
              title: Text(example_resources.resources.share.title),
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
      ShareCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, ShareCubit viewModel, ShareState state) {
    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ShareTextSection(
              onShare: (text) =>
                  viewModel.shareText(text, subject: 'MasterFabric Core'),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: context.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: context.borderColor)),
                    ),
                    child: Text(example_resources.resources.share.share_file,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use ApplicationShareHelper.shareFile() to share files',
                          style: TextStyle(
                              fontSize: 12, color: Theme.of(context).colorScheme.secondary),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: context.codeBlockDecoration,
                          child: Text(
                            "ApplicationShareHelper.shareFile('/path/to/file.pdf');",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10),
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child:
                Text(example_resources.resources.share.share_text, style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _ctrl,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: example_resources.resources.share.enter_text),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_ctrl.text.isNotEmpty) widget.onShare(_ctrl.text);
                    },
                    child: Text(example_resources.resources.share.title),
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
