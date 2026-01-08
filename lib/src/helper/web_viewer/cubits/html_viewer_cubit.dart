import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterfabric_core/src/base/base_view_state.dart';

/// Cubit for managing HTML viewer state
class HtmlViewerCubit extends Cubit<BaseViewState<String>> {
  HtmlViewerCubit() : super(const BaseViewState.loading());

  /// Load HTML content with optional sanitization
  void loadHtml(String htmlContent, {bool sanitize = true}) {
    try {
      if (htmlContent.isEmpty) {
        emit(const BaseViewState.error("No content available"));
        return;
      }

      final processedHtml = sanitize ? _sanitizeHtml(htmlContent) : htmlContent;
      emit(BaseViewState.content(processedHtml));
    } catch (e) {
      emit(BaseViewState.error("Failed to process HTML: ${e.toString()}"));
    }
  }

  /// Sanitize HTML content by removing potentially dangerous elements
  String _sanitizeHtml(String html) {
    String sanitized = html;

    // Remove script tags
    sanitized = sanitized.replaceAll(
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true),
      '',
    );

    // Remove javascript: protocols
    sanitized = sanitized.replaceAll(
      RegExp(r'javascript:', caseSensitive: false),
      '',
    );

    // Remove on* event handlers
    sanitized = sanitized.replaceAll(
      RegExp(r'\son\w+\s*=\s*"[^"]*"', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r"\son\w+\s*=\s*'[^']*'", caseSensitive: false),
      '',
    );

    // Remove style tags that might contain expressions
    sanitized = sanitized.replaceAll(
      RegExp(r'<style[^>]*>.*?</style>', caseSensitive: false, dotAll: true),
      '',
    );

    // Remove iframe tags
    sanitized = sanitized.replaceAll(
      RegExp(r'<iframe[^>]*>.*?</iframe>', caseSensitive: false, dotAll: true),
      '',
    );

    // Remove object/embed tags
    sanitized = sanitized.replaceAll(
      RegExp(r'<object[^>]*>.*?</object>', caseSensitive: false, dotAll: true),
      '',
    );
    sanitized = sanitized.replaceAll(
      RegExp(r'<embed[^>]*>', caseSensitive: false),
      '',
    );

    return sanitized;
  }
}
