import 'package:equatable/equatable.dart';

/// 🎯 **Onboarding State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Onboarding Cubit
///
/// {@category States}
/// {@subCategory OnboardingState}

/// 🎯 Onboarding state class
class OnboardingState extends Equatable {
  final int currentPage;
  final bool isCompleted;
  final String? navigationTarget;

  const OnboardingState({
    this.currentPage = 0,
    this.isCompleted = false,
    this.navigationTarget,
  });

  /// Create a copy of this state with some fields changed
  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
    String? navigationTarget,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
      navigationTarget: navigationTarget ?? this.navigationTarget,
    );
  }

  @override
  List<Object?> get props => [currentPage, isCompleted, navigationTarget];

  @override
  String toString() {
    return 'OnboardingState('
        'currentPage: $currentPage, '
        'isCompleted: $isCompleted, '
        'navigationTarget: $navigationTarget'
        ')';
  }
}
