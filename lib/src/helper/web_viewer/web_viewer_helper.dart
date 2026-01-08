import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Config
export 'config/html_style_config.dart';

// Models
export 'models/html_widget.dart';

// Cubits
export 'cubits/html_viewer_cubit.dart';
export 'cubits/web_viewer_cubit.dart';

// Widgets
export 'widgets/html_viewer.dart';
export 'widgets/raw_html_viewer.dart';
export 'widgets/styled_html_viewer.dart';
export 'widgets/web_viewer.dart';

import 'config/html_style_config.dart';
import 'models/html_widget.dart';
import 'widgets/html_viewer.dart';
import 'widgets/raw_html_viewer.dart';
import 'widgets/styled_html_viewer.dart';
import 'widgets/web_viewer.dart';

/// Unified Web Viewer Helper
///
/// Provides a single interface for both HTML content rendering
/// and web page viewing with multiple rendering modes.
///
/// ## Usage Examples
///
/// ### Sanitized HTML (safe for user content)
/// ```dart
/// WebViewerHelper.html('<p>Hello World!</p>')
/// ```
///
/// ### Web URL with navigation
/// ```dart
/// WebViewerHelper.url('https://example.com', showNavigationControls: true)
/// ```
///
/// ### Raw HTML (no sanitization - trusted content only)
/// ```dart
/// WebViewerHelper.raw('<script>alert("hi")</script><p>Content</p>')
/// ```
///
/// ### Styled HTML with configuration
/// ```dart
/// WebViewerHelper.styled(htmlContent, config: HtmlStyleConfig.article())
/// ```
///
/// ### HTML to Widget conversion
/// ```dart
/// final widget = WebViewerHelper.widget(htmlContent);
/// String text = widget.extractText();
/// ```
class WebViewerHelper {
  WebViewerHelper._();

  /// Create HTML content viewer with sanitization
  ///
  /// Removes potentially dangerous content like scripts and event handlers.
  /// Use this for user-generated or untrusted HTML content.
  ///
  /// Parameters:
  /// - [htmlContent]: HTML string to render
  /// - [customStyle]: Optional custom styling map
  /// - [onLinkTap]: Optional link tap handler
  /// - [loadingWidget]: Optional custom loading widget
  /// - [errorWidget]: Optional custom error widget
  /// - [height]: Optional fixed height
  static Widget html(
    String htmlContent, {
    Map<String, Style>? customStyle,
    void Function(String? url, Map<String, String> attributes)? onLinkTap,
    Widget? loadingWidget,
    Widget? errorWidget,
    double? height,
  }) {
    return HtmlViewer(
      htmlContent: htmlContent,
      customStyle: customStyle,
      onLinkTap: onLinkTap,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      height: height,
      sanitize: true,
    );
  }

  /// Create raw HTML viewer without sanitization
  ///
  /// WARNING: Only use this for trusted content! Scripts and event
  /// handlers will NOT be removed.
  ///
  /// Parameters:
  /// - [htmlContent]: HTML string to render
  /// - [showWarning]: Whether to show unsafe content warning
  /// - [customStyle]: Optional custom styling map
  /// - [onLinkTap]: Optional link tap handler
  /// - [height]: Optional fixed height
  static Widget raw(
    String htmlContent, {
    bool showWarning = false,
    Map<String, Style>? customStyle,
    void Function(String? url, Map<String, String> attributes)? onLinkTap,
    double? height,
  }) {
    return RawHtmlViewer(
      htmlContent: htmlContent,
      showWarning: showWarning,
      customStyle: customStyle,
      onLinkTap: onLinkTap,
      height: height,
    );
  }

  /// Create styled HTML viewer with custom configuration
  ///
  /// Parameters:
  /// - [htmlContent]: HTML string to render
  /// - [config]: Style configuration (use presets like HtmlStyleConfig.article())
  /// - [onLinkTap]: Optional link tap handler
  /// - [height]: Optional fixed height
  static Widget styled(
    String htmlContent, {
    HtmlStyleConfig config = HtmlStyleConfig.defaultConfig,
    void Function(String? url, Map<String, String> attributes)? onLinkTap,
    double? height,
  }) {
    return StyledHtmlViewer(
      htmlContent: htmlContent,
      config: config,
      onLinkTap: onLinkTap,
      height: height,
    );
  }

  /// Convert HTML to HtmlWidget for programmatic manipulation
  ///
  /// Parameters:
  /// - [htmlContent]: HTML string to convert
  /// - [config]: Optional style configuration
  ///
  /// Returns: HtmlWidget instance for conversion and extraction
  static HtmlWidget widget(String htmlContent, {HtmlStyleConfig? config}) {
    return HtmlWidget(htmlContent, config: config);
  }

  /// Create web URL viewer
  ///
  /// Parameters:
  /// - [url]: URL to load
  /// - [showNavigationControls]: Whether to show navigation controls
  /// - [enableFullscreen]: Whether to enable fullscreen mode
  /// - [height]: Optional fixed height
  /// - [initialSettings]: Optional WebView settings
  /// - [loadingWidget]: Optional custom loading widget
  /// - [errorWidget]: Optional custom error widget
  /// - Various callbacks for WebView events
  static Widget url(
    String url, {
    bool showNavigationControls = false,
    double? height,
    bool enableFullscreen = false,
    InAppWebViewSettings? initialSettings,
    Widget? loadingWidget,
    Widget? errorWidget,
    void Function(InAppWebViewController controller, WebUri? url)? onLoadStart,
    void Function(InAppWebViewController controller, WebUri? url)? onLoadStop,
    void Function(InAppWebViewController controller, WebUri? url, int code,
            String message)?
        onReceivedError,
    void Function(InAppWebViewController controller, WebUri? url,
            int statusCode, String? description)?
        onReceivedHttpError,
    void Function(InAppWebViewController controller, int progress)?
        onProgressChanged,
    void Function(InAppWebViewController controller, WebUri? url,
            bool? androidIsReload)?
        onUpdateVisitedHistory,
    void Function(
            InAppWebViewController controller, ConsoleMessage consoleMessage)?
        onConsoleMessage,
    void Function(InAppWebViewController controller,
            PermissionRequest permissionRequest)?
        onPermissionRequest,
    void Function(InAppWebViewController controller,
            DownloadStartRequest downloadStartRequest)?
        onDownloadStartRequest,
  }) {
    return WebViewer(
      url: url,
      showNavigationControls: showNavigationControls,
      height: height,
      enableFullscreen: enableFullscreen,
      initialSettings: initialSettings,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      onLoadStart: onLoadStart,
      onLoadStop: onLoadStop,
      onReceivedError: onReceivedError,
      onReceivedHttpError: onReceivedHttpError,
      onProgressChanged: onProgressChanged,
      onUpdateVisitedHistory: onUpdateVisitedHistory,
      onConsoleMessage: onConsoleMessage,
      onPermissionRequest: onPermissionRequest,
      onDownloadStartRequest: onDownloadStartRequest,
    );
  }

  /// Auto-detect content type and create appropriate viewer
  ///
  /// Parameters:
  /// - [content]: HTML content or URL
  /// - [isUrl]: Override auto-detection (optional)
  /// - [height]: Optional fixed height
  /// - [enableFullscreen]: Whether to enable fullscreen for URLs
  static Widget auto(
    String content, {
    bool? isUrl,
    double? height,
    bool enableFullscreen = false,
  }) {
    final bool isUrlContent = isUrl ?? _isUrl(content);

    if (isUrlContent) {
      return url(
        content,
        showNavigationControls: true,
        height: height,
        enableFullscreen: enableFullscreen,
      );
    } else {
      return html(content, height: height);
    }
  }

  /// Check if string is a URL
  static bool _isUrl(String content) {
    try {
      final uri = Uri.tryParse(content.trim());
      return uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
