import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/src/models/empty_view_models.dart';

/// 📭 **Empty View State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Empty View Cubit
///
/// {@category States}
/// {@subCategory EmptyViewState}

/// 📭 Empty view state class
class EmptyViewState extends Equatable {
  final EmptyViewModel? emptyViewModel;

  const EmptyViewState({this.emptyViewModel});

  /// Create a copy of this state with some fields changed
  EmptyViewState copyWith({EmptyViewModel? emptyViewModel}) {
    return EmptyViewState(
      emptyViewModel: emptyViewModel ?? this.emptyViewModel,
    );
  }

  @override
  List<Object?> get props => [emptyViewModel];

  @override
  String toString() {
    return 'EmptyViewState('
        'hasViewModel: ${emptyViewModel != null}'
        ')';
  }
}
