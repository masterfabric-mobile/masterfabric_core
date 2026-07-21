import 'package:equatable/equatable.dart';

import '../../../data/models/body_profile.dart';
import '../../../data/models/weight_entry.dart';

class BodyState extends Equatable {
  const BodyState({
    this.loading = true,
    this.profile = const BodyProfile(),
    this.bmi = 0,
    this.bmr = 0,
    this.tdee = 0,
    this.goal = 0,
    this.weights = const [],
  });

  final bool loading;
  final BodyProfile profile;
  final double bmi;
  final double bmr;
  final int tdee;
  final int goal;
  final List<WeightEntry> weights;

  double? get deltaKg {
    if (weights.length < 2) return null;
    return weights.last.weightKg - weights.first.weightKg;
  }

  BodyState copyWith({
    bool? loading,
    BodyProfile? profile,
    double? bmi,
    double? bmr,
    int? tdee,
    int? goal,
    List<WeightEntry>? weights,
  }) {
    return BodyState(
      loading: loading ?? this.loading,
      profile: profile ?? this.profile,
      bmi: bmi ?? this.bmi,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      goal: goal ?? this.goal,
      weights: weights ?? this.weights,
    );
  }

  @override
  List<Object?> get props =>
      [loading, profile, bmi, bmr, tdee, goal, weights];
}
