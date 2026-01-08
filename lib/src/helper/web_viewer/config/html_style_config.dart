import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Configuration class for styling HTML content
///
/// Provides reusable style configurations for HTML rendering with
/// pre-built presets and customization options.
///
/// Example:
/// ```dart
/// final config = HtmlStyleConfig(
///   headingStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
///   paragraphStyle: TextStyle(fontSize: 16, height: 1.6),
/// );
/// WebViewerHelper.styled(htmlContent, config: config);
/// ```
class HtmlStyleConfig {
  /// Style for h1-h6 headings
  final TextStyle? headingStyle;

  /// Style for paragraphs
  final TextStyle? paragraphStyle;

  /// Style for links
  final TextStyle? linkStyle;

  /// Style for lists (ul, ol, li)
  final TextStyle? listStyle;

  /// Style for code elements
  final TextStyle? codeStyle;

  /// Style for bold text (strong, b)
  final TextStyle? boldStyle;

  /// Style for italic text (em, i)
  final TextStyle? italicStyle;

  /// Decoration for blockquotes
  final BoxDecoration? blockquoteDecoration;

  /// Decoration for code blocks
  final BoxDecoration? codeBlockDecoration;

  /// Border for tables
  final TableBorder? tableBorder;

  /// Padding for table cells
  final EdgeInsets? tableCellPadding;

  /// Spacing between paragraphs
  final double paragraphSpacing;

  /// Spacing around headings
  final double headingSpacing;

  /// Indentation for lists
  final double listIndent;

  /// Base font size
  final double baseFontSize;

  /// Line height multiplier
  final double lineHeight;

  const HtmlStyleConfig({
    this.headingStyle,
    this.paragraphStyle,
    this.linkStyle,
    this.listStyle,
    this.codeStyle,
    this.boldStyle,
    this.italicStyle,
    this.blockquoteDecoration,
    this.codeBlockDecoration,
    this.tableBorder,
    this.tableCellPadding,
    this.paragraphSpacing = 8.0,
    this.headingSpacing = 12.0,
    this.listIndent = 16.0,
    this.baseFontSize = 14.0,
    this.lineHeight = 1.4,
  });

  /// Default configuration
  static const HtmlStyleConfig defaultConfig = HtmlStyleConfig();

  /// Article/blog style configuration
  factory HtmlStyleConfig.article() {
    return HtmlStyleConfig(
      headingStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      paragraphStyle: const TextStyle(
        fontSize: 16,
        height: 1.7,
      ),
      linkStyle: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      codeStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        backgroundColor: Colors.grey[200],
      ),
      blockquoteDecoration: BoxDecoration(
        border: const Border(
          left: BorderSide(color: Colors.grey, width: 4),
        ),
        color: Colors.grey[100],
      ),
      paragraphSpacing: 16.0,
      headingSpacing: 24.0,
      baseFontSize: 16.0,
      lineHeight: 1.7,
    );
  }

  /// Code documentation style configuration
  factory HtmlStyleConfig.code() {
    return HtmlStyleConfig(
      headingStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'monospace',
      ),
      paragraphStyle: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
      codeStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        backgroundColor: Colors.grey[900],
        color: Colors.green[400],
      ),
      codeBlockDecoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      linkStyle: TextStyle(
        color: Colors.blue[300],
        decoration: TextDecoration.none,
      ),
      baseFontSize: 14.0,
      lineHeight: 1.5,
    );
  }

  /// Minimal clean style configuration
  factory HtmlStyleConfig.minimal() {
    return const HtmlStyleConfig(
      headingStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      paragraphStyle: TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
      linkStyle: TextStyle(
        color: Colors.black87,
        decoration: TextDecoration.underline,
      ),
      paragraphSpacing: 8.0,
      headingSpacing: 12.0,
      baseFontSize: 14.0,
      lineHeight: 1.5,
    );
  }

  /// Dark theme style configuration
  factory HtmlStyleConfig.dark() {
    return HtmlStyleConfig(
      headingStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      paragraphStyle: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.grey[300],
      ),
      linkStyle: TextStyle(
        color: Colors.blue[300],
        decoration: TextDecoration.underline,
      ),
      codeStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        backgroundColor: Colors.grey[800],
        color: Colors.green[300],
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey[600]!, width: 3)),
        color: Colors.grey[800],
      ),
      baseFontSize: 15.0,
      lineHeight: 1.6,
    );
  }

  /// Create a copy with modified values
  HtmlStyleConfig copyWith({
    TextStyle? headingStyle,
    TextStyle? paragraphStyle,
    TextStyle? linkStyle,
    TextStyle? listStyle,
    TextStyle? codeStyle,
    TextStyle? boldStyle,
    TextStyle? italicStyle,
    BoxDecoration? blockquoteDecoration,
    BoxDecoration? codeBlockDecoration,
    TableBorder? tableBorder,
    EdgeInsets? tableCellPadding,
    double? paragraphSpacing,
    double? headingSpacing,
    double? listIndent,
    double? baseFontSize,
    double? lineHeight,
  }) {
    return HtmlStyleConfig(
      headingStyle: headingStyle ?? this.headingStyle,
      paragraphStyle: paragraphStyle ?? this.paragraphStyle,
      linkStyle: linkStyle ?? this.linkStyle,
      listStyle: listStyle ?? this.listStyle,
      codeStyle: codeStyle ?? this.codeStyle,
      boldStyle: boldStyle ?? this.boldStyle,
      italicStyle: italicStyle ?? this.italicStyle,
      blockquoteDecoration: blockquoteDecoration ?? this.blockquoteDecoration,
      codeBlockDecoration: codeBlockDecoration ?? this.codeBlockDecoration,
      tableBorder: tableBorder ?? this.tableBorder,
      tableCellPadding: tableCellPadding ?? this.tableCellPadding,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      headingSpacing: headingSpacing ?? this.headingSpacing,
      listIndent: listIndent ?? this.listIndent,
      baseFontSize: baseFontSize ?? this.baseFontSize,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  /// Convert to flutter_html Style map
  Map<String, Style> toStyleMap() {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        fontSize: FontSize(baseFontSize),
        lineHeight: LineHeight(lineHeight),
      ),
      "p": Style(
        margin: Margins.only(bottom: paragraphSpacing),
        padding: HtmlPaddings.zero,
        fontSize: paragraphStyle?.fontSize != null
            ? FontSize(paragraphStyle!.fontSize!)
            : null,
        lineHeight: paragraphStyle?.height != null
            ? LineHeight(paragraphStyle!.height!)
            : null,
        color: paragraphStyle?.color,
      ),
      "h1, h2, h3, h4, h5, h6": Style(
        margin: Margins.only(bottom: headingSpacing, top: headingSpacing / 2),
        padding: HtmlPaddings.zero,
        fontWeight: headingStyle?.fontWeight ?? FontWeight.bold,
        fontSize: headingStyle?.fontSize != null
            ? FontSize(headingStyle!.fontSize!)
            : null,
        color: headingStyle?.color,
      ),
      "a": Style(
        color: linkStyle?.color ?? Colors.blue,
        textDecoration: linkStyle?.decoration ?? TextDecoration.underline,
      ),
      "code": Style(
        fontFamily: codeStyle?.fontFamily ?? 'monospace',
        fontSize: codeStyle?.fontSize != null
            ? FontSize(codeStyle!.fontSize!)
            : FontSize(baseFontSize * 0.9),
        backgroundColor: codeStyle?.backgroundColor ?? Colors.grey[200],
        color: codeStyle?.color,
        padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
      ),
      "pre": Style(
        fontFamily: 'monospace',
        backgroundColor: codeBlockDecoration?.color ??
            codeStyle?.backgroundColor ??
            Colors.grey[200],
        padding: HtmlPaddings.all(12),
        margin: Margins.symmetric(vertical: 8),
      ),
      "blockquote": Style(
        margin: Margins.symmetric(vertical: 8),
        padding: HtmlPaddings.only(left: 16),
        backgroundColor: blockquoteDecoration?.color,
      ),
      "ul, ol": Style(
        margin: Margins.only(left: listIndent, bottom: paragraphSpacing),
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        margin: Margins.only(bottom: 4),
        padding: HtmlPaddings.zero,
      ),
      "strong, b": Style(
        fontWeight: boldStyle?.fontWeight ?? FontWeight.bold,
        color: boldStyle?.color,
      ),
      "em, i": Style(
        fontStyle: FontStyle.italic,
        color: italicStyle?.color,
      ),
      "table": Style(
        margin: Margins.symmetric(vertical: 8),
      ),
      "td, th": Style(
        padding: tableCellPadding != null
            ? HtmlPaddings.only(
                left: tableCellPadding!.left,
                right: tableCellPadding!.right,
                top: tableCellPadding!.top,
                bottom: tableCellPadding!.bottom,
              )
            : HtmlPaddings.all(8),
      ),
      "img": Style(
        width: Width(100, Unit.percent),
        height: Height.auto(),
        margin: Margins.symmetric(vertical: 8),
      ),
    };
  }
}
