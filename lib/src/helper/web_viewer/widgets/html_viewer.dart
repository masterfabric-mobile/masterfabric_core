import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterfabric_core/src/base/base_view_state.dart';
import 'package:masterfabric_core/src/helper/web_viewer/config/html_style_config.dart';
import 'package:masterfabric_core/src/helper/web_viewer/cubits/html_viewer_cubit.dart';

/// HTML Viewer Widget with sanitization support
class HtmlViewer extends StatelessWidget {
  const HtmlViewer({
    super.key,
    required this.htmlContent,
    this.customStyle,
    this.onLinkTap,
    this.loadingWidget,
    this.errorWidget,
    this.height,
    this.sanitize = true,
  });

  /// HTML content to render
  final String htmlContent;

  /// Custom flutter_html styles
  final Map<String, Style>? customStyle;

  /// Callback when a link is tapped
  final void Function(String? url, Map<String, String> attributes)? onLinkTap;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom error widget
  final Widget? errorWidget;

  /// Fixed height for the viewer
  final double? height;

  /// Whether to sanitize HTML content
  final bool sanitize;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HtmlViewerCubit()..loadHtml(htmlContent, sanitize: sanitize),
      child: BlocBuilder<HtmlViewerCubit, BaseViewState<String>>(
        builder: (context, state) {
          return state.when(
            loading: () =>
                loadingWidget ??
                const Center(child: CircularProgressIndicator()),
            error: (message) => errorWidget ?? _buildErrorWidget(message),
            content: (html) => SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: Html(
                  data: html,
                  style: customStyle ?? _getDefaultStyle(),
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

  Map<String, Style> _getDefaultStyle() {
    return HtmlStyleConfig.defaultConfig.toStyleMap();
  }
}
