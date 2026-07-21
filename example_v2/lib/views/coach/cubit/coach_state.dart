import 'package:equatable/equatable.dart';

import '../../../data/fitness_calculator.dart';
import '../../../data/models/coach_settings.dart';
import '../../../data/models/journal_entry.dart';

class CoachState extends Equatable {
  const CoachState({
    this.loading = true,
    this.tips = const [],
    this.summary,
    this.settings = const CoachSettings(),
    this.helpIndex = 0,
    this.isPhysicalDevice = false,
    this.contextText = '',
    this.journal = const [],
  });

  final bool loading;
  final List<String> tips;
  final DaySummary? summary;
  final CoachSettings settings;
  final int helpIndex;
  final bool isPhysicalDevice;
  final String contextText;
  final List<JournalEntry> journal;

  CoachState copyWith({
    bool? loading,
    List<String>? tips,
    DaySummary? summary,
    CoachSettings? settings,
    int? helpIndex,
    bool? isPhysicalDevice,
    String? contextText,
    List<JournalEntry>? journal,
  }) {
    return CoachState(
      loading: loading ?? this.loading,
      tips: tips ?? this.tips,
      summary: summary ?? this.summary,
      settings: settings ?? this.settings,
      helpIndex: helpIndex ?? this.helpIndex,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      contextText: contextText ?? this.contextText,
      journal: journal ?? this.journal,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        tips,
        summary,
        settings,
        helpIndex,
        isPhysicalDevice,
        contextText,
        journal,
      ];
}
