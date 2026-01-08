import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterfabric_core/src/helper/web_viewer/config/html_style_config.dart';

/// Converts HTML content to Flutter widgets programmatically
///
/// Example:
/// ```dart
/// final htmlWidget = WebViewerHelper.widget('<div><h1>Title</h1></div>');
/// Widget widget = htmlWidget.toWidget();
/// String text = htmlWidget.extractText();
/// ```
class HtmlWidget {
  /// The raw HTML content
  final String htmlContent;

  /// Optional style configuration
  final HtmlStyleConfig? config;

  HtmlWidget(this.htmlContent, {this.config});

  /// Convert HTML to a single Flutter widget
  Widget toWidget({BoxConstraints? constraints}) {
    Widget htmlWidget = Html(
      data: htmlContent,
      style: (config ?? HtmlStyleConfig.defaultConfig).toStyleMap(),
    );

    if (constraints != null) {
      return ConstrainedBox(
        constraints: constraints,
        child: htmlWidget,
      );
    }

    return htmlWidget;
  }

  /// Convert HTML to a list of widgets (useful for ListView)
  List<Widget> toWidgetList() {
    final sections = _splitHtmlSections(htmlContent);
    return sections.map((section) {
      return Html(
        data: section,
        style: (config ?? HtmlStyleConfig.defaultConfig).toStyleMap(),
      );
    }).toList();
  }

  /// Extract plain text from HTML
  String extractText() {
    String text = htmlContent;
    text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");
    return text.trim();
  }

  /// Extract all links (href values) from HTML
  List<String> extractLinks() {
    final regex = RegExp('href=["\']([^"\']+)["\']', caseSensitive: false);
    final matches = regex.allMatches(htmlContent);
    return matches
        .map((m) => m.group(1) ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Extract all image sources from HTML
  List<String> extractImages() {
    final regex = RegExp('src=["\']([^"\']+)["\']', caseSensitive: false);
    final matches = regex.allMatches(htmlContent);
    return matches
        .map((m) => m.group(1) ?? '')
        .where((s) => s.isNotEmpty && _isImageUrl(s))
        .toList();
  }

  /// Extract meta tags from HTML
  Map<String, String> extractMetaTags() {
    final Map<String, String> metaTags = {};
    final regex = RegExp(
      '<meta\\s+(?:name|property)=["\']([^"\']+)["\']\\s+content=["\']([^"\']+)["\']',
      caseSensitive: false,
    );
    final matches = regex.allMatches(htmlContent);
    for (final match in matches) {
      final name = match.group(1);
      final content = match.group(2);
      if (name != null && content != null) {
        metaTags[name] = content;
      }
    }
    return metaTags;
  }

  /// Query all elements matching a simple selector (tag name)
  List<String> querySelectorAll(String selector) {
    final regex = RegExp(
      '<$selector[^>]*>(.*?)</$selector>',
      caseSensitive: false,
      dotAll: true,
    );
    final matches = regex.allMatches(htmlContent);
    return matches.map((m) => m.group(0) ?? '').toList();
  }

  /// Query first element matching a simple selector
  String? querySelector(String selector) {
    final results = querySelectorAll(selector);
    return results.isNotEmpty ? results.first : null;
  }

  /// Transform HTML content with a custom transformer
  HtmlWidget transform(String Function(String html) transformer) {
    return HtmlWidget(transformer(htmlContent), config: config);
  }

  bool _isImageUrl(String url) {
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.svg',
      '.bmp'
    ];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.contains(ext));
  }

  List<String> _splitHtmlSections(String html) {
    final blockTags = [
      'div',
      'section',
      'article',
      'p',
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6'
    ];
    List<String> sections = [html];

    for (final tag in blockTags) {
      List<String> newSections = [];
      for (final section in sections) {
        final regex = RegExp(
          '(<$tag[^>]*>.*?</$tag>)',
          caseSensitive: false,
          dotAll: true,
        );
        final parts = section.split(regex);
        newSections.addAll(parts.where((p) => p.trim().isNotEmpty));
      }
      if (newSections.isNotEmpty) {
        sections = newSections;
      }
    }

    return sections.where((s) => s.trim().isNotEmpty).toList();
  }
}
