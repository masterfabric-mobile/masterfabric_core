import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'home_state.dart';

/// Home Cubit - Manages home view state
@injectable
class HomeCubit extends BaseViewModelCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// Initialize home data
  Future<void> loadData() async {
    // No loading state needed - view is static content
    // Can be extended for dynamic content in the future
  }
}
