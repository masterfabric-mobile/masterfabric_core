import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterfabric_core/src/base/base_view_state.dart';

/// Cubit for managing WebView state
class WebViewerCubit extends Cubit<BaseViewState<String>> {
  WebViewerCubit() : super(const BaseViewState.loading());

  InAppWebViewController? _webViewController;
  String _currentUrl = '';
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _isLoading = false;

  /// Get current URL
  String get currentUrl => _currentUrl;

  /// Whether navigation can go back
  bool get canGoBack => _canGoBack;

  /// Whether navigation can go forward
  bool get canGoForward => _canGoForward;

  /// Whether content is currently loading
  bool get isLoading => _isLoading;

  /// Load a URL
  void loadUrl(String url) {
    try {
      if (url.isEmpty) {
        emit(const BaseViewState.error("Invalid URL"));
        return;
      }

      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http')) {
        emit(const BaseViewState.error("Invalid URL format"));
        return;
      }

      _currentUrl = url;

      if (!state.hasContent) {
        emit(const BaseViewState.loading());
      } else {
        _isLoading = true;
      }

      if (_webViewController != null) {
        _webViewController!.loadUrl(
          urlRequest: URLRequest(url: WebUri(uri.toString())),
        );
      }
    } catch (e) {
      emit(BaseViewState.error("Failed to load URL: ${e.toString()}"));
    }
  }

  /// Navigate back
  void goBack() {
    if (_canGoBack) {
      _webViewController?.goBack();
    }
  }

  /// Navigate forward
  void goForward() {
    if (_canGoForward) {
      _webViewController?.goForward();
    }
  }

  /// Reload current page
  void reload() {
    _webViewController?.reload();
  }

  /// Stop loading
  void stopLoading() {
    _webViewController?.stopLoading();
  }

  /// Set WebView controller
  void setWebViewController(InAppWebViewController controller) {
    _webViewController = controller;

    if (_currentUrl.isNotEmpty) {
      final uri = Uri.tryParse(_currentUrl);
      if (uri != null) {
        controller.loadUrl(
          urlRequest: URLRequest(url: WebUri(uri.toString())),
        );
      }
    }
  }

  /// Update navigation state
  void updateNavigationState({
    bool? canGoBack,
    bool? canGoForward,
    bool? isLoading,
  }) {
    if (canGoBack != null) _canGoBack = canGoBack;
    if (canGoForward != null) _canGoForward = canGoForward;
    if (isLoading != null) _isLoading = isLoading;
  }

  /// Set content state
  void setContent(String url) {
    emit(BaseViewState.content(url));
  }

  /// Set error state
  void setError(String message) {
    emit(BaseViewState.error(message));
  }
}
