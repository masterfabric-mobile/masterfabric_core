import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterfabric_core/src/base/base_view_state.dart';
import 'package:masterfabric_core/src/helper/web_viewer/config/html_style_config.dart';
import 'package:masterfabric_core/src/helper/web_viewer/cubits/html_viewer_cubit.dart';

/// Styled HTML Viewer Widget - renders HTML with custom style configuration
class StyledHtmlViewer extends StatelessWidget {
  const StyledHtmlViewer({
    super.key,
    required this.htmlContent,
    required this.config,
    this.onLinkTap,
    this.height,
  });

  /// HTML content to render
  final String htmlContent;

  /// Style configuration
  final HtmlStyleConfig config;

  /// Callback when a link is tapped
  final void Function(String? url, Map<String, String> attributes)? onLinkTap;

  /// Fixed height for the viewer
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HtmlViewerCubit()..loadHtml(htmlContent, sanitize: true),
      child: BlocBuilder<HtmlViewerCubit, BaseViewState<String>>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => _buildErrorWidget(message),
            content: (html) => SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: Html(
                  data: html,
                  style: config.toStyleMap(),
                  onLinkTap: onLinkTap != null
                      ? (url, attributes, element) =>
                          onLinkTap!(url, attributes)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading content',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
