import 'package:equatable/equatable.dart';

import '../../../data/fitness_calculator.dart';
import '../../../data/models/body_profile.dart';

class TodayState extends Equatable {
  const TodayState({
    this.loading = true,
    this.summary,
    this.profile = const BodyProfile(),
  });

  final bool loading;
  final DaySummary? summary;
  final BodyProfile profile;

  TodayState copyWith({
    bool? loading,
    DaySummary? summary,
    BodyProfile? profile,
  }) {
    return TodayState(
      loading: loading ?? this.loading,
      summary: summary ?? this.summary,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [loading, summary, profile];
}
