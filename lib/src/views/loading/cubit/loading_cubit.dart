import 'package:masterfabric_core/src/base/base_view_model_cubit.dart';
import 'package:masterfabric_core/src/models/loading_models.dart';
import 'package:masterfabric_core/src/views/loading/cubit/loading_state.dart';
import 'package:injectable/injectable.dart';

/// ⏳ **Loading Cubit**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// Cubit that manages loading operations with MVVM pattern
///
/// {@category ViewModels}
/// {@subCategory LoadingCubit}

@injectable
class LoadingCubit extends BaseViewModelCubit<LoadingState> {
  LoadingCubit() : super(const LoadingState());

  void showLoading({String? message, double? progress}) {
    stateChanger(state.copyWith(
      isLoading: true,
      loadingModel: LoadingModel(
        message: message,
        progress: progress,
      ),
    ));
  }

  void hideLoading() {
    stateChanger(state.copyWith(isLoading: false, loadingModel: null));
  }
}
