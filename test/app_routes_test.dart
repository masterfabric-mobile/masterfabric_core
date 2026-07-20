import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/views/routes.dart';

void main() {
  test('AppRoutes exposes previously missing view paths', () {
    expect(AppRoutes.home, '/home');
    expect(AppRoutes.empty, '/empty');
    expect(AppRoutes.error, '/error');
    expect(AppRoutes.loading, '/loading');
    expect(AppRoutes.info, '/info');
    expect(AppRoutes.counter, '/counter');
  });

  test('createRouter builds without throwing', () {
    final router = AppRoutes.createRouter();
    expect(router.configuration.routes, isNotEmpty);
  });
}
