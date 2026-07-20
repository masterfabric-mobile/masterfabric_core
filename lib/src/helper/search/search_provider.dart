/// Pluggable search backend for [SearchCubit].
///
/// Host apps can register a custom implementation with GetIt:
/// `getIt.registerSingleton<SearchProvider>(MyApiSearchProvider());`
abstract class SearchProvider {
  Future<List<Object>> search(String query);
}

/// Default in-memory catalog search used when no host provider is registered.
class DefaultSearchProvider implements SearchProvider {
  DefaultSearchProvider({List<String>? catalog})
      : _catalog = catalog ??
            const [
              'Account',
              'Auth',
              'Onboarding',
              'Permissions',
              'Splash',
              'Settings',
              'Network Info',
              'Force Update',
              'Skeleton',
              'Push Notifications',
            ];

  final List<String> _catalog;

  @override
  Future<List<Object>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return _catalog
        .where((item) => item.toLowerCase().contains(q))
        .cast<Object>()
        .toList(growable: false);
  }
}
