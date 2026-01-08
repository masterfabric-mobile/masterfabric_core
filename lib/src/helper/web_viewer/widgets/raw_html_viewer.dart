import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterfabric_core/src/helper/web_viewer/config/html_style_config.dart';

/// Raw HTML Viewer Widget - renders HTML without sanitization
///
/// WARNING: Only use this for trusted content! Scripts and event
/// handlers will NOT be removed.
class RawHtmlViewer extends StatelessWidget {
  const RawHtmlViewer({
    super.key,
    required this.htmlContent,
    this.showWarning = false,
    this.customStyle,
    this.onLinkTap,
    this.height,
  });

  /// HTML content to render (NOT sanitized)
  final String htmlContent;

  /// Whether to show unsafe content warning banner
  final bool showWarning;

  /// Custom flutter_html styles
  final Map<String, Style>? customStyle;

  /// Callback when a link is tapped
  final void Function(String? url, Map<String, String> attributes)? onLinkTap;

  /// Fixed height for the viewer
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showWarning) _buildWarningBanner(),
        Expanded(
          child: SizedBox(
            height: height,
            child: SingleChildScrollView(
              child: Html(
                data: htmlContent,
                style:
                    customStyle ?? HtmlStyleConfig.defaultConfig.toStyleMap(),
                onLinkTap: onLinkTap != null
                    ? (url, attributes, element) => onLinkTap!(url, attributes)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.orange[100],
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange[800], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Rendering unsanitized HTML content',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
