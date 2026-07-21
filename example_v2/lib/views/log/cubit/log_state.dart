import 'package:equatable/equatable.dart';

import '../../../data/fitness_calculator.dart';
import '../../../data/models/burn_entry.dart';
import '../../../data/models/food_entry.dart';

class LogState extends Equatable {
  const LogState({
    this.loading = true,
    this.summary,
    this.foods = const [],
    this.burns = const [],
    this.filter = MealKind.breakfast,
    this.selectedDay,
    this.daysWithLogs = const {},
  });

  final bool loading;
  final DaySummary? summary;
  final List<FoodEntry> foods;
  final List<BurnEntry> burns;
  final MealKind filter;
  final DateTime? selectedDay;
  final Set<DateTime> daysWithLogs;

  DateTime get day {
    final d = selectedDay ?? DateTime.now();
    return DateTime(d.year, d.month, d.day);
  }

  LogState copyWith({
    bool? loading,
    DaySummary? summary,
    List<FoodEntry>? foods,
    List<BurnEntry>? burns,
    MealKind? filter,
    DateTime? selectedDay,
    Set<DateTime>? daysWithLogs,
  }) {
    return LogState(
      loading: loading ?? this.loading,
      summary: summary ?? this.summary,
      foods: foods ?? this.foods,
      burns: burns ?? this.burns,
      filter: filter ?? this.filter,
      selectedDay: selectedDay ?? this.selectedDay,
      daysWithLogs: daysWithLogs ?? this.daysWithLogs,
    );
  }

  @override
  List<Object?> get props =>
      [loading, summary, foods, burns, filter, selectedDay, daysWithLogs];
}
