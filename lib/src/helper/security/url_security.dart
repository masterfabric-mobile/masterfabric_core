/// Shared URL / filename hardening used by download, launcher, and WebView.
abstract final class UrlSecurity {
  /// Schemes allowed for general external launch.
  static const Set<String> defaultLaunchSchemes = {
    'https',
    'http',
    'mailto',
    'tel',
    'sms',
    'market',
    'itms',
    'itms-apps',
  };

  /// Schemes allowed inside the in-app WebView by default.
  static const Set<String> defaultWebViewSchemes = {
    'https',
    'about',
    'data',
  };

  /// Returns true when [url] uses an allowed scheme (and host for http/https).
  static bool isAllowedUrl(
    String url, {
    Set<String> allowedSchemes = defaultLaunchSchemes,
    bool allowInsecureHttp = false,
    Set<String>? allowedHosts,
  }) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme) return false;

    final scheme = uri.scheme.toLowerCase();
    if (!allowedSchemes.contains(scheme)) return false;

    if (scheme == 'http' && !allowInsecureHttp) return false;

    if (scheme == 'https' || scheme == 'http') {
      if (uri.host.isEmpty) return false;
      if (allowedHosts != null &&
          allowedHosts.isNotEmpty &&
          !allowedHosts.contains(uri.host.toLowerCase())) {
        return false;
      }
    }
    return true;
  }

  /// HTTPS-only check for network downloads / force-update style calls.
  static bool isHttpsUrl(String url) =>
      isAllowedUrl(url, allowedSchemes: const {'https'});

  /// Strips directories and rejects traversal / empty names.
  static String sanitizeFileName(String fileName) {
    final normalized = fileName.replaceAll('\\', '/').trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(fileName, 'fileName', 'Empty file name');
    }
    if (normalized.contains('..') || normalized.contains('\x00')) {
      throw ArgumentError.value(fileName, 'fileName', 'Unsafe file name');
    }
    final parts =
        normalized.split('/').where((p) => p.isNotEmpty).toList(growable: false);
    if (parts.isEmpty || parts.last == '.') {
      throw ArgumentError.value(fileName, 'fileName', 'Unsafe file name');
    }
    return parts.last;
  }

  /// Resolves [fileName] under [directory] and ensures it stays inside.
  static String resolveSafePath(String directory, String fileName) {
    final safeName = sanitizeFileName(fileName);
    final dir = directory.endsWith('/') ? directory.substring(0, directory.length - 1) : directory;
    final resolved = '$dir/$safeName';
    // Reject if basename resolution somehow escaped (defense in depth).
    if (!resolved.startsWith('$dir/')) {
      throw ArgumentError('Resolved path escapes target directory');
    }
    return resolved;
  }
}
