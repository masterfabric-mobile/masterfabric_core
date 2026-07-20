import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/helper/search/search_provider.dart';
import 'package:masterfabric_core/src/views/search/cubit/search_state.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Search Cubit — delegates to a [SearchProvider] (default catalog or host).
@injectable
class SearchCubit extends BaseViewModelCubit<SearchState> {
  SearchCubit()
      : _searchProvider = GetIt.I.isRegistered<SearchProvider>()
            ? GetIt.I<SearchProvider>()
            : DefaultSearchProvider(),
        super(const SearchState());

  final SearchProvider _searchProvider;

  void updateQuery(String query) {
    stateChanger(state.copyWith(query: query, errorMessage: null));
    if (query.trim().isNotEmpty) {
      performSearch(query);
    } else {
      stateChanger(state.copyWith(results: []));
    }
  }

  Future<void> performSearch(String query) async {
    stateChanger(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final results = await _searchProvider.search(query);
      stateChanger(state.copyWith(
        isLoading: false,
        results: results,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        results: [],
        errorMessage: e.toString(),
      ));
    }
  }
}
