///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'resources.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final resources = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$tabs$en tabs = Translations$tabs$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$meals$en meals = Translations$meals$en._(_root);
	late final Translations$activity$en activity = Translations$activity$en._(_root);
	late final Translations$goals$en goals = Translations$goals$en._(_root);
	late final Translations$sex$en sex = Translations$sex$en._(_root);
	late final Translations$today$en today = Translations$today$en._(_root);
	late final Translations$log$en log = Translations$log$en._(_root);
	late final Translations$body$en body = Translations$body$en._(_root);
	late final Translations$coach$en coach = Translations$coach$en._(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en._(_root);
	late final Translations$permissions$en permissions = Translations$permissions$en._(_root);
	late final Translations$profile$en profile = Translations$profile$en._(_root);
	late final Translations$sheets$en sheets = Translations$sheets$en._(_root);
	late final Translations$tips$en tips = Translations$tips$en._(_root);
	late final Translations$empty$en empty = Translations$empty$en._(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => TranslationOverrides.string(_root.$meta, 'common.ok', {}) ?? 'OK';

	/// en: 'Cancel'
	String get cancel => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel';

	/// en: 'Save'
	String get save => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save';

	/// en: 'Delete'
	String get delete => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Delete';

	/// en: 'Edit'
	String get edit => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Edit';

	/// en: 'Close'
	String get close => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Close';

	/// en: 'Back'
	String get back => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back';

	/// en: 'Next'
	String get next => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'Next';

	/// en: 'Continue'
	String get kContinue => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Continue';

	/// en: 'Done'
	String get done => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Done';

	/// en: 'Loading…'
	String get loading => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading…';

	/// en: 'Retry'
	String get retry => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry';

	/// en: 'Refresh'
	String get refresh => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Refresh';

	/// en: 'Not now'
	String get not_now => TranslationOverrides.string(_root.$meta, 'common.not_now', {}) ?? 'Not now';

	/// en: 'Remove'
	String get remove => TranslationOverrides.string(_root.$meta, 'common.remove', {}) ?? 'Remove';

	/// en: 'kcal'
	String get kcal => TranslationOverrides.string(_root.$meta, 'common.kcal', {}) ?? 'kcal';

	/// en: 'ml'
	String get ml => TranslationOverrides.string(_root.$meta, 'common.ml', {}) ?? 'ml';

	/// en: 'cm'
	String get cm => TranslationOverrides.string(_root.$meta, 'common.cm', {}) ?? 'cm';

	/// en: 'kg'
	String get kg => TranslationOverrides.string(_root.$meta, 'common.kg', {}) ?? 'kg';

	/// en: 'On'
	String get on => TranslationOverrides.string(_root.$meta, 'common.on', {}) ?? 'On';

	/// en: 'Off'
	String get off => TranslationOverrides.string(_root.$meta, 'common.off', {}) ?? 'Off';
}

// Path: tabs
class Translations$tabs$en {
	Translations$tabs$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => TranslationOverrides.string(_root.$meta, 'tabs.today', {}) ?? 'Today';

	/// en: 'Log'
	String get log => TranslationOverrides.string(_root.$meta, 'tabs.log', {}) ?? 'Log';

	/// en: 'Body'
	String get body => TranslationOverrides.string(_root.$meta, 'tabs.body', {}) ?? 'Body';

	/// en: 'Coach'
	String get coach => TranslationOverrides.string(_root.$meta, 'tabs.coach', {}) ?? 'Coach';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get language => TranslationOverrides.string(_root.$meta, 'settings.language', {}) ?? 'Language';

	/// en: 'English'
	String get english => TranslationOverrides.string(_root.$meta, 'settings.english', {}) ?? 'English';

	/// en: 'Türkçe'
	String get turkish => TranslationOverrides.string(_root.$meta, 'settings.turkish', {}) ?? 'Türkçe';

	/// en: 'Appearance'
	String get appearance => TranslationOverrides.string(_root.$meta, 'settings.appearance', {}) ?? 'Appearance';

	/// en: 'Light'
	String get theme_light => TranslationOverrides.string(_root.$meta, 'settings.theme_light', {}) ?? 'Light';

	/// en: 'Dark'
	String get theme_dark => TranslationOverrides.string(_root.$meta, 'settings.theme_dark', {}) ?? 'Dark';

	/// en: 'System'
	String get theme_system => TranslationOverrides.string(_root.$meta, 'settings.theme_system', {}) ?? 'System';

	/// en: 'Text size'
	String get font_scale => TranslationOverrides.string(_root.$meta, 'settings.font_scale', {}) ?? 'Text size';
}

// Path: meals
class Translations$meals$en {
	Translations$meals$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Breakfast'
	String get breakfast => TranslationOverrides.string(_root.$meta, 'meals.breakfast', {}) ?? 'Breakfast';

	/// en: 'Lunch'
	String get lunch => TranslationOverrides.string(_root.$meta, 'meals.lunch', {}) ?? 'Lunch';

	/// en: 'Dinner'
	String get dinner => TranslationOverrides.string(_root.$meta, 'meals.dinner', {}) ?? 'Dinner';

	/// en: 'Snack'
	String get snack => TranslationOverrides.string(_root.$meta, 'meals.snack', {}) ?? 'Snack';

	/// en: 'Drink'
	String get drink => TranslationOverrides.string(_root.$meta, 'meals.drink', {}) ?? 'Drink';

	/// en: 'Start the fuel day'
	String get breakfast_caption => TranslationOverrides.string(_root.$meta, 'meals.breakfast_caption', {}) ?? 'Start the fuel day';

	/// en: 'Midday plate'
	String get lunch_caption => TranslationOverrides.string(_root.$meta, 'meals.lunch_caption', {}) ?? 'Midday plate';

	/// en: 'Evening meal'
	String get dinner_caption => TranslationOverrides.string(_root.$meta, 'meals.dinner_caption', {}) ?? 'Evening meal';

	/// en: 'Small top-up'
	String get snack_caption => TranslationOverrides.string(_root.$meta, 'meals.snack_caption', {}) ?? 'Small top-up';

	/// en: 'Hydration & sips'
	String get drink_caption => TranslationOverrides.string(_root.$meta, 'meals.drink_caption', {}) ?? 'Hydration & sips';
}

// Path: activity
class Translations$activity$en {
	Translations$activity$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sedentary'
	String get sedentary => TranslationOverrides.string(_root.$meta, 'activity.sedentary', {}) ?? 'Sedentary';

	/// en: 'Light'
	String get light => TranslationOverrides.string(_root.$meta, 'activity.light', {}) ?? 'Light';

	/// en: 'Moderate'
	String get moderate => TranslationOverrides.string(_root.$meta, 'activity.moderate', {}) ?? 'Moderate';

	/// en: 'Active'
	String get active => TranslationOverrides.string(_root.$meta, 'activity.active', {}) ?? 'Active';

	/// en: 'Very active'
	String get very_active => TranslationOverrides.string(_root.$meta, 'activity.very_active', {}) ?? 'Very active';
}

// Path: goals
class Translations$goals$en {
	Translations$goals$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cut'
	String get lose => TranslationOverrides.string(_root.$meta, 'goals.lose', {}) ?? 'Cut';

	/// en: 'Maintain'
	String get maintain => TranslationOverrides.string(_root.$meta, 'goals.maintain', {}) ?? 'Maintain';

	/// en: 'Bulk'
	String get gain => TranslationOverrides.string(_root.$meta, 'goals.gain', {}) ?? 'Bulk';

	/// en: 'Recomp'
	String get recomp => TranslationOverrides.string(_root.$meta, 'goals.recomp', {}) ?? 'Recomp';
}

// Path: sex
class Translations$sex$en {
	Translations$sex$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Woman'
	String get woman => TranslationOverrides.string(_root.$meta, 'sex.woman', {}) ?? 'Woman';

	/// en: 'Man'
	String get man => TranslationOverrides.string(_root.$meta, 'sex.man', {}) ?? 'Man';
}

// Path: today
class Translations$today$en {
	Translations$today$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Eaten'
	String get eaten => TranslationOverrides.string(_root.$meta, 'today.eaten', {}) ?? 'Eaten';

	/// en: 'Burned'
	String get burned => TranslationOverrides.string(_root.$meta, 'today.burned', {}) ?? 'Burned';

	/// en: 'Water'
	String get water => TranslationOverrides.string(_root.$meta, 'today.water', {}) ?? 'Water';

	/// en: 'kcal remaining · goal $goal'
	String kcal_remaining({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.kcal_remaining', {'goal': goal}) ?? 'kcal remaining · goal ${goal}';

	/// en: 'Add food'
	String get add_food => TranslationOverrides.string(_root.$meta, 'today.add_food', {}) ?? 'Add food';

	/// en: 'Add water'
	String get add_water => TranslationOverrides.string(_root.$meta, 'today.add_water', {}) ?? 'Add water';

	/// en: 'Open coach'
	String get open_coach => TranslationOverrides.string(_root.$meta, 'today.open_coach', {}) ?? 'Open coach';

	/// en: 'Log burn'
	String get log_burn => TranslationOverrides.string(_root.$meta, 'today.log_burn', {}) ?? 'Log burn';

	/// en: 'Nutrition'
	String get nutrition => TranslationOverrides.string(_root.$meta, 'today.nutrition', {}) ?? 'Nutrition';

	/// en: 'Protein, carbs, and fat vs today’s targets'
	String get nutrition_subtitle => TranslationOverrides.string(_root.$meta, 'today.nutrition_subtitle', {}) ?? 'Protein, carbs, and fat vs today’s targets';

	/// en: 'Protein'
	String get protein => TranslationOverrides.string(_root.$meta, 'today.protein', {}) ?? 'Protein';

	/// en: 'Carbs'
	String get carbs => TranslationOverrides.string(_root.$meta, 'today.carbs', {}) ?? 'Carbs';

	/// en: 'Fat'
	String get fat => TranslationOverrides.string(_root.$meta, 'today.fat', {}) ?? 'Fat';

	/// en: 'Alerts'
	String get alerts => TranslationOverrides.string(_root.$meta, 'today.alerts', {}) ?? 'Alerts';

	/// en: 'All clear'
	String get all_clear => TranslationOverrides.string(_root.$meta, 'today.all_clear', {}) ?? 'All clear';

	/// en: 'Needs a look'
	String get needs_look => TranslationOverrides.string(_root.$meta, 'today.needs_look', {}) ?? 'Needs a look';

	/// en: 'No alerts right now. Keep logging.'
	String get no_alerts => TranslationOverrides.string(_root.$meta, 'today.no_alerts', {}) ?? 'No alerts right now. Keep logging.';

	/// en: 'Home Screen widget'
	String get home_widget => TranslationOverrides.string(_root.$meta, 'today.home_widget', {}) ?? 'Home Screen widget';

	/// en: 'Refresh Home Widget'
	String get refresh_widget => TranslationOverrides.string(_root.$meta, 'today.refresh_widget', {}) ?? 'Refresh Home Widget';

	/// en: 'Pin AURA Today for a glance without opening the app.'
	String get widget_hint => TranslationOverrides.string(_root.$meta, 'today.widget_hint', {}) ?? 'Pin AURA Today for a glance without opening the app.';

	/// en: 'How to pin widget'
	String get add_home_button => TranslationOverrides.string(_root.$meta, 'today.add_home_button', {}) ?? 'How to pin widget';

	/// en: 'Pin AURA Today'
	String get add_home_title => TranslationOverrides.string(_root.$meta, 'today.add_home_title', {}) ?? 'Pin AURA Today';

	/// en: 'iOS does not let apps place widgets for you. Follow these steps once — then Today stays on your Home Screen.'
	String get add_home_subtitle => TranslationOverrides.string(_root.$meta, 'today.add_home_subtitle', {}) ?? 'iOS does not let apps place widgets for you. Follow these steps once — then Today stays on your Home Screen.';

	/// en: 'Touch and hold an empty area on the Home Screen, then tap Edit → Add Widget.'
	String get add_home_step_1 => TranslationOverrides.string(_root.$meta, 'today.add_home_step_1', {}) ?? 'Touch and hold an empty area on the Home Screen, then tap Edit → Add Widget.';

	/// en: 'Search for AURA and choose “AURA Today”.'
	String get add_home_step_2 => TranslationOverrides.string(_root.$meta, 'today.add_home_step_2', {}) ?? 'Search for AURA and choose “AURA Today”.';

	/// en: 'Tap Add Widget — numbers refresh from this app automatically.'
	String get add_home_step_3 => TranslationOverrides.string(_root.$meta, 'today.add_home_step_3', {}) ?? 'Tap Add Widget — numbers refresh from this app automatically.';

	/// en: 'Widget snapshot synced.'
	String get add_home_ready => TranslationOverrides.string(_root.$meta, 'today.add_home_ready', {}) ?? 'Widget snapshot synced.';

	/// en: 'Got it'
	String get add_home_done => TranslationOverrides.string(_root.$meta, 'today.add_home_done', {}) ?? 'Got it';

	/// en: 'Widget sizes'
	String get widget_types_title => TranslationOverrides.string(_root.$meta, 'today.widget_types_title', {}) ?? 'Widget sizes';

	/// en: 'Small'
	String get widget_type_small => TranslationOverrides.string(_root.$meta, 'today.widget_type_small', {}) ?? 'Small';

	/// en: 'Ring + kcal left'
	String get widget_type_small_caption => TranslationOverrides.string(_root.$meta, 'today.widget_type_small_caption', {}) ?? 'Ring + kcal left';

	/// en: 'Medium'
	String get widget_type_medium => TranslationOverrides.string(_root.$meta, 'today.widget_type_medium', {}) ?? 'Medium';

	/// en: 'In · out · water'
	String get widget_type_medium_caption => TranslationOverrides.string(_root.$meta, 'today.widget_type_medium_caption', {}) ?? 'In · out · water';

	/// en: 'Large tip'
	String get widget_type_large => TranslationOverrides.string(_root.$meta, 'today.widget_type_large', {}) ?? 'Large tip';

	/// en: 'Glance tip + remaining'
	String get widget_type_large_caption => TranslationOverrides.string(_root.$meta, 'today.widget_type_large_caption', {}) ?? 'Glance tip + remaining';

	/// en: 'Quick action'
	String get widget_type_quick => TranslationOverrides.string(_root.$meta, 'today.widget_type_quick', {}) ?? 'Quick action';

	/// en: 'Food · water · burn'
	String get widget_type_quick_caption => TranslationOverrides.string(_root.$meta, 'today.widget_type_quick_caption', {}) ?? 'Food · water · burn';

	/// en: 'One glance, then move — log the next meal in under 20 seconds.'
	String get widget_tip_line => TranslationOverrides.string(_root.$meta, 'today.widget_tip_line', {}) ?? 'One glance, then move — log the next meal in under 20 seconds.';

	/// en: 'kcal left · goal $goal'
	String widget_kcal_left({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.widget_kcal_left', {'goal': goal}) ?? 'kcal left · goal ${goal}';

	/// en: 'How Today (home) works'
	String get home_guide_title => TranslationOverrides.string(_root.$meta, 'today.home_guide_title', {}) ?? 'How Today (home) works';

	/// en: 'This is your home screen for the day. Glance the ring, act with one tap, then keep living — deep menus stay optional.'
	String get home_guide_body => TranslationOverrides.string(_root.$meta, 'today.home_guide_body', {}) ?? 'This is your home screen for the day. Glance the ring, act with one tap, then keep living — deep menus stay optional.';

	/// en: 'Read the ring'
	String get home_guide_ring_title => TranslationOverrides.string(_root.$meta, 'today.home_guide_ring_title', {}) ?? 'Read the ring';

	/// en: 'Remaining kcal and the calorie goal sit in the hero card. If the ring is calm, you are on track.'
	String get home_guide_ring_body => TranslationOverrides.string(_root.$meta, 'today.home_guide_ring_body', {}) ?? 'Remaining kcal and the calorie goal sit in the hero card. If the ring is calm, you are on track.';

	/// en: 'Use quick actions'
	String get home_guide_actions_title => TranslationOverrides.string(_root.$meta, 'today.home_guide_actions_title', {}) ?? 'Use quick actions';

	/// en: 'Food, water, coach pulse, and burn open sheets without leaving Today. Log in under 20 seconds.'
	String get home_guide_actions_body => TranslationOverrides.string(_root.$meta, 'today.home_guide_actions_body', {}) ?? 'Food, water, coach pulse, and burn open sheets without leaving Today. Log in under 20 seconds.';

	/// en: 'Check macros & alerts'
	String get home_guide_metrics_title => TranslationOverrides.string(_root.$meta, 'today.home_guide_metrics_title', {}) ?? 'Check macros & alerts';

	/// en: 'Eaten / burned / water tiles and nutrition bars show balance. Alerts call out one thing to fix next.'
	String get home_guide_metrics_body => TranslationOverrides.string(_root.$meta, 'today.home_guide_metrics_body', {}) ?? 'Eaten / burned / water tiles and nutrition bars show balance. Alerts call out one thing to fix next.';

	/// en: 'Keep a glance outside'
	String get home_guide_surfaces_title => TranslationOverrides.string(_root.$meta, 'today.home_guide_surfaces_title', {}) ?? 'Keep a glance outside';

	/// en: 'Pin the Home Screen widget or start a Live Activity so “how much left?” never needs a full app open.'
	String get home_guide_surfaces_body => TranslationOverrides.string(_root.$meta, 'today.home_guide_surfaces_body', {}) ?? 'Pin the Home Screen widget or start a Live Activity so “how much left?” never needs a full app open.';
}

// Path: log
class Translations$log$en {
	Translations$log$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log'
	String get title => TranslationOverrides.string(_root.$meta, 'log.title', {}) ?? 'Log';

	/// en: 'Log meals and burns for today.'
	String get subtitle_today => TranslationOverrides.string(_root.$meta, 'log.subtitle_today', {}) ?? 'Log meals and burns for today.';

	/// en: 'Review and adjust this day’s entries.'
	String get subtitle_past => TranslationOverrides.string(_root.$meta, 'log.subtitle_past', {}) ?? 'Review and adjust this day’s entries.';

	/// en: 'Today balance'
	String get today_balance => TranslationOverrides.string(_root.$meta, 'log.today_balance', {}) ?? 'Today balance';

	/// en: 'Quick add'
	String get quick_add => TranslationOverrides.string(_root.$meta, 'log.quick_add', {}) ?? 'Quick add';

	/// en: 'Custom'
	String get custom => TranslationOverrides.string(_root.$meta, 'log.custom', {}) ?? 'Custom';

	/// en: 'Burn'
	String get burn => TranslationOverrides.string(_root.$meta, 'log.burn', {}) ?? 'Burn';

	/// en: 'Logged today'
	String get logged_today => TranslationOverrides.string(_root.$meta, 'log.logged_today', {}) ?? 'Logged today';

	/// en: 'Nothing yet. Tap a meal or burn to start.'
	String get empty => TranslationOverrides.string(_root.$meta, 'log.empty', {}) ?? 'Nothing yet. Tap a meal or burn to start.';

	/// en: 'Remove entry?'
	String get remove_confirm => TranslationOverrides.string(_root.$meta, 'log.remove_confirm', {}) ?? 'Remove entry?';

	/// en: 'Custom $meal'
	String custom_title({required Object meal}) => TranslationOverrides.string(_root.$meta, 'log.custom_title', {'meal': meal}) ?? 'Custom ${meal}';

	/// en: 'Name needed'
	String get name_needed => TranslationOverrides.string(_root.$meta, 'log.name_needed', {}) ?? 'Name needed';

	/// en: 'Macros (g)'
	String get macros => TranslationOverrides.string(_root.$meta, 'log.macros', {}) ?? 'Macros (g)';

	/// en: 'Save entry'
	String get save_entry => TranslationOverrides.string(_root.$meta, 'log.save_entry', {}) ?? 'Save entry';

	/// en: 'Saving…'
	String get saving => TranslationOverrides.string(_root.$meta, 'log.saving', {}) ?? 'Saving…';
}

// Path: body
class Translations$body$en {
	Translations$body$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Body'
	String get title => TranslationOverrides.string(_root.$meta, 'body.title', {}) ?? 'Body';

	/// en: 'Overview'
	String get overview => TranslationOverrides.string(_root.$meta, 'body.overview', {}) ?? 'Overview';

	/// en: 'Athlete'
	String get athlete => TranslationOverrides.string(_root.$meta, 'body.athlete', {}) ?? 'Athlete';

	/// en: 'Body mass index'
	String get bmi => TranslationOverrides.string(_root.$meta, 'body.bmi', {}) ?? 'Body mass index';

	/// en: 'BMR'
	String get bmr => TranslationOverrides.string(_root.$meta, 'body.bmr', {}) ?? 'BMR';

	/// en: 'TDEE'
	String get tdee => TranslationOverrides.string(_root.$meta, 'body.tdee', {}) ?? 'TDEE';

	/// en: 'Goal'
	String get goal => TranslationOverrides.string(_root.$meta, 'body.goal', {}) ?? 'Goal';

	/// en: 'Height'
	String get height => TranslationOverrides.string(_root.$meta, 'body.height', {}) ?? 'Height';

	/// en: 'Weight'
	String get weight => TranslationOverrides.string(_root.$meta, 'body.weight', {}) ?? 'Weight';

	/// en: 'Age'
	String get age => TranslationOverrides.string(_root.$meta, 'body.age', {}) ?? 'Age';

	/// en: 'Sex'
	String get sex => TranslationOverrides.string(_root.$meta, 'body.sex', {}) ?? 'Sex';

	/// en: 'Body type'
	String get body_type => TranslationOverrides.string(_root.$meta, 'body.body_type', {}) ?? 'Body type';

	/// en: 'Activity'
	String get activity => TranslationOverrides.string(_root.$meta, 'body.activity', {}) ?? 'Activity';

	/// en: 'Using calculated TDEE as goal.'
	String get using_tdee => TranslationOverrides.string(_root.$meta, 'body.using_tdee', {}) ?? 'Using calculated TDEE as goal.';

	/// en: 'Set custom goal (−300)'
	String get set_custom_goal => TranslationOverrides.string(_root.$meta, 'body.set_custom_goal', {}) ?? 'Set custom goal (−300)';

	/// en: 'Reset to TDEE'
	String get reset_tdee => TranslationOverrides.string(_root.$meta, 'body.reset_tdee', {}) ?? 'Reset to TDEE';

	/// en: 'Body change'
	String get body_change => TranslationOverrides.string(_root.$meta, 'body.body_change', {}) ?? 'Body change';

	/// en: 'Need 2+ check-ins'
	String get need_checkins => TranslationOverrides.string(_root.$meta, 'body.need_checkins', {}) ?? 'Need 2+ check-ins';

	/// en: 'Add check-in'
	String get add_checkin => TranslationOverrides.string(_root.$meta, 'body.add_checkin', {}) ?? 'Add check-in';

	/// en: 'Chart appears after 2 check-ins'
	String get chart_hint => TranslationOverrides.string(_root.$meta, 'body.chart_hint', {}) ?? 'Chart appears after 2 check-ins';
}

// Path: coach
class Translations$coach$en {
	Translations$coach$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Coach'
	String get title => TranslationOverrides.string(_root.$meta, 'coach.title', {}) ?? 'Coach';

	/// en: 'Daily assist'
	String get daily_assist => TranslationOverrides.string(_root.$meta, 'coach.daily_assist', {}) ?? 'Daily assist';

	/// en: 'On-device tips and local reminders. No account, no cloud coach.'
	String get daily_assist_body => TranslationOverrides.string(_root.$meta, 'coach.daily_assist_body', {}) ?? 'On-device tips and local reminders. No account, no cloud coach.';

	/// en: 'Guides'
	String get guides => TranslationOverrides.string(_root.$meta, 'coach.guides', {}) ?? 'Guides';

	/// en: 'Today tips'
	String get today_tips => TranslationOverrides.string(_root.$meta, 'coach.today_tips', {}) ?? 'Today tips';

	/// en: 'Push check-in'
	String get push_checkin => TranslationOverrides.string(_root.$meta, 'coach.push_checkin', {}) ?? 'Push check-in';

	/// en: 'Next topic'
	String get next_topic => TranslationOverrides.string(_root.$meta, 'coach.next_topic', {}) ?? 'Next topic';

	/// en: 'Local reminders'
	String get local_reminders => TranslationOverrides.string(_root.$meta, 'coach.local_reminders', {}) ?? 'Local reminders';

	/// en: 'Warn when over goal'
	String get warn_over_goal => TranslationOverrides.string(_root.$meta, 'coach.warn_over_goal', {}) ?? 'Warn when over goal';

	/// en: 'How did today feel?'
	String get journal => TranslationOverrides.string(_root.$meta, 'coach.journal', {}) ?? 'How did today feel?';

	/// en: 'One honest line beats a perfect diary.'
	String get journal_hint => TranslationOverrides.string(_root.$meta, 'coach.journal_hint', {}) ?? 'One honest line beats a perfect diary.';

	/// en: 'Save note'
	String get save_note => TranslationOverrides.string(_root.$meta, 'coach.save_note', {}) ?? 'Save note';

	/// en: 'Long-press to delete'
	String get long_press_delete => TranslationOverrides.string(_root.$meta, 'coach.long_press_delete', {}) ?? 'Long-press to delete';

	/// en: 'Health coach'
	String get health_coach => TranslationOverrides.string(_root.$meta, 'coach.health_coach', {}) ?? 'Health coach';

	/// en: 'Food coach'
	String get food_coach => TranslationOverrides.string(_root.$meta, 'coach.food_coach', {}) ?? 'Food coach';

	/// en: 'Loading WebLLM…'
	String get loading_webllm => TranslationOverrides.string(_root.$meta, 'coach.loading_webllm', {}) ?? 'Loading WebLLM…';
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Train with clarity'
	String get welcome_title => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_title', {}) ?? 'Train with clarity';

	/// en: 'AURA keeps calories, water, and coaching on this device.'
	String get welcome_body => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_body', {}) ?? 'AURA keeps calories, water, and coaching on this device.';

	/// en: 'Body baseline'
	String get body_title => TranslationOverrides.string(_root.$meta, 'onboarding.body_title', {}) ?? 'Body baseline';

	/// en: 'Height, weight, and activity set your daily energy target.'
	String get body_body => TranslationOverrides.string(_root.$meta, 'onboarding.body_body', {}) ?? 'Height, weight, and activity set your daily energy target.';

	/// en: 'What should we call you?'
	String get name_title => TranslationOverrides.string(_root.$meta, 'onboarding.name_title', {}) ?? 'What should we call you?';

	/// en: 'Display name'
	String get name_hint => TranslationOverrides.string(_root.$meta, 'onboarding.name_hint', {}) ?? 'Display name';

	/// en: 'Enter AURA'
	String get ready_title => TranslationOverrides.string(_root.$meta, 'onboarding.ready_title', {}) ?? 'Enter AURA';

	/// en: 'Your local profile is ready. Permissions come next.'
	String get ready_body => TranslationOverrides.string(_root.$meta, 'onboarding.ready_body', {}) ?? 'Your local profile is ready. Permissions come next.';

	/// en: 'Continue'
	String get kContinue => TranslationOverrides.string(_root.$meta, 'onboarding.kContinue', {}) ?? 'Continue';

	/// en: 'Back'
	String get back => TranslationOverrides.string(_root.$meta, 'onboarding.back', {}) ?? 'Back';
}

// Path: permissions
class Translations$permissions$en {
	Translations$permissions$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unlock a sharper day'
	String get intro_title => TranslationOverrides.string(_root.$meta, 'permissions.intro_title', {}) ?? 'Unlock a sharper day';

	/// en: 'Local reminders and motion help AURA pace your day. You can skip any step.'
	String get intro_body => TranslationOverrides.string(_root.$meta, 'permissions.intro_body', {}) ?? 'Local reminders and motion help AURA pace your day. You can skip any step.';

	/// en: 'Allow notifications'
	String get notifications_title => TranslationOverrides.string(_root.$meta, 'permissions.notifications_title', {}) ?? 'Allow notifications';

	/// en: 'Meal, water, and movement nudges stay on this phone.'
	String get notifications_body => TranslationOverrides.string(_root.$meta, 'permissions.notifications_body', {}) ?? 'Meal, water, and movement nudges stay on this phone.';

	/// en: 'Location while using'
	String get location_title => TranslationOverrides.string(_root.$meta, 'permissions.location_title', {}) ?? 'Location while using';

	/// en: 'Optional context for outdoor sessions — not background tracking.'
	String get location_body => TranslationOverrides.string(_root.$meta, 'permissions.location_body', {}) ?? 'Optional context for outdoor sessions — not background tracking.';

	/// en: 'Motion & fitness'
	String get fitness_title => TranslationOverrides.string(_root.$meta, 'permissions.fitness_title', {}) ?? 'Motion & fitness';

	/// en: 'Improves burn estimates from activity on this device.'
	String get fitness_body => TranslationOverrides.string(_root.$meta, 'permissions.fitness_body', {}) ?? 'Improves burn estimates from activity on this device.';

	/// en: 'Allow'
	String get allow => TranslationOverrides.string(_root.$meta, 'permissions.allow', {}) ?? 'Allow';

	/// en: 'Not now'
	String get not_now => TranslationOverrides.string(_root.$meta, 'permissions.not_now', {}) ?? 'Not now';
}

// Path: profile
class Translations$profile$en {
	Translations$profile$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Athlete'
	String get athlete_fallback => TranslationOverrides.string(_root.$meta, 'profile.athlete_fallback', {}) ?? 'Athlete';

	/// en: 'Local AURA profile · gym baseline'
	String get subtitle => TranslationOverrides.string(_root.$meta, 'profile.subtitle', {}) ?? 'Local AURA profile · gym baseline';

	/// en: 'Edit in Body'
	String get edit_in_body => TranslationOverrides.string(_root.$meta, 'profile.edit_in_body', {}) ?? 'Edit in Body';

	/// en: 'Replay onboarding'
	String get replay_onboarding => TranslationOverrides.string(_root.$meta, 'profile.replay_onboarding', {}) ?? 'Replay onboarding';

	/// en: 'Review permissions'
	String get review_permissions => TranslationOverrides.string(_root.$meta, 'profile.review_permissions', {}) ?? 'Review permissions';
}

// Path: sheets
class Translations$sheets$en {
	Translations$sheets$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log food'
	String get log_food_title => TranslationOverrides.string(_root.$meta, 'sheets.log_food_title', {}) ?? 'Log food';

	/// en: 'Stay on Today — pick a meal, then a preset.'
	String get log_food_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.log_food_subtitle', {}) ?? 'Stay on Today — pick a meal, then a preset.';

	/// en: 'Add water'
	String get add_water_title => TranslationOverrides.string(_root.$meta, 'sheets.add_water_title', {}) ?? 'Add water';

	/// en: 'One tap keeps the hydration ring honest.'
	String get add_water_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.add_water_subtitle', {}) ?? 'One tap keeps the hydration ring honest.';

	/// en: 'Log burn'
	String get log_burn_title => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_title', {}) ?? 'Log burn';

	/// en: 'Capture movement without leaving Today.'
	String get log_burn_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_subtitle', {}) ?? 'Capture movement without leaving Today.';

	/// en: 'Coach pulse'
	String get coach_pulse_title => TranslationOverrides.string(_root.$meta, 'sheets.coach_pulse_title', {}) ?? 'Coach pulse';

	/// en: 'Quick journal'
	String get quick_journal => TranslationOverrides.string(_root.$meta, 'sheets.quick_journal', {}) ?? 'Quick journal';

	/// en: 'Open full Coach'
	String get open_full_coach => TranslationOverrides.string(_root.$meta, 'sheets.open_full_coach', {}) ?? 'Open full Coach';

	/// en: 'What are you logging?'
	String get what_logging => TranslationOverrides.string(_root.$meta, 'sheets.what_logging', {}) ?? 'What are you logging?';

	/// en: 'Notifications'
	String get notifications => TranslationOverrides.string(_root.$meta, 'sheets.notifications', {}) ?? 'Notifications';

	/// en: 'No notifications yet.'
	String get no_notifications => TranslationOverrides.string(_root.$meta, 'sheets.no_notifications', {}) ?? 'No notifications yet.';
}

// Path: tips
class Translations$tips$en {
	Translations$tips$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today_tag => TranslationOverrides.string(_root.$meta, 'tips.today_tag', {}) ?? 'Today';

	/// en: 'One glance, then move'
	String get today_title => TranslationOverrides.string(_root.$meta, 'tips.today_title', {}) ?? 'One glance, then move';

	/// en: 'Check remaining kcal and the ring first. If warnings are empty, skip deep menus and log the next meal in under 20 seconds.'
	String get today_body => TranslationOverrides.string(_root.$meta, 'tips.today_body', {}) ?? 'Check remaining kcal and the ring first. If warnings are empty, skip deep menus and log the next meal in under 20 seconds.';

	/// en: 'Log'
	String get log_tag => TranslationOverrides.string(_root.$meta, 'tips.log_tag', {}) ?? 'Log';

	/// en: 'Presets beat perfect grams'
	String get log_title => TranslationOverrides.string(_root.$meta, 'tips.log_title', {}) ?? 'Presets beat perfect grams';

	/// en: 'Tap a quick-add before you hunt labels. Honest estimates beat empty days — you can refine custom entries later.'
	String get log_body => TranslationOverrides.string(_root.$meta, 'tips.log_body', {}) ?? 'Tap a quick-add before you hunt labels. Honest estimates beat empty days — you can refine custom entries later.';

	/// en: 'Body'
	String get body_tag => TranslationOverrides.string(_root.$meta, 'tips.body_tag', {}) ?? 'Body';

	/// en: 'Set the body once a week'
	String get body_title => TranslationOverrides.string(_root.$meta, 'tips.body_title', {}) ?? 'Set the body once a week';

	/// en: 'Height, weight, and activity drive BMR/TDEE. Update weight weekly; daily noise makes goals jittery.'
	String get body_body => TranslationOverrides.string(_root.$meta, 'tips.body_body', {}) ?? 'Height, weight, and activity drive BMR/TDEE. Update weight weekly; daily noise makes goals jittery.';

	/// en: 'Coach'
	String get coach_tag => TranslationOverrides.string(_root.$meta, 'tips.coach_tag', {}) ?? 'Coach';

	/// en: 'Ask for the next action'
	String get coach_title => TranslationOverrides.string(_root.$meta, 'tips.coach_title', {}) ?? 'Ask for the next action';

	/// en: 'On a real iPhone, open Health or Food coach. Give today’s summary and ask for one meal or one walk — not a full diet overhaul.'
	String get coach_body => TranslationOverrides.string(_root.$meta, 'tips.coach_body', {}) ?? 'On a real iPhone, open Health or Food coach. Give today’s summary and ask for one meal or one walk — not a full diet overhaul.';

	/// en: 'Widget'
	String get widget_tag => TranslationOverrides.string(_root.$meta, 'tips.widget_tag', {}) ?? 'Widget';

	/// en: 'Pin the glance surface'
	String get widget_title => TranslationOverrides.string(_root.$meta, 'tips.widget_title', {}) ?? 'Pin the glance surface';

	/// en: 'Add the AURA Today widget and start a Live Activity before lunch. The island should answer “how much left?” without opening the app.'
	String get widget_body => TranslationOverrides.string(_root.$meta, 'tips.widget_body', {}) ?? 'Add the AURA Today widget and start a Live Activity before lunch. The island should answer “how much left?” without opening the app.';

	/// en: 'Water'
	String get water_tag => TranslationOverrides.string(_root.$meta, 'tips.water_tag', {}) ?? 'Water';

	/// en: 'Stack water with habits'
	String get water_title => TranslationOverrides.string(_root.$meta, 'tips.water_title', {}) ?? 'Stack water with habits';

	/// en: 'Log +250 ml when you sit down to work or finish a set. Water goals unlock cleaner coach warnings by late afternoon.'
	String get water_body => TranslationOverrides.string(_root.$meta, 'tips.water_body', {}) ?? 'Log +250 ml when you sit down to work or finish a set. Water goals unlock cleaner coach warnings by late afternoon.';
}

// Path: empty
class Translations$empty$en {
	Translations$empty$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Nothing here yet'
	String get generic_title => TranslationOverrides.string(_root.$meta, 'empty.generic_title', {}) ?? 'Nothing here yet';

	/// en: 'When you add data, it will show up in this space.'
	String get generic_body => TranslationOverrides.string(_root.$meta, 'empty.generic_body', {}) ?? 'When you add data, it will show up in this space.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.ok' => TranslationOverrides.string(_root.$meta, 'common.ok', {}) ?? 'OK',
			'common.cancel' => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel',
			'common.save' => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save',
			'common.delete' => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Delete',
			'common.edit' => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Edit',
			'common.close' => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Close',
			'common.back' => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back',
			'common.next' => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'Next',
			'common.kContinue' => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Continue',
			'common.done' => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Done',
			'common.loading' => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading…',
			'common.retry' => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry',
			'common.refresh' => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Refresh',
			'common.not_now' => TranslationOverrides.string(_root.$meta, 'common.not_now', {}) ?? 'Not now',
			'common.remove' => TranslationOverrides.string(_root.$meta, 'common.remove', {}) ?? 'Remove',
			'common.kcal' => TranslationOverrides.string(_root.$meta, 'common.kcal', {}) ?? 'kcal',
			'common.ml' => TranslationOverrides.string(_root.$meta, 'common.ml', {}) ?? 'ml',
			'common.cm' => TranslationOverrides.string(_root.$meta, 'common.cm', {}) ?? 'cm',
			'common.kg' => TranslationOverrides.string(_root.$meta, 'common.kg', {}) ?? 'kg',
			'common.on' => TranslationOverrides.string(_root.$meta, 'common.on', {}) ?? 'On',
			'common.off' => TranslationOverrides.string(_root.$meta, 'common.off', {}) ?? 'Off',
			'tabs.today' => TranslationOverrides.string(_root.$meta, 'tabs.today', {}) ?? 'Today',
			'tabs.log' => TranslationOverrides.string(_root.$meta, 'tabs.log', {}) ?? 'Log',
			'tabs.body' => TranslationOverrides.string(_root.$meta, 'tabs.body', {}) ?? 'Body',
			'tabs.coach' => TranslationOverrides.string(_root.$meta, 'tabs.coach', {}) ?? 'Coach',
			'settings.language' => TranslationOverrides.string(_root.$meta, 'settings.language', {}) ?? 'Language',
			'settings.english' => TranslationOverrides.string(_root.$meta, 'settings.english', {}) ?? 'English',
			'settings.turkish' => TranslationOverrides.string(_root.$meta, 'settings.turkish', {}) ?? 'Türkçe',
			'settings.appearance' => TranslationOverrides.string(_root.$meta, 'settings.appearance', {}) ?? 'Appearance',
			'settings.theme_light' => TranslationOverrides.string(_root.$meta, 'settings.theme_light', {}) ?? 'Light',
			'settings.theme_dark' => TranslationOverrides.string(_root.$meta, 'settings.theme_dark', {}) ?? 'Dark',
			'settings.theme_system' => TranslationOverrides.string(_root.$meta, 'settings.theme_system', {}) ?? 'System',
			'settings.font_scale' => TranslationOverrides.string(_root.$meta, 'settings.font_scale', {}) ?? 'Text size',
			'meals.breakfast' => TranslationOverrides.string(_root.$meta, 'meals.breakfast', {}) ?? 'Breakfast',
			'meals.lunch' => TranslationOverrides.string(_root.$meta, 'meals.lunch', {}) ?? 'Lunch',
			'meals.dinner' => TranslationOverrides.string(_root.$meta, 'meals.dinner', {}) ?? 'Dinner',
			'meals.snack' => TranslationOverrides.string(_root.$meta, 'meals.snack', {}) ?? 'Snack',
			'meals.drink' => TranslationOverrides.string(_root.$meta, 'meals.drink', {}) ?? 'Drink',
			'meals.breakfast_caption' => TranslationOverrides.string(_root.$meta, 'meals.breakfast_caption', {}) ?? 'Start the fuel day',
			'meals.lunch_caption' => TranslationOverrides.string(_root.$meta, 'meals.lunch_caption', {}) ?? 'Midday plate',
			'meals.dinner_caption' => TranslationOverrides.string(_root.$meta, 'meals.dinner_caption', {}) ?? 'Evening meal',
			'meals.snack_caption' => TranslationOverrides.string(_root.$meta, 'meals.snack_caption', {}) ?? 'Small top-up',
			'meals.drink_caption' => TranslationOverrides.string(_root.$meta, 'meals.drink_caption', {}) ?? 'Hydration & sips',
			'activity.sedentary' => TranslationOverrides.string(_root.$meta, 'activity.sedentary', {}) ?? 'Sedentary',
			'activity.light' => TranslationOverrides.string(_root.$meta, 'activity.light', {}) ?? 'Light',
			'activity.moderate' => TranslationOverrides.string(_root.$meta, 'activity.moderate', {}) ?? 'Moderate',
			'activity.active' => TranslationOverrides.string(_root.$meta, 'activity.active', {}) ?? 'Active',
			'activity.very_active' => TranslationOverrides.string(_root.$meta, 'activity.very_active', {}) ?? 'Very active',
			'goals.lose' => TranslationOverrides.string(_root.$meta, 'goals.lose', {}) ?? 'Cut',
			'goals.maintain' => TranslationOverrides.string(_root.$meta, 'goals.maintain', {}) ?? 'Maintain',
			'goals.gain' => TranslationOverrides.string(_root.$meta, 'goals.gain', {}) ?? 'Bulk',
			'goals.recomp' => TranslationOverrides.string(_root.$meta, 'goals.recomp', {}) ?? 'Recomp',
			'sex.woman' => TranslationOverrides.string(_root.$meta, 'sex.woman', {}) ?? 'Woman',
			'sex.man' => TranslationOverrides.string(_root.$meta, 'sex.man', {}) ?? 'Man',
			'today.eaten' => TranslationOverrides.string(_root.$meta, 'today.eaten', {}) ?? 'Eaten',
			'today.burned' => TranslationOverrides.string(_root.$meta, 'today.burned', {}) ?? 'Burned',
			'today.water' => TranslationOverrides.string(_root.$meta, 'today.water', {}) ?? 'Water',
			'today.kcal_remaining' => ({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.kcal_remaining', {'goal': goal}) ?? 'kcal remaining · goal ${goal}',
			'today.add_food' => TranslationOverrides.string(_root.$meta, 'today.add_food', {}) ?? 'Add food',
			'today.add_water' => TranslationOverrides.string(_root.$meta, 'today.add_water', {}) ?? 'Add water',
			'today.open_coach' => TranslationOverrides.string(_root.$meta, 'today.open_coach', {}) ?? 'Open coach',
			'today.log_burn' => TranslationOverrides.string(_root.$meta, 'today.log_burn', {}) ?? 'Log burn',
			'today.nutrition' => TranslationOverrides.string(_root.$meta, 'today.nutrition', {}) ?? 'Nutrition',
			'today.nutrition_subtitle' => TranslationOverrides.string(_root.$meta, 'today.nutrition_subtitle', {}) ?? 'Protein, carbs, and fat vs today’s targets',
			'today.protein' => TranslationOverrides.string(_root.$meta, 'today.protein', {}) ?? 'Protein',
			'today.carbs' => TranslationOverrides.string(_root.$meta, 'today.carbs', {}) ?? 'Carbs',
			'today.fat' => TranslationOverrides.string(_root.$meta, 'today.fat', {}) ?? 'Fat',
			'today.alerts' => TranslationOverrides.string(_root.$meta, 'today.alerts', {}) ?? 'Alerts',
			'today.all_clear' => TranslationOverrides.string(_root.$meta, 'today.all_clear', {}) ?? 'All clear',
			'today.needs_look' => TranslationOverrides.string(_root.$meta, 'today.needs_look', {}) ?? 'Needs a look',
			'today.no_alerts' => TranslationOverrides.string(_root.$meta, 'today.no_alerts', {}) ?? 'No alerts right now. Keep logging.',
			'today.home_widget' => TranslationOverrides.string(_root.$meta, 'today.home_widget', {}) ?? 'Home Screen widget',
			'today.refresh_widget' => TranslationOverrides.string(_root.$meta, 'today.refresh_widget', {}) ?? 'Refresh Home Widget',
			'today.widget_hint' => TranslationOverrides.string(_root.$meta, 'today.widget_hint', {}) ?? 'Pin AURA Today for a glance without opening the app.',
			'today.add_home_button' => TranslationOverrides.string(_root.$meta, 'today.add_home_button', {}) ?? 'How to pin widget',
			'today.add_home_title' => TranslationOverrides.string(_root.$meta, 'today.add_home_title', {}) ?? 'Pin AURA Today',
			'today.add_home_subtitle' => TranslationOverrides.string(_root.$meta, 'today.add_home_subtitle', {}) ?? 'iOS does not let apps place widgets for you. Follow these steps once — then Today stays on your Home Screen.',
			'today.add_home_step_1' => TranslationOverrides.string(_root.$meta, 'today.add_home_step_1', {}) ?? 'Touch and hold an empty area on the Home Screen, then tap Edit → Add Widget.',
			'today.add_home_step_2' => TranslationOverrides.string(_root.$meta, 'today.add_home_step_2', {}) ?? 'Search for AURA and choose “AURA Today”.',
			'today.add_home_step_3' => TranslationOverrides.string(_root.$meta, 'today.add_home_step_3', {}) ?? 'Tap Add Widget — numbers refresh from this app automatically.',
			'today.add_home_ready' => TranslationOverrides.string(_root.$meta, 'today.add_home_ready', {}) ?? 'Widget snapshot synced.',
			'today.add_home_done' => TranslationOverrides.string(_root.$meta, 'today.add_home_done', {}) ?? 'Got it',
			'today.widget_types_title' => TranslationOverrides.string(_root.$meta, 'today.widget_types_title', {}) ?? 'Widget sizes',
			'today.widget_type_small' => TranslationOverrides.string(_root.$meta, 'today.widget_type_small', {}) ?? 'Small',
			'today.widget_type_small_caption' => TranslationOverrides.string(_root.$meta, 'today.widget_type_small_caption', {}) ?? 'Ring + kcal left',
			'today.widget_type_medium' => TranslationOverrides.string(_root.$meta, 'today.widget_type_medium', {}) ?? 'Medium',
			'today.widget_type_medium_caption' => TranslationOverrides.string(_root.$meta, 'today.widget_type_medium_caption', {}) ?? 'In · out · water',
			'today.widget_type_large' => TranslationOverrides.string(_root.$meta, 'today.widget_type_large', {}) ?? 'Large tip',
			'today.widget_type_large_caption' => TranslationOverrides.string(_root.$meta, 'today.widget_type_large_caption', {}) ?? 'Glance tip + remaining',
			'today.widget_type_quick' => TranslationOverrides.string(_root.$meta, 'today.widget_type_quick', {}) ?? 'Quick action',
			'today.widget_type_quick_caption' => TranslationOverrides.string(_root.$meta, 'today.widget_type_quick_caption', {}) ?? 'Food · water · burn',
			'today.widget_tip_line' => TranslationOverrides.string(_root.$meta, 'today.widget_tip_line', {}) ?? 'One glance, then move — log the next meal in under 20 seconds.',
			'today.widget_kcal_left' => ({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.widget_kcal_left', {'goal': goal}) ?? 'kcal left · goal ${goal}',
			'today.home_guide_title' => TranslationOverrides.string(_root.$meta, 'today.home_guide_title', {}) ?? 'How Today (home) works',
			'today.home_guide_body' => TranslationOverrides.string(_root.$meta, 'today.home_guide_body', {}) ?? 'This is your home screen for the day. Glance the ring, act with one tap, then keep living — deep menus stay optional.',
			'today.home_guide_ring_title' => TranslationOverrides.string(_root.$meta, 'today.home_guide_ring_title', {}) ?? 'Read the ring',
			'today.home_guide_ring_body' => TranslationOverrides.string(_root.$meta, 'today.home_guide_ring_body', {}) ?? 'Remaining kcal and the calorie goal sit in the hero card. If the ring is calm, you are on track.',
			'today.home_guide_actions_title' => TranslationOverrides.string(_root.$meta, 'today.home_guide_actions_title', {}) ?? 'Use quick actions',
			'today.home_guide_actions_body' => TranslationOverrides.string(_root.$meta, 'today.home_guide_actions_body', {}) ?? 'Food, water, coach pulse, and burn open sheets without leaving Today. Log in under 20 seconds.',
			'today.home_guide_metrics_title' => TranslationOverrides.string(_root.$meta, 'today.home_guide_metrics_title', {}) ?? 'Check macros & alerts',
			'today.home_guide_metrics_body' => TranslationOverrides.string(_root.$meta, 'today.home_guide_metrics_body', {}) ?? 'Eaten / burned / water tiles and nutrition bars show balance. Alerts call out one thing to fix next.',
			'today.home_guide_surfaces_title' => TranslationOverrides.string(_root.$meta, 'today.home_guide_surfaces_title', {}) ?? 'Keep a glance outside',
			'today.home_guide_surfaces_body' => TranslationOverrides.string(_root.$meta, 'today.home_guide_surfaces_body', {}) ?? 'Pin the Home Screen widget or start a Live Activity so “how much left?” never needs a full app open.',
			'log.title' => TranslationOverrides.string(_root.$meta, 'log.title', {}) ?? 'Log',
			'log.subtitle_today' => TranslationOverrides.string(_root.$meta, 'log.subtitle_today', {}) ?? 'Log meals and burns for today.',
			'log.subtitle_past' => TranslationOverrides.string(_root.$meta, 'log.subtitle_past', {}) ?? 'Review and adjust this day’s entries.',
			'log.today_balance' => TranslationOverrides.string(_root.$meta, 'log.today_balance', {}) ?? 'Today balance',
			'log.quick_add' => TranslationOverrides.string(_root.$meta, 'log.quick_add', {}) ?? 'Quick add',
			'log.custom' => TranslationOverrides.string(_root.$meta, 'log.custom', {}) ?? 'Custom',
			'log.burn' => TranslationOverrides.string(_root.$meta, 'log.burn', {}) ?? 'Burn',
			'log.logged_today' => TranslationOverrides.string(_root.$meta, 'log.logged_today', {}) ?? 'Logged today',
			'log.empty' => TranslationOverrides.string(_root.$meta, 'log.empty', {}) ?? 'Nothing yet. Tap a meal or burn to start.',
			'log.remove_confirm' => TranslationOverrides.string(_root.$meta, 'log.remove_confirm', {}) ?? 'Remove entry?',
			'log.custom_title' => ({required Object meal}) => TranslationOverrides.string(_root.$meta, 'log.custom_title', {'meal': meal}) ?? 'Custom ${meal}',
			'log.name_needed' => TranslationOverrides.string(_root.$meta, 'log.name_needed', {}) ?? 'Name needed',
			'log.macros' => TranslationOverrides.string(_root.$meta, 'log.macros', {}) ?? 'Macros (g)',
			'log.save_entry' => TranslationOverrides.string(_root.$meta, 'log.save_entry', {}) ?? 'Save entry',
			'log.saving' => TranslationOverrides.string(_root.$meta, 'log.saving', {}) ?? 'Saving…',
			'body.title' => TranslationOverrides.string(_root.$meta, 'body.title', {}) ?? 'Body',
			'body.overview' => TranslationOverrides.string(_root.$meta, 'body.overview', {}) ?? 'Overview',
			'body.athlete' => TranslationOverrides.string(_root.$meta, 'body.athlete', {}) ?? 'Athlete',
			'body.bmi' => TranslationOverrides.string(_root.$meta, 'body.bmi', {}) ?? 'Body mass index',
			'body.bmr' => TranslationOverrides.string(_root.$meta, 'body.bmr', {}) ?? 'BMR',
			'body.tdee' => TranslationOverrides.string(_root.$meta, 'body.tdee', {}) ?? 'TDEE',
			'body.goal' => TranslationOverrides.string(_root.$meta, 'body.goal', {}) ?? 'Goal',
			'body.height' => TranslationOverrides.string(_root.$meta, 'body.height', {}) ?? 'Height',
			'body.weight' => TranslationOverrides.string(_root.$meta, 'body.weight', {}) ?? 'Weight',
			'body.age' => TranslationOverrides.string(_root.$meta, 'body.age', {}) ?? 'Age',
			'body.sex' => TranslationOverrides.string(_root.$meta, 'body.sex', {}) ?? 'Sex',
			'body.body_type' => TranslationOverrides.string(_root.$meta, 'body.body_type', {}) ?? 'Body type',
			'body.activity' => TranslationOverrides.string(_root.$meta, 'body.activity', {}) ?? 'Activity',
			'body.using_tdee' => TranslationOverrides.string(_root.$meta, 'body.using_tdee', {}) ?? 'Using calculated TDEE as goal.',
			'body.set_custom_goal' => TranslationOverrides.string(_root.$meta, 'body.set_custom_goal', {}) ?? 'Set custom goal (−300)',
			'body.reset_tdee' => TranslationOverrides.string(_root.$meta, 'body.reset_tdee', {}) ?? 'Reset to TDEE',
			'body.body_change' => TranslationOverrides.string(_root.$meta, 'body.body_change', {}) ?? 'Body change',
			'body.need_checkins' => TranslationOverrides.string(_root.$meta, 'body.need_checkins', {}) ?? 'Need 2+ check-ins',
			'body.add_checkin' => TranslationOverrides.string(_root.$meta, 'body.add_checkin', {}) ?? 'Add check-in',
			'body.chart_hint' => TranslationOverrides.string(_root.$meta, 'body.chart_hint', {}) ?? 'Chart appears after 2 check-ins',
			'coach.title' => TranslationOverrides.string(_root.$meta, 'coach.title', {}) ?? 'Coach',
			'coach.daily_assist' => TranslationOverrides.string(_root.$meta, 'coach.daily_assist', {}) ?? 'Daily assist',
			'coach.daily_assist_body' => TranslationOverrides.string(_root.$meta, 'coach.daily_assist_body', {}) ?? 'On-device tips and local reminders. No account, no cloud coach.',
			'coach.guides' => TranslationOverrides.string(_root.$meta, 'coach.guides', {}) ?? 'Guides',
			'coach.today_tips' => TranslationOverrides.string(_root.$meta, 'coach.today_tips', {}) ?? 'Today tips',
			'coach.push_checkin' => TranslationOverrides.string(_root.$meta, 'coach.push_checkin', {}) ?? 'Push check-in',
			'coach.next_topic' => TranslationOverrides.string(_root.$meta, 'coach.next_topic', {}) ?? 'Next topic',
			'coach.local_reminders' => TranslationOverrides.string(_root.$meta, 'coach.local_reminders', {}) ?? 'Local reminders',
			'coach.warn_over_goal' => TranslationOverrides.string(_root.$meta, 'coach.warn_over_goal', {}) ?? 'Warn when over goal',
			'coach.journal' => TranslationOverrides.string(_root.$meta, 'coach.journal', {}) ?? 'How did today feel?',
			'coach.journal_hint' => TranslationOverrides.string(_root.$meta, 'coach.journal_hint', {}) ?? 'One honest line beats a perfect diary.',
			'coach.save_note' => TranslationOverrides.string(_root.$meta, 'coach.save_note', {}) ?? 'Save note',
			'coach.long_press_delete' => TranslationOverrides.string(_root.$meta, 'coach.long_press_delete', {}) ?? 'Long-press to delete',
			'coach.health_coach' => TranslationOverrides.string(_root.$meta, 'coach.health_coach', {}) ?? 'Health coach',
			'coach.food_coach' => TranslationOverrides.string(_root.$meta, 'coach.food_coach', {}) ?? 'Food coach',
			'coach.loading_webllm' => TranslationOverrides.string(_root.$meta, 'coach.loading_webllm', {}) ?? 'Loading WebLLM…',
			'onboarding.welcome_title' => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_title', {}) ?? 'Train with clarity',
			'onboarding.welcome_body' => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_body', {}) ?? 'AURA keeps calories, water, and coaching on this device.',
			'onboarding.body_title' => TranslationOverrides.string(_root.$meta, 'onboarding.body_title', {}) ?? 'Body baseline',
			'onboarding.body_body' => TranslationOverrides.string(_root.$meta, 'onboarding.body_body', {}) ?? 'Height, weight, and activity set your daily energy target.',
			'onboarding.name_title' => TranslationOverrides.string(_root.$meta, 'onboarding.name_title', {}) ?? 'What should we call you?',
			'onboarding.name_hint' => TranslationOverrides.string(_root.$meta, 'onboarding.name_hint', {}) ?? 'Display name',
			'onboarding.ready_title' => TranslationOverrides.string(_root.$meta, 'onboarding.ready_title', {}) ?? 'Enter AURA',
			'onboarding.ready_body' => TranslationOverrides.string(_root.$meta, 'onboarding.ready_body', {}) ?? 'Your local profile is ready. Permissions come next.',
			'onboarding.kContinue' => TranslationOverrides.string(_root.$meta, 'onboarding.kContinue', {}) ?? 'Continue',
			'onboarding.back' => TranslationOverrides.string(_root.$meta, 'onboarding.back', {}) ?? 'Back',
			'permissions.intro_title' => TranslationOverrides.string(_root.$meta, 'permissions.intro_title', {}) ?? 'Unlock a sharper day',
			'permissions.intro_body' => TranslationOverrides.string(_root.$meta, 'permissions.intro_body', {}) ?? 'Local reminders and motion help AURA pace your day. You can skip any step.',
			'permissions.notifications_title' => TranslationOverrides.string(_root.$meta, 'permissions.notifications_title', {}) ?? 'Allow notifications',
			'permissions.notifications_body' => TranslationOverrides.string(_root.$meta, 'permissions.notifications_body', {}) ?? 'Meal, water, and movement nudges stay on this phone.',
			'permissions.location_title' => TranslationOverrides.string(_root.$meta, 'permissions.location_title', {}) ?? 'Location while using',
			'permissions.location_body' => TranslationOverrides.string(_root.$meta, 'permissions.location_body', {}) ?? 'Optional context for outdoor sessions — not background tracking.',
			'permissions.fitness_title' => TranslationOverrides.string(_root.$meta, 'permissions.fitness_title', {}) ?? 'Motion & fitness',
			'permissions.fitness_body' => TranslationOverrides.string(_root.$meta, 'permissions.fitness_body', {}) ?? 'Improves burn estimates from activity on this device.',
			'permissions.allow' => TranslationOverrides.string(_root.$meta, 'permissions.allow', {}) ?? 'Allow',
			'permissions.not_now' => TranslationOverrides.string(_root.$meta, 'permissions.not_now', {}) ?? 'Not now',
			'profile.athlete_fallback' => TranslationOverrides.string(_root.$meta, 'profile.athlete_fallback', {}) ?? 'Athlete',
			'profile.subtitle' => TranslationOverrides.string(_root.$meta, 'profile.subtitle', {}) ?? 'Local AURA profile · gym baseline',
			'profile.edit_in_body' => TranslationOverrides.string(_root.$meta, 'profile.edit_in_body', {}) ?? 'Edit in Body',
			'profile.replay_onboarding' => TranslationOverrides.string(_root.$meta, 'profile.replay_onboarding', {}) ?? 'Replay onboarding',
			'profile.review_permissions' => TranslationOverrides.string(_root.$meta, 'profile.review_permissions', {}) ?? 'Review permissions',
			'sheets.log_food_title' => TranslationOverrides.string(_root.$meta, 'sheets.log_food_title', {}) ?? 'Log food',
			'sheets.log_food_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.log_food_subtitle', {}) ?? 'Stay on Today — pick a meal, then a preset.',
			'sheets.add_water_title' => TranslationOverrides.string(_root.$meta, 'sheets.add_water_title', {}) ?? 'Add water',
			'sheets.add_water_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.add_water_subtitle', {}) ?? 'One tap keeps the hydration ring honest.',
			'sheets.log_burn_title' => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_title', {}) ?? 'Log burn',
			'sheets.log_burn_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_subtitle', {}) ?? 'Capture movement without leaving Today.',
			'sheets.coach_pulse_title' => TranslationOverrides.string(_root.$meta, 'sheets.coach_pulse_title', {}) ?? 'Coach pulse',
			'sheets.quick_journal' => TranslationOverrides.string(_root.$meta, 'sheets.quick_journal', {}) ?? 'Quick journal',
			'sheets.open_full_coach' => TranslationOverrides.string(_root.$meta, 'sheets.open_full_coach', {}) ?? 'Open full Coach',
			'sheets.what_logging' => TranslationOverrides.string(_root.$meta, 'sheets.what_logging', {}) ?? 'What are you logging?',
			'sheets.notifications' => TranslationOverrides.string(_root.$meta, 'sheets.notifications', {}) ?? 'Notifications',
			'sheets.no_notifications' => TranslationOverrides.string(_root.$meta, 'sheets.no_notifications', {}) ?? 'No notifications yet.',
			'tips.today_tag' => TranslationOverrides.string(_root.$meta, 'tips.today_tag', {}) ?? 'Today',
			'tips.today_title' => TranslationOverrides.string(_root.$meta, 'tips.today_title', {}) ?? 'One glance, then move',
			'tips.today_body' => TranslationOverrides.string(_root.$meta, 'tips.today_body', {}) ?? 'Check remaining kcal and the ring first. If warnings are empty, skip deep menus and log the next meal in under 20 seconds.',
			'tips.log_tag' => TranslationOverrides.string(_root.$meta, 'tips.log_tag', {}) ?? 'Log',
			'tips.log_title' => TranslationOverrides.string(_root.$meta, 'tips.log_title', {}) ?? 'Presets beat perfect grams',
			'tips.log_body' => TranslationOverrides.string(_root.$meta, 'tips.log_body', {}) ?? 'Tap a quick-add before you hunt labels. Honest estimates beat empty days — you can refine custom entries later.',
			'tips.body_tag' => TranslationOverrides.string(_root.$meta, 'tips.body_tag', {}) ?? 'Body',
			'tips.body_title' => TranslationOverrides.string(_root.$meta, 'tips.body_title', {}) ?? 'Set the body once a week',
			'tips.body_body' => TranslationOverrides.string(_root.$meta, 'tips.body_body', {}) ?? 'Height, weight, and activity drive BMR/TDEE. Update weight weekly; daily noise makes goals jittery.',
			'tips.coach_tag' => TranslationOverrides.string(_root.$meta, 'tips.coach_tag', {}) ?? 'Coach',
			'tips.coach_title' => TranslationOverrides.string(_root.$meta, 'tips.coach_title', {}) ?? 'Ask for the next action',
			'tips.coach_body' => TranslationOverrides.string(_root.$meta, 'tips.coach_body', {}) ?? 'On a real iPhone, open Health or Food coach. Give today’s summary and ask for one meal or one walk — not a full diet overhaul.',
			'tips.widget_tag' => TranslationOverrides.string(_root.$meta, 'tips.widget_tag', {}) ?? 'Widget',
			'tips.widget_title' => TranslationOverrides.string(_root.$meta, 'tips.widget_title', {}) ?? 'Pin the glance surface',
			'tips.widget_body' => TranslationOverrides.string(_root.$meta, 'tips.widget_body', {}) ?? 'Add the AURA Today widget and start a Live Activity before lunch. The island should answer “how much left?” without opening the app.',
			'tips.water_tag' => TranslationOverrides.string(_root.$meta, 'tips.water_tag', {}) ?? 'Water',
			'tips.water_title' => TranslationOverrides.string(_root.$meta, 'tips.water_title', {}) ?? 'Stack water with habits',
			'tips.water_body' => TranslationOverrides.string(_root.$meta, 'tips.water_body', {}) ?? 'Log +250 ml when you sit down to work or finish a set. Water goals unlock cleaner coach warnings by late afternoon.',
			'empty.generic_title' => TranslationOverrides.string(_root.$meta, 'empty.generic_title', {}) ?? 'Nothing here yet',
			'empty.generic_body' => TranslationOverrides.string(_root.$meta, 'empty.generic_body', {}) ?? 'When you add data, it will show up in this space.',
			_ => null,
		};
	}
}
