import 'package:equatable/equatable.dart';

import 'app_icon_style.dart';

enum Sex { female, male }

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}

enum FitnessGoal { lose, maintain, gain, recomp }

/// Somatotype-style body types used in TDEE tuning.
enum BodyType {
  ectomorph,
  mesomorph,
  endomorph,
  athletic,
  soft,
}

class BodyProfile extends Equatable {
  const BodyProfile({
    this.displayName = '',
    this.heightCm = 170,
    this.weightKg = 70,
    this.age = 28,
    this.sex = Sex.female,
    this.activity = ActivityLevel.moderate,
    this.goal = FitnessGoal.maintain,
    this.bodyType = BodyType.mesomorph,
    this.goalCalories,
    this.waterGoalMl = 2000,
    this.onboardingComplete = false,
    this.permissionsComplete = false,
    this.appIcon = AppIconStyle.classic,
  });

  final String displayName;
  final double heightCm;
  final double weightKg;
  final int age;
  final Sex sex;
  final ActivityLevel activity;
  final FitnessGoal goal;
  final BodyType bodyType;
  final int? goalCalories;
  final int waterGoalMl;
  final bool onboardingComplete;

  /// Second onboarding queue: notifications / location / fitness access.
  final bool permissionsComplete;

  /// Home-screen icon theme. Defaults to classic woman.
  final AppIconStyle appIcon;

  bool get isComplete =>
      onboardingComplete &&
      displayName.trim().isNotEmpty &&
      heightCm > 0 &&
      weightKg > 0 &&
      age > 0;

  String get initials {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  BodyProfile copyWith({
    String? displayName,
    double? heightCm,
    double? weightKg,
    int? age,
    Sex? sex,
    ActivityLevel? activity,
    FitnessGoal? goal,
    BodyType? bodyType,
    int? goalCalories,
    bool clearGoalCalories = false,
    int? waterGoalMl,
    bool? onboardingComplete,
    bool? permissionsComplete,
    AppIconStyle? appIcon,
  }) {
    return BodyProfile(
      displayName: displayName ?? this.displayName,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      activity: activity ?? this.activity,
      goal: goal ?? this.goal,
      bodyType: bodyType ?? this.bodyType,
      goalCalories:
          clearGoalCalories ? null : (goalCalories ?? this.goalCalories),
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      permissionsComplete: permissionsComplete ?? this.permissionsComplete,
      appIcon: appIcon ?? this.appIcon,
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'age': age,
        'sex': sex.name,
        'activity': activity.name,
        'goal': goal.name,
        'bodyType': bodyType.name,
        'goalCalories': goalCalories,
        'waterGoalMl': waterGoalMl,
        'onboardingComplete': onboardingComplete,
        'permissionsComplete': permissionsComplete,
        'appIcon': appIcon.name,
      };

  factory BodyProfile.fromJson(Map<String, dynamic> json) {
    return BodyProfile(
      displayName: json['displayName'] as String? ?? '',
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 170,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 70,
      age: (json['age'] as num?)?.toInt() ?? 28,
      sex: Sex.values.firstWhere(
        (e) => e.name == json['sex'],
        orElse: () => Sex.female,
      ),
      activity: ActivityLevel.values.firstWhere(
        (e) => e.name == json['activity'],
        orElse: () => ActivityLevel.moderate,
      ),
      goal: FitnessGoal.values.firstWhere(
        (e) => e.name == json['goal'],
        orElse: () => FitnessGoal.maintain,
      ),
      bodyType: BodyType.values.firstWhere(
        (e) => e.name == json['bodyType'],
        orElse: () => BodyType.mesomorph,
      ),
      goalCalories: (json['goalCalories'] as num?)?.toInt(),
      waterGoalMl: (json['waterGoalMl'] as num?)?.toInt() ?? 2000,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      permissionsComplete: json['permissionsComplete'] as bool? ?? false,
      appIcon: AppIconStyleX.fromName(json['appIcon'] as String?),
    );
  }

  @override
  List<Object?> get props => [
        displayName,
        heightCm,
        weightKg,
        age,
        sex,
        activity,
        goal,
        bodyType,
        goalCalories,
        waterGoalMl,
        onboardingComplete,
        permissionsComplete,
        appIcon,
      ];
}
