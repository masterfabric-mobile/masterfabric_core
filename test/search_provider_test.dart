import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/search/search_provider.dart';

void main() {
  group('DefaultSearchProvider', () {
    late DefaultSearchProvider provider;

    setUp(() {
      provider = DefaultSearchProvider(
        catalog: const ['Account', 'Auth', 'Network Info'],
      );
    });

    test('returns matching items case-insensitively', () async {
      final results = await provider.search('acc');
      expect(results, ['Account']);
    });

    test('returns empty for blank query', () async {
      expect(await provider.search('   '), isEmpty);
    });

    test('returns multiple matches', () async {
      final results = await provider.search('a');
      expect(results, containsAll(['Account', 'Auth']));
    });
  });
}
