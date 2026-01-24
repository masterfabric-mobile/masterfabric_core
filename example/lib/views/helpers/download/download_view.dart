import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import 'cubit/download_cubit.dart';
import 'cubit/download_state.dart';

/// Download View - Minimalist design
class DownloadView extends MasterViewCubit<DownloadCubit, DownloadState> {
  DownloadView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.download.title),
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
      DownloadCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, DownloadCubit viewModel, DownloadState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DownloadSection(
          onDownload: (url, name) => viewModel.downloadFile(url, name),
          isDownloading: state.isDownloading,
          progress: state.downloadProgress,
          status: state.downloadStatus,
          filePath: state.downloadedFilePath,
        ),
      ],
    );
  }
}

class _DownloadSection extends StatefulWidget {
  final Function(String url, String name) onDownload;
  final bool isDownloading;
  final double progress;
  final String? status;
  final String? filePath;

  const _DownloadSection({
    required this.onDownload,
    required this.isDownloading,
    required this.progress,
    this.status,
    this.filePath,
  });

  @override
  State<_DownloadSection> createState() => _DownloadSectionState();
}

class _DownloadSectionState extends State<_DownloadSection> {
  final _urlCtrl = TextEditingController(
    text:
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
  );
  final _nameCtrl = TextEditingController(text: 'dummy.pdf');

  @override
  void dispose() {
    _urlCtrl.dispose();
    _nameCtrl.dispose();
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
            child: Text(example_resources.resources.download.download_file,
                style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _urlCtrl,
                  decoration: InputDecoration(hintText: example_resources.resources.download.url),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(hintText: example_resources.resources.download.filename),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                ),
                const SizedBox(height: 12),
                if (widget.isDownloading) ...[
                  LinearProgressIndicator(value: widget.progress),
                  const SizedBox(height: 8),
                  Text(widget.status ?? '',
                      style: TextStyle(
                          fontSize: 11, color: context.textMutedColor)),
                ] else if (widget.status != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: context.codeBlockDecoration,
                    child: Row(
                      children: [
                        Icon(
                          widget.filePath != null
                              ? LucideIcons.check
                              : LucideIcons.x,
                          size: 14,
                          color: widget.filePath != null
                              ? context.successColor
                              : Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.status!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11)),
                              if (widget.filePath != null)
                                Text(
                                  widget.filePath!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                                      fontSize: 10, color: context.textMutedColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: widget.isDownloading
                        ? null
                        : () {
                            if (_urlCtrl.text.isNotEmpty &&
                                _nameCtrl.text.isNotEmpty) {
                              widget.onDownload(_urlCtrl.text, _nameCtrl.text);
                            }
                          },
                    child: Text(example_resources.resources.download.title),
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
