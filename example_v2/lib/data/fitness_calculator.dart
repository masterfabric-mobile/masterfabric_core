import 'models/body_profile.dart';
import 'models/burn_entry.dart';
import 'models/coach_settings.dart';
import 'models/food_entry.dart';

class DaySummary {
  const DaySummary({
    required this.eaten,
    required this.burned,
    required this.goal,
    required this.waterMl,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.entries,
    required this.burns,
    required this.warnings,
  });

  final int eaten;
  final int burned;
  final int goal;
  final int waterMl;
  final int protein;
  final int carbs;
  final int fat;
  final List<FoodEntry> entries;
  final List<BurnEntry> burns;
  final List<String> warnings;

  int get remaining => goal - eaten + burned;
  double get progress {
    if (goal <= 0) return 0;
    return (eaten / goal).clamp(0.0, 1.4);
  }
}

/// Mifflin–St Jeor + activity multipliers — kept intentionally simple.
abstract final class FitnessCalculator {
  static double bmi(BodyProfile p) {
    final m = p.heightCm / 100;
    if (m <= 0) return 0;
    return p.weightKg / (m * m);
  }

  static String bmiLabel(double value) {
    if (value <= 0) return '—';
    if (value < 18.5) return 'Under';
    if (value < 25) return 'Steady';
    if (value < 30) return 'High';
    return 'Alert';
  }

  static double bmr(BodyProfile p) {
    final base = (10 * p.weightKg) + (6.25 * p.heightCm) - (5 * p.age);
    return p.sex == Sex.male ? base + 5 : base - 161;
  }

  static double activityFactor(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.light => 1.375,
      ActivityLevel.moderate => 1.55,
      ActivityLevel.active => 1.725,
      ActivityLevel.veryActive => 1.9,
    };
  }

  /// Body-type multiplier applied on top of activity × BMR.
  static double bodyTypeFactor(BodyType type) {
    return switch (type) {
      BodyType.ectomorph => 1.06,
      BodyType.mesomorph => 1.00,
      BodyType.endomorph => 0.94,
      BodyType.athletic => 1.04,
      BodyType.soft => 0.97,
    };
  }

  static int tdee(BodyProfile p) =>
      (bmr(p) * activityFactor(p.activity) * bodyTypeFactor(p.bodyType))
          .round();

  static int suggestedGoal(BodyProfile p) {
    if (p.goalCalories != null && p.goalCalories! > 0) {
      return p.goalCalories!;
    }
    final base = tdee(p);
    return switch (p.goal) {
      FitnessGoal.lose => base - 300,
      FitnessGoal.gain => base + 250,
      FitnessGoal.recomp => base - 100,
      FitnessGoal.maintain => base,
    };
  }

  static String bodyTypeLabel(BodyType type) {
    return switch (type) {
      BodyType.ectomorph => 'Ectomorph',
      BodyType.mesomorph => 'Mesomorph',
      BodyType.endomorph => 'Endomorph',
      BodyType.athletic => 'Athletic',
      BodyType.soft => 'Soft average',
    };
  }

  static String bodyTypeCaption(BodyType type) {
    return switch (type) {
      BodyType.ectomorph => 'Lean frame · higher burn',
      BodyType.mesomorph => 'Balanced build · steady',
      BodyType.endomorph => 'Stores easier · tighter goal',
      BodyType.athletic => 'Muscular · slightly higher TDEE',
      BodyType.soft => 'Softer midsection · mild cut',
    };
  }

  static DaySummary summarize({
    required BodyProfile profile,
    required List<FoodEntry> foods,
    required List<BurnEntry> burns,
    required CoachSettings settings,
    required DateTime day,
  }) {
    final dayFoods = foods.where((e) => _sameDay(e.loggedAt, day)).toList();
    final dayBurns = burns.where((e) => _sameDay(e.loggedAt, day)).toList();

    final eaten = dayFoods.fold<int>(0, (s, e) => s + e.calories);
    final burned = dayBurns.fold<int>(0, (s, e) => s + e.calories);
    final water = dayFoods
        .where((e) => e.kind == MealKind.drink)
        .fold<int>(0, (s, e) => s + e.ml);
    final protein = dayFoods.fold<int>(0, (s, e) => s + e.protein);
    final carbs = dayFoods.fold<int>(0, (s, e) => s + e.carbs);
    final fat = dayFoods.fold<int>(0, (s, e) => s + e.fat);
    final goal = suggestedGoal(profile);

    final warnings = <String>[];
    final remaining = goal - eaten + burned;

    if (settings.warnOverGoal && remaining < -150) {
      warnings.add('Over goal by ${-remaining} kcal. Soften the next meal.');
    }
    if (settings.warnUnderGoal &&
        eaten < (goal * 0.45) &&
        DateTime.now().hour >= 16 &&
        _sameDay(DateTime.now(), day)) {
      warnings.add('Fuel is low for the day. Add a balanced meal.');
    }
    if (settings.warnLowWater && water < (profile.waterGoalMl * 0.4)) {
      warnings.add('Water under halfway. Sip 250 ml now.');
    }
    if (dayFoods.isEmpty && DateTime.now().hour >= 11 && _sameDay(DateTime.now(), day)) {
      warnings.add('No food logged yet. Quick-add keeps coaching honest.');
    }
    if (dayBurns.isEmpty &&
        profile.activity.index >= ActivityLevel.active.index &&
        DateTime.now().hour >= 18 &&
        _sameDay(DateTime.now(), day)) {
      warnings.add('Active profile, no burn logged. Capture a walk.');
    }

    dayFoods.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    dayBurns.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    return DaySummary(
      eaten: eaten,
      burned: burned,
      goal: goal,
      waterMl: water,
      protein: protein,
      carbs: carbs,
      fat: fat,
      entries: dayFoods,
      burns: dayBurns,
      warnings: warnings,
    );
  }

  static List<String> coachTips({
    required BodyProfile profile,
    required DaySummary today,
  }) {
    final tips = <String>[];
    final bmiValue = bmi(profile);

    tips.add(
      'Target ${today.goal} kcal today. Net left: ${today.remaining} kcal.',
    );

    if (bmiValue > 0 && bmiValue < 18.5) {
      tips.add('BMI reads light. Prioritize protein-dense meals.');
    } else if (bmiValue >= 25) {
      tips.add('Keep dinners earlier and walk after meals.');
    } else {
      tips.add('BMI is in a steady band. Protect sleep and steps.');
    }

    if (today.protein < 60) {
      tips.add('Protein is light (~${today.protein}g). Aim near body-kg grams.');
    } else {
      tips.add('Protein looks solid at ${today.protein}g.');
    }

    if (today.waterMl < profile.waterGoalMl) {
      tips.add(
        'Water ${today.waterMl}/${profile.waterGoalMl} ml. Finish before night.',
      );
    }

    if (today.burned == 0) {
      tips.add('A 20-minute brisk walk ~100 kcal keeps the ring honest.');
    } else {
      tips.add('Burn logged: ${today.burned} kcal. Nice pace.');
    }

    tips.add(
      'BMR ~${bmr(profile).round()} · TDEE ~${tdee(profile)} based on your body.',
    );

    return tips;
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
