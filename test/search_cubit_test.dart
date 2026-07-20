import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:masterfabric_core/src/helper/search/search_provider.dart';
import 'package:masterfabric_core/src/views/search/cubit/search_cubit.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
    GetIt.I.registerSingleton<SearchProvider>(
      DefaultSearchProvider(catalog: const ['Alpha', 'Beta', 'Gamma']),
    );
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('performSearch returns provider matches', () async {
    final cubit = SearchCubit();
    await cubit.performSearch('a');
    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.results.map((e) => e.toString()), contains('Alpha'));
    await cubit.close();
  });

  test('updateQuery clears results for empty input', () async {
    final cubit = SearchCubit();
    await cubit.performSearch('Beta');
    cubit.updateQuery('');
    expect(cubit.state.results, isEmpty);
    await cubit.close();
  });
}
