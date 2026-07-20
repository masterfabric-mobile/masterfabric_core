import 'package:masterfabric_core/src/helper/security/url_security.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

/// Helper class for launching URLs and external applications
class UrlLauncherHelper {
  /// Launch a URL after scheme allowlist validation.
  ///
  /// By default `http` is rejected unless [allowInsecureHttp] is true.
  static Future<bool> launchUrl(
    String url, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
    Set<String> allowedSchemes = UrlSecurity.defaultLaunchSchemes,
    bool allowInsecureHttp = false,
    Set<String>? allowedHosts,
  }) async {
    if (!UrlSecurity.isAllowedUrl(
      url,
      allowedSchemes: allowedSchemes,
      allowInsecureHttp: allowInsecureHttp,
      allowedHosts: allowedHosts,
    )) {
      return false;
    }
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      return await launcher.launchUrl(uri, mode: mode);
    }
    return false;
  }

  /// Launch a phone number
  static Future<bool> launchPhone(String phoneNumber) async {
    final sanitized = phoneNumber.replaceAll(RegExp(r'[^\d+\-() ]'), '');
    return launchUrl(
      'tel:$sanitized',
      allowedSchemes: const {'tel'},
    );
  }

  /// Launch an email
  static Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final buffer = StringBuffer('mailto:$email');
    final params = <String>[];
    if (subject != null) {
      params.add('subject=${Uri.encodeComponent(subject)}');
    }
    if (body != null) {
      params.add('body=${Uri.encodeComponent(body)}');
    }
    if (params.isNotEmpty) {
      buffer.write('?${params.join('&')}');
    }
    return launchUrl(
      buffer.toString(),
      allowedSchemes: const {'mailto'},
    );
  }

  /// Launch SMS
  static Future<bool> launchSms(String phoneNumber, {String? body}) async {
    final sanitized = phoneNumber.replaceAll(RegExp(r'[^\d+\-() ]'), '');
    final url = body != null
        ? 'sms:$sanitized?body=${Uri.encodeComponent(body)}'
        : 'sms:$sanitized';
    return launchUrl(url, allowedSchemes: const {'sms'});
  }

  /// Check if URL can be launched and passes allowlist
  static Future<bool> canLaunch(
    String url, {
    Set<String> allowedSchemes = UrlSecurity.defaultLaunchSchemes,
    bool allowInsecureHttp = false,
  }) async {
    if (!UrlSecurity.isAllowedUrl(
      url,
      allowedSchemes: allowedSchemes,
      allowInsecureHttp: allowInsecureHttp,
    )) {
      return false;
    }
    final uri = Uri.parse(url);
    return await launcher.canLaunchUrl(uri);
  }
}
