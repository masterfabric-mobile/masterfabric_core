import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'skeleton_demo_state.dart';

/// Cubit for skeleton demo
@injectable
class SkeletonDemoCubit extends BaseViewModelCubit<SkeletonDemoState> {
  SkeletonDemoCubit() : super(const SkeletonDemoState.initial());

  /// Change animation type
  void setAnimationType(SkeletonAnimationType type) {
    stateChanger(state.copyWith(animationType: type));
  }

  /// Change tab
  void setTabIndex(int index) {
    stateChanger(state.copyWith(tabIndex: index));
  }

  /// Toggle dark theme
  void toggleDarkTheme() {
    stateChanger(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }

  /// Change base color
  void setBaseColorIndex(int index) {
    stateChanger(state.copyWith(baseColorIndex: index));
  }

  /// Change highlight color
  void setHighlightColorIndex(int index) {
    stateChanger(state.copyWith(highlightColorIndex: index));
  }

  /// Change animation speed
  void setSpeedMultiplier(double speed) {
    stateChanger(state.copyWith(speedMultiplier: speed));
  }

  /// Reset to defaults
  void reset() {
    stateChanger(const SkeletonDemoState.initial());
  }
}
