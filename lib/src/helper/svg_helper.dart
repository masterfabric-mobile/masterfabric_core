import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Configuration class for SVG rendering options
class SvgConfig {
  /// Width of the SVG
  final double? width;

  /// Height of the SVG
  final double? height;

  /// Color to tint the SVG
  final Color? color;

  /// How the SVG should be inscribed into the space
  final BoxFit fit;

  /// Alignment of the SVG within its bounds
  final Alignment alignment;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Widget to show while loading (for network SVGs)
  final Widget? placeholder;

  /// Widget to show on load failure
  final Widget? errorWidget;

  /// Whether to allow drawing outside the viewBox
  final bool allowDrawingOutsideViewBox;

  /// Creates an SVG configuration
  const SvgConfig({
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.placeholder,
    this.errorWidget,
    this.allowDrawingOutsideViewBox = false,
  });

  /// Creates a copy of this config with the given fields replaced
  SvgConfig copyWith({
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    Widget? placeholder,
    Widget? errorWidget,
    bool? allowDrawingOutsideViewBox,
  }) {
    return SvgConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      placeholder: placeholder ?? this.placeholder,
      errorWidget: errorWidget ?? this.errorWidget,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? this.allowDrawingOutsideViewBox,
    );
  }

  /// Default configuration
  static const SvgConfig defaultConfig = SvgConfig();

  /// Small icon configuration (24x24)
  static const SvgConfig smallIcon = SvgConfig(width: 24, height: 24);

  /// Medium icon configuration (32x32)
  static const SvgConfig mediumIcon = SvgConfig(width: 32, height: 32);

  /// Large icon configuration (48x48)
  static const SvgConfig largeIcon = SvgConfig(width: 48, height: 48);
}

/// Helper class for rendering SVG images from various sources
class SvgHelper {
  SvgHelper._();

  /// Build color filter from color
  static ColorFilter? _buildColorFilter(Color? color) {
    return color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;
  }

  /// Load SVG from asset path
  ///
  /// Example:
  /// ```dart
  /// SvgHelper.fromAsset('assets/icons/home.svg')
  /// SvgHelper.fromAsset(
  ///   'assets/icons/menu.svg',
  ///   width: 24,
  ///   height: 24,
  ///   color: Colors.blue,
  /// )
  /// ```
  static Widget fromAsset(
    String assetName, {
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? allowDrawingOutsideViewBox,
    String? package,
    SvgConfig? config,
  }) {
    final effectiveConfig = config ?? SvgConfig.defaultConfig;

    return SvgPicture.asset(
      assetName,
      width: width ?? effectiveConfig.width,
      height: height ?? effectiveConfig.height,
      colorFilter: _buildColorFilter(color ?? effectiveConfig.color),
      fit: fit ?? effectiveConfig.fit,
      alignment: alignment ?? effectiveConfig.alignment,
      semanticsLabel: semanticsLabel ?? effectiveConfig.semanticsLabel,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? effectiveConfig.allowDrawingOutsideViewBox,
      package: package,
    );
  }

  /// Load SVG from network URL
  ///
  /// Example:
  /// ```dart
  /// SvgHelper.fromNetwork(
  ///   'https://example.com/logo.svg',
  ///   width: 120,
  ///   height: 40,
  ///   placeholder: CircularProgressIndicator(),
  ///   errorWidget: Icon(Icons.error),
  /// )
  /// ```
  static Widget fromNetwork(
    String url, {
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? allowDrawingOutsideViewBox,
    Widget? placeholder,
    Widget? errorWidget,
    Map<String, String>? headers,
    SvgConfig? config,
  }) {
    final effectiveConfig = config ?? SvgConfig.defaultConfig;
    final effectivePlaceholder = placeholder ?? effectiveConfig.placeholder;
    final effectiveErrorWidget = errorWidget ?? effectiveConfig.errorWidget;

    return SvgPicture.network(
      url,
      width: width ?? effectiveConfig.width,
      height: height ?? effectiveConfig.height,
      colorFilter: _buildColorFilter(color ?? effectiveConfig.color),
      fit: fit ?? effectiveConfig.fit,
      alignment: alignment ?? effectiveConfig.alignment,
      semanticsLabel: semanticsLabel ?? effectiveConfig.semanticsLabel,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? effectiveConfig.allowDrawingOutsideViewBox,
      headers: headers,
      placeholderBuilder: effectivePlaceholder != null
          ? (context) => effectivePlaceholder
          : null,
      errorBuilder: effectiveErrorWidget != null
          ? (context, error, stackTrace) => effectiveErrorWidget
          : null,
    );
  }

  /// Render SVG from raw string data
  ///
  /// Example:
  /// ```dart
  /// final svgData = '<svg viewBox="0 0 24 24">...</svg>';
  /// SvgHelper.fromString(
  ///   svgData,
  ///   width: 48,
  ///   height: 48,
  ///   color: Colors.blue,
  /// )
  /// ```
  static Widget fromString(
    String svgString, {
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? allowDrawingOutsideViewBox,
    SvgConfig? config,
  }) {
    final effectiveConfig = config ?? SvgConfig.defaultConfig;

    return SvgPicture.string(
      svgString,
      width: width ?? effectiveConfig.width,
      height: height ?? effectiveConfig.height,
      colorFilter: _buildColorFilter(color ?? effectiveConfig.color),
      fit: fit ?? effectiveConfig.fit,
      alignment: alignment ?? effectiveConfig.alignment,
      semanticsLabel: semanticsLabel ?? effectiveConfig.semanticsLabel,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? effectiveConfig.allowDrawingOutsideViewBox,
    );
  }

  /// Load SVG from a platform [file] object.
  ///
  /// Pass a `dart:io` [File] on VM platforms. On web, `SvgPicture.file` is
  /// unsupported — prefer [fromAsset] / [fromNetwork] / [fromString].
  ///
  /// Example:
  /// ```dart
  /// SvgHelper.fromFile(
  ///   File('/path/to/icon.svg'),
  ///   width: 32,
  ///   height: 32,
  /// )
  /// ```
  static Widget fromFile(
    dynamic file, {
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    Alignment? alignment,
    String? semanticsLabel,
    bool? allowDrawingOutsideViewBox,
    SvgConfig? config,
  }) {
    final effectiveConfig = config ?? SvgConfig.defaultConfig;

    return SvgPicture.file(
      file,
      width: width ?? effectiveConfig.width,
      height: height ?? effectiveConfig.height,
      colorFilter: _buildColorFilter(color ?? effectiveConfig.color),
      fit: fit ?? effectiveConfig.fit,
      alignment: alignment ?? effectiveConfig.alignment,
      semanticsLabel: semanticsLabel ?? effectiveConfig.semanticsLabel,
      allowDrawingOutsideViewBox:
          allowDrawingOutsideViewBox ?? effectiveConfig.allowDrawingOutsideViewBox,
    );
  }

  /// Create an icon-sized SVG from asset
  ///
  /// Convenience method for creating icons with standard sizing
  ///
  /// Example:
  /// ```dart
  /// SvgHelper.icon('assets/icons/home.svg', color: Colors.blue)
  /// SvgHelper.icon('assets/icons/settings.svg', size: 32)
  /// ```
  static Widget icon(
    String assetName, {
    double size = 24,
    Color? color,
    String? semanticsLabel,
    String? package,
  }) {
    return fromAsset(
      assetName,
      width: size,
      height: size,
      color: color,
      semanticsLabel: semanticsLabel,
      package: package,
    );
  }

  /// Create a themed icon that uses the current IconTheme color
  ///
  /// Example:
  /// ```dart
  /// SvgHelper.themedIcon(context, 'assets/icons/home.svg')
  /// ```
  static Widget themedIcon(
    BuildContext context,
    String assetName, {
    double? size,
    String? semanticsLabel,
    String? package,
  }) {
    final iconTheme = IconTheme.of(context);
    return icon(
      assetName,
      size: size ?? iconTheme.size ?? 24,
      color: iconTheme.color,
      semanticsLabel: semanticsLabel,
      package: package,
    );
  }
}
