import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/storage_keys.dart';

void main() {
  group('StorageKeys', () {
    test('legacy map covers onboarding and tracking', () {
      expect(
        StorageKeys.legacyToCurrent['osmea_onboarding_seen'],
        StorageKeys.onboardingSeen,
      );
      expect(
        StorageKeys.legacyToCurrent['osmea_tracking_authorized'],
        StorageKeys.trackingAuthorized,
      );
    });

    test('all mf keys use mf_ prefix', () {
      for (final key in StorageKeys.legacyToCurrent.values) {
        expect(key.startsWith('mf_'), isTrue, reason: key);
      }
    });

    test('legacy keys use osmea_ prefix', () {
      for (final key in StorageKeys.legacyToCurrent.keys) {
        expect(key.startsWith('osmea_'), isTrue, reason: key);
      }
    });
  });
}
