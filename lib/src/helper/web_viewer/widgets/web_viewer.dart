import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterfabric_core/src/base/base_view_state.dart';
import 'package:masterfabric_core/src/helper/security/url_security.dart';
import 'package:masterfabric_core/src/helper/web_viewer/web_viewer_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// Web Viewer Widget - displays web pages with navigation controls.
///
/// Defaults are **secure-by-default**: file URL access off, mixed content
/// blocked, navigation allowlisted to HTTPS, WebView permissions denied
/// unless [onPermissionDecision] grants them.
class WebViewer extends StatefulWidget {
  const WebViewer({
    super.key,
    required this.url,
    this.showNavigationControls = false,
    this.height,
    this.enableFullscreen = false,
    this.initialSettings,
    this.loadingWidget,
    this.errorWidget,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onReceivedHttpError,
    this.onProgressChanged,
    this.onUpdateVisitedHistory,
    this.onConsoleMessage,
    this.onPermissionRequest,
    this.onPermissionDecision,
    this.onDownloadStartRequest,
    this.allowedUrlSchemes = UrlSecurity.defaultWebViewSchemes,
    this.allowedHosts,
    this.allowInsecureHttp = false,
  });

  /// URL to load
  final String url;

  /// Whether to show navigation controls
  final bool showNavigationControls;

  /// Fixed height for the viewer
  final double? height;

  /// Whether to enable fullscreen mode
  final bool enableFullscreen;

  /// Custom WebView settings (merged over secure defaults when provided as full replacement)
  final InAppWebViewSettings? initialSettings;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom error widget
  final Widget? errorWidget;

  /// Callback when page starts loading
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStart;

  /// Callback when page finishes loading
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStop;

  /// Callback when an error occurs
  final void Function(InAppWebViewController controller, WebUri? url, int code,
      String message)? onReceivedError;

  /// Callback when HTTP error occurs
  final void Function(InAppWebViewController controller, WebUri? url,
      int statusCode, String? description)? onReceivedHttpError;

  /// Callback when loading progress changes
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;

  /// Callback when visited history is updated
  final void Function(InAppWebViewController controller, WebUri? url,
      bool? androidIsReload)? onUpdateVisitedHistory;

  /// Callback for console messages
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;

  /// Observational callback for permission requests (does not grant).
  final void Function(InAppWebViewController controller,
      PermissionRequest permissionRequest)? onPermissionRequest;

  /// Host-app decision for WebView permission prompts. Defaults to DENY.
  final Future<PermissionResponseAction> Function(
    InAppWebViewController controller,
    PermissionRequest permissionRequest,
  )? onPermissionDecision;

  /// Callback when download starts
  final void Function(InAppWebViewController controller,
      DownloadStartRequest downloadStartRequest)? onDownloadStartRequest;

  /// Schemes allowed for in-WebView navigation (default: https, about, data).
  final Set<String> allowedUrlSchemes;

  /// Optional host allowlist for http(s) navigations.
  final Set<String>? allowedHosts;

  /// When true, allows `http://` navigations (off by default).
  final bool allowInsecureHttp;
  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = WebViewerCubit();

    // Web platform uses iframe
    if (kIsWeb) {
      _cubit.setContent(widget.url);
    }
  }

  @override
  void didUpdateWidget(covariant WebViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && widget.url.isNotEmpty) {
      _cubit.loadUrl(widget.url);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<WebViewerCubit, BaseViewState<String>>(
        builder: (context, state) {
          return Column(
            children: [
              if (widget.showNavigationControls) _buildNavigationControls(),
              Expanded(
                child: Stack(
                  children: [
                    _buildWebViewWidget(),
                    state.when(
                      loading: () => Positioned.fill(
                        child: Center(
                          child: widget.loadingWidget ??
                              const CircularProgressIndicator(),
                        ),
                      ),
                      error: (message) => Positioned.fill(
                        child:
                            widget.errorWidget ?? _buildErrorWidget(message),
                      ),
                      content: (_) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _cubit.canGoBack ? () => _cubit.goBack() : null,
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _cubit.canGoForward ? () => _cubit.goForward() : null,
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _cubit.reload(),
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: _cubit.isLoading ? () => _cubit.stopLoading() : null,
            iconSize: 20,
          ),
          if (widget.enableFullscreen)
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: _openFullscreen,
              iconSize: 20,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _cubit.currentUrl.isNotEmpty ? _cubit.currentUrl : widget.url,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreen() {
    final current =
        _cubit.currentUrl.isNotEmpty ? _cubit.currentUrl : widget.url;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('WebView'),
          ),
          body: SafeArea(
            child: WebViewerHelper.url(
              current,
              showNavigationControls: true,
              enableFullscreen: false,
            ),
          ),
        ),
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
            'Error loading page',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _cubit.reload(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewWidget() {
    if (kIsWeb) {
      return _buildWebIframe();
    }
    return _buildInAppWebView();
  }

  Widget _buildWebIframe() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildWebNavigationControls(),
          Expanded(
            child: Html(
              data: '''
                <iframe 
                  src="${widget.url}" 
                  width="100%" 
                  height="100%" 
                  frameborder="0"
                  style="border: none; border-radius: 8px;">
                </iframe>
              ''',
              style: {
                "iframe": Style(
                  width: Width(100, Unit.percent),
                  height: Height(100, Unit.percent),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _launchInBrowser,
            iconSize: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.url,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser() async {
    if (!UrlSecurity.isAllowedUrl(
      widget.url,
      allowInsecureHttp: widget.allowInsecureHttp,
      allowedHosts: widget.allowedHosts,
    )) {
      return;
    }
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  bool _isNavigationAllowed(WebUri? url) {
    if (url == null) return false;
    return UrlSecurity.isAllowedUrl(
      url.toString(),
      allowedSchemes: widget.allowedUrlSchemes,
      allowInsecureHttp: widget.allowInsecureHttp,
      allowedHosts: widget.allowedHosts,
    );
  }

  Widget _buildInAppWebView() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InAppWebView(
          initialSettings: widget.initialSettings ?? _getDefaultSettings(),
          onWebViewCreated: (controller) {
            _cubit.setWebViewController(controller);
            if (_isNavigationAllowed(WebUri(widget.url))) {
              _cubit.loadUrl(widget.url);
            } else {
              _cubit.setError('Blocked URL (scheme/host not allowlisted)');
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url;
            if (_isNavigationAllowed(url)) {
              return NavigationActionPolicy.ALLOW;
            }
            return NavigationActionPolicy.CANCEL;
          },
          onLoadStart: (controller, url) async {
            _cubit.updateNavigationState(
              canGoBack: await controller.canGoBack(),
              canGoForward: await controller.canGoForward(),
              isLoading: true,
            );
            widget.onLoadStart?.call(controller, url);
          },
          onLoadStop: (controller, url) async {
            _cubit.updateNavigationState(
              canGoBack: await controller.canGoBack(),
              canGoForward: await controller.canGoForward(),
              isLoading: false,
            );
            _cubit.setContent(url?.toString() ?? _cubit.currentUrl);
            widget.onLoadStop?.call(controller, url);
          },
          onReceivedError: (controller, request, error) {
            _cubit.setError(error.description);
            widget.onReceivedError
                ?.call(controller, request.url, 0, error.description);
          },
          onReceivedHttpError: (controller, request, errorResponse) {
            _cubit.updateNavigationState(isLoading: false);
            widget.onReceivedHttpError?.call(
              controller,
              request.url,
              errorResponse.statusCode ?? 0,
              errorResponse.reasonPhrase,
            );
          },
          onProgressChanged: (controller, progress) async {
            _cubit.updateNavigationState(
              canGoBack: await controller.canGoBack(),
              canGoForward: await controller.canGoForward(),
              isLoading: progress < 100,
            );
            if (progress == 100) {
              final url = await controller.getUrl();
              _cubit.setContent(url?.toString() ?? _cubit.currentUrl);
            }
            widget.onProgressChanged?.call(controller, progress);
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            widget.onUpdateVisitedHistory
                ?.call(controller, url, androidIsReload);
          },
          onConsoleMessage: (controller, consoleMessage) {
            widget.onConsoleMessage?.call(controller, consoleMessage);
          },
          onPermissionRequest: (controller, permissionRequest) async {
            widget.onPermissionRequest?.call(controller, permissionRequest);
            final action = widget.onPermissionDecision != null
                ? await widget.onPermissionDecision!(
                    controller,
                    permissionRequest,
                  )
                : PermissionResponseAction.DENY;
            return PermissionResponse(
              resources: permissionRequest.resources,
              action: action,
            );
          },
          onDownloadStartRequest: (controller, downloadStartRequest) {
            widget.onDownloadStartRequest
                ?.call(controller, downloadStartRequest);
          },
        ),
      ),
    );
  }

  /// Secure-by-default WebView settings.
  InAppWebViewSettings _getDefaultSettings() {
    return InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
      allowsInlineMediaPlayback: true,
      iframeAllow: '',
      iframeAllowFullscreen: false,
      javaScriptEnabled: true,
      domStorageEnabled: true,
      databaseEnabled: false,
      clearCache: false,
      cacheEnabled: true,
      supportZoom: true,
      builtInZoomControls: true,
      displayZoomControls: false,
      useWideViewPort: true,
      loadWithOverviewMode: true,
      allowFileAccess: false,
      allowContentAccess: false,
      allowFileAccessFromFileURLs: false,
      allowUniversalAccessFromFileURLs: false,
      thirdPartyCookiesEnabled: false,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
      allowsAirPlayForMediaPlayback: true,
      allowsBackForwardNavigationGestures: true,
      allowsLinkPreview: true,
      isFraudulentWebsiteWarningEnabled: true,
      isPagingEnabled: true,
      disableHorizontalScroll: false,
      disableVerticalScroll: false,
      disableContextMenu: false,
      disableLongPressContextMenuOnLinks: false,
      disableInputAccessoryView: false,
      suppressesIncrementalRendering: false,
    );
  }
}
