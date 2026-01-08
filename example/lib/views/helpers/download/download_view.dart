import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
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
              title: const Text('Download'),
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
      DownloadCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, DownloadCubit viewModel, DownloadState state) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      bloc: viewModel,
      builder: (context, state) {
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
      },
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
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Text('Download File',
                style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _urlCtrl,
                  decoration: const InputDecoration(hintText: 'URL'),
                  style: AppTheme.mono,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(hintText: 'Filename'),
                  style: AppTheme.mono,
                ),
                const SizedBox(height: 12),
                if (widget.isDownloading) ...[
                  LinearProgressIndicator(value: widget.progress),
                  const SizedBox(height: 8),
                  Text(widget.status ?? '',
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textMuted)),
                ] else if (widget.status != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: AppTheme.codeBlock,
                    child: Row(
                      children: [
                        Icon(
                          widget.filePath != null
                              ? LucideIcons.check
                              : LucideIcons.x,
                          size: 14,
                          color: widget.filePath != null
                              ? AppTheme.success
                              : AppTheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.status!,
                                  style: AppTheme.mono.copyWith(fontSize: 11)),
                              if (widget.filePath != null)
                                Text(
                                  widget.filePath!,
                                  style: AppTheme.mono.copyWith(
                                      fontSize: 10, color: AppTheme.textMuted),
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
                    child: const Text('Download'),
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
