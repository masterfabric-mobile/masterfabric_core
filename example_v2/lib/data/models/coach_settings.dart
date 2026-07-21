import 'package:equatable/equatable.dart';

class CoachSettings extends Equatable {
  const CoachSettings({
    this.remindersEnabled = true,
    this.warnOverGoal = true,
    this.warnUnderGoal = true,
    this.warnLowWater = true,
    this.mealReminderHour = 12,
    this.waterReminderHour = 16,
  });

  final bool remindersEnabled;
  final bool warnOverGoal;
  final bool warnUnderGoal;
  final bool warnLowWater;
  final int mealReminderHour;
  final int waterReminderHour;

  CoachSettings copyWith({
    bool? remindersEnabled,
    bool? warnOverGoal,
    bool? warnUnderGoal,
    bool? warnLowWater,
    int? mealReminderHour,
    int? waterReminderHour,
  }) {
    return CoachSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      warnOverGoal: warnOverGoal ?? this.warnOverGoal,
      warnUnderGoal: warnUnderGoal ?? this.warnUnderGoal,
      warnLowWater: warnLowWater ?? this.warnLowWater,
      mealReminderHour: mealReminderHour ?? this.mealReminderHour,
      waterReminderHour: waterReminderHour ?? this.waterReminderHour,
    );
  }

  Map<String, dynamic> toJson() => {
        'remindersEnabled': remindersEnabled,
        'warnOverGoal': warnOverGoal,
        'warnUnderGoal': warnUnderGoal,
        'warnLowWater': warnLowWater,
        'mealReminderHour': mealReminderHour,
        'waterReminderHour': waterReminderHour,
      };

  factory CoachSettings.fromJson(Map<String, dynamic> json) {
    return CoachSettings(
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      warnOverGoal: json['warnOverGoal'] as bool? ?? true,
      warnUnderGoal: json['warnUnderGoal'] as bool? ?? true,
      warnLowWater: json['warnLowWater'] as bool? ?? true,
      mealReminderHour: (json['mealReminderHour'] as num?)?.toInt() ?? 12,
      waterReminderHour: (json['waterReminderHour'] as num?)?.toInt() ?? 16,
    );
  }

  @override
  List<Object?> get props => [
        remindersEnabled,
        warnOverGoal,
        warnUnderGoal,
        warnLowWater,
        mealReminderHour,
        waterReminderHour,
      ];
}
