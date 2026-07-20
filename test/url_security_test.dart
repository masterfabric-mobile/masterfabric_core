import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/security/url_security.dart';

void main() {
  group('UrlSecurity', () {
    test('allows https and rejects bare http by default', () {
      expect(UrlSecurity.isHttpsUrl('https://example.com/a'), isTrue);
      expect(UrlSecurity.isAllowedUrl('https://example.com'), isTrue);
      expect(UrlSecurity.isAllowedUrl('http://example.com'), isFalse);
      expect(
        UrlSecurity.isAllowedUrl('http://example.com', allowInsecureHttp: true),
        isTrue,
      );
    });

    test('rejects dangerous schemes', () {
      expect(UrlSecurity.isAllowedUrl('javascript:alert(1)'), isFalse);
      expect(UrlSecurity.isAllowedUrl('file:///etc/passwd'), isFalse);
    });

    test('sanitizes file names and blocks traversal', () {
      expect(UrlSecurity.sanitizeFileName('report.pdf'), 'report.pdf');
      expect(UrlSecurity.sanitizeFileName('a/b/c.txt'), 'c.txt');
      expect(() => UrlSecurity.sanitizeFileName('../evil'), throwsArgumentError);
      expect(() => UrlSecurity.sanitizeFileName('..'), throwsArgumentError);
    });

    test('resolveSafePath stays under directory', () {
      expect(
        UrlSecurity.resolveSafePath('/data/app', 'file.bin'),
        '/data/app/file.bin',
      );
    });
  });
}
