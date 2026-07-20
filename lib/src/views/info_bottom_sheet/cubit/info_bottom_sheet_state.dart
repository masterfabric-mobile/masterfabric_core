import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/src/models/info_models.dart';

/// ℹ️ **Info Bottom Sheet State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Info Bottom Sheet Cubit
///
/// {@category States}
/// {@subCategory InfoBottomSheetState}

/// ℹ️ Info bottom sheet state class
class InfoBottomSheetState extends Equatable {
  final InfoModel? infoModel;
  final bool isVisible;

  const InfoBottomSheetState({
    this.infoModel,
    this.isVisible = false,
  });

  /// Create a copy of this state with some fields changed
  InfoBottomSheetState copyWith({
    InfoModel? infoModel,
    bool? isVisible,
  }) {
    return InfoBottomSheetState(
      infoModel: infoModel ?? this.infoModel,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [infoModel, isVisible];

  @override
  String toString() {
    return 'InfoBottomSheetState('
        'isVisible: $isVisible, '
        'hasModel: ${infoModel != null}'
        ')';
  }
}
