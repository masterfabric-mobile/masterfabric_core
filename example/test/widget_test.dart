import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core_example/app/routes.dart';

void main() {
  test('example AppRoutes expose core showcase paths', () {
    expect(AppRoutes.home, '/home');
    expect(AppRoutes.helpersHub, '/helpers');
    expect(AppRoutes.auth, '/auth');
    expect(AppRoutes.settings, '/settings');
  });
}
