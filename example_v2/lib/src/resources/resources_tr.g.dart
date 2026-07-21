///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'package:slang/overrides.dart';
import 'resources.g.dart';

// Path: <root>
class TranslationsTr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.tr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <tr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsTr _root = this; // ignore: unused_field

	@override 
	TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$tr common = _Translations$common$tr._(_root);
	@override late final _Translations$tabs$tr tabs = _Translations$tabs$tr._(_root);
	@override late final _Translations$settings$tr settings = _Translations$settings$tr._(_root);
	@override late final _Translations$meals$tr meals = _Translations$meals$tr._(_root);
	@override late final _Translations$activity$tr activity = _Translations$activity$tr._(_root);
	@override late final _Translations$goals$tr goals = _Translations$goals$tr._(_root);
	@override late final _Translations$sex$tr sex = _Translations$sex$tr._(_root);
	@override late final _Translations$today$tr today = _Translations$today$tr._(_root);
	@override late final _Translations$log$tr log = _Translations$log$tr._(_root);
	@override late final _Translations$body$tr body = _Translations$body$tr._(_root);
	@override late final _Translations$coach$tr coach = _Translations$coach$tr._(_root);
	@override late final _Translations$onboarding$tr onboarding = _Translations$onboarding$tr._(_root);
	@override late final _Translations$permissions$tr permissions = _Translations$permissions$tr._(_root);
	@override late final _Translations$profile$tr profile = _Translations$profile$tr._(_root);
	@override late final _Translations$sheets$tr sheets = _Translations$sheets$tr._(_root);
	@override late final _Translations$tips$tr tips = _Translations$tips$tr._(_root);
	@override late final _Translations$empty$tr empty = _Translations$empty$tr._(_root);
}

// Path: common
class _Translations$common$tr implements Translations$common$en {
	_Translations$common$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get ok => TranslationOverrides.string(_root.$meta, 'common.ok', {}) ?? 'Tamam';
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Vazgeç';
	@override String get save => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Kaydet';
	@override String get delete => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Sil';
	@override String get edit => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Düzenle';
	@override String get close => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Kapat';
	@override String get back => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Geri';
	@override String get next => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'İleri';
	@override String get kContinue => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Devam';
	@override String get done => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Bitti';
	@override String get loading => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Yükleniyor…';
	@override String get retry => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Yeniden dene';
	@override String get refresh => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Yenile';
	@override String get not_now => TranslationOverrides.string(_root.$meta, 'common.not_now', {}) ?? 'Şimdi değil';
	@override String get remove => TranslationOverrides.string(_root.$meta, 'common.remove', {}) ?? 'Kaldır';
	@override String get kcal => TranslationOverrides.string(_root.$meta, 'common.kcal', {}) ?? 'kcal';
	@override String get ml => TranslationOverrides.string(_root.$meta, 'common.ml', {}) ?? 'ml';
	@override String get cm => TranslationOverrides.string(_root.$meta, 'common.cm', {}) ?? 'cm';
	@override String get kg => TranslationOverrides.string(_root.$meta, 'common.kg', {}) ?? 'kg';
	@override String get on => TranslationOverrides.string(_root.$meta, 'common.on', {}) ?? 'Açık';
	@override String get off => TranslationOverrides.string(_root.$meta, 'common.off', {}) ?? 'Kapalı';
}

// Path: tabs
class _Translations$tabs$tr implements Translations$tabs$en {
	_Translations$tabs$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get today => TranslationOverrides.string(_root.$meta, 'tabs.today', {}) ?? 'Bugün';
	@override String get log => TranslationOverrides.string(_root.$meta, 'tabs.log', {}) ?? 'Kayıt';
	@override String get body => TranslationOverrides.string(_root.$meta, 'tabs.body', {}) ?? 'Vücut';
	@override String get coach => TranslationOverrides.string(_root.$meta, 'tabs.coach', {}) ?? 'Koç';
}

// Path: settings
class _Translations$settings$tr implements Translations$settings$en {
	_Translations$settings$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get language => TranslationOverrides.string(_root.$meta, 'settings.language', {}) ?? 'Dil';
	@override String get english => TranslationOverrides.string(_root.$meta, 'settings.english', {}) ?? 'English';
	@override String get turkish => TranslationOverrides.string(_root.$meta, 'settings.turkish', {}) ?? 'Türkçe';
	@override String get appearance => TranslationOverrides.string(_root.$meta, 'settings.appearance', {}) ?? 'Görünüm';
	@override String get theme_light => TranslationOverrides.string(_root.$meta, 'settings.theme_light', {}) ?? 'Açık';
	@override String get theme_dark => TranslationOverrides.string(_root.$meta, 'settings.theme_dark', {}) ?? 'Koyu';
	@override String get theme_system => TranslationOverrides.string(_root.$meta, 'settings.theme_system', {}) ?? 'Sistem';
	@override String get font_scale => TranslationOverrides.string(_root.$meta, 'settings.font_scale', {}) ?? 'Yazı boyutu';
}

// Path: meals
class _Translations$meals$tr implements Translations$meals$en {
	_Translations$meals$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get breakfast => TranslationOverrides.string(_root.$meta, 'meals.breakfast', {}) ?? 'Kahvaltı';
	@override String get lunch => TranslationOverrides.string(_root.$meta, 'meals.lunch', {}) ?? 'Öğle';
	@override String get dinner => TranslationOverrides.string(_root.$meta, 'meals.dinner', {}) ?? 'Akşam';
	@override String get snack => TranslationOverrides.string(_root.$meta, 'meals.snack', {}) ?? 'Atıştırmalık';
	@override String get drink => TranslationOverrides.string(_root.$meta, 'meals.drink', {}) ?? 'İçecek';
	@override String get breakfast_caption => TranslationOverrides.string(_root.$meta, 'meals.breakfast_caption', {}) ?? 'Güne yakıtla başla';
	@override String get lunch_caption => TranslationOverrides.string(_root.$meta, 'meals.lunch_caption', {}) ?? 'Gündüz tabağı';
	@override String get dinner_caption => TranslationOverrides.string(_root.$meta, 'meals.dinner_caption', {}) ?? 'Akşam öğünü';
	@override String get snack_caption => TranslationOverrides.string(_root.$meta, 'meals.snack_caption', {}) ?? 'Küçük takviye';
	@override String get drink_caption => TranslationOverrides.string(_root.$meta, 'meals.drink_caption', {}) ?? 'Su ve yudumlar';
}

// Path: activity
class _Translations$activity$tr implements Translations$activity$en {
	_Translations$activity$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get sedentary => TranslationOverrides.string(_root.$meta, 'activity.sedentary', {}) ?? 'Hareketsiz';
	@override String get light => TranslationOverrides.string(_root.$meta, 'activity.light', {}) ?? 'Hafif';
	@override String get moderate => TranslationOverrides.string(_root.$meta, 'activity.moderate', {}) ?? 'Orta';
	@override String get active => TranslationOverrides.string(_root.$meta, 'activity.active', {}) ?? 'Aktif';
	@override String get very_active => TranslationOverrides.string(_root.$meta, 'activity.very_active', {}) ?? 'Çok aktif';
}

// Path: goals
class _Translations$goals$tr implements Translations$goals$en {
	_Translations$goals$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get lose => TranslationOverrides.string(_root.$meta, 'goals.lose', {}) ?? 'Kes';
	@override String get maintain => TranslationOverrides.string(_root.$meta, 'goals.maintain', {}) ?? 'Koruma';
	@override String get gain => TranslationOverrides.string(_root.$meta, 'goals.gain', {}) ?? 'Kütle';
	@override String get recomp => TranslationOverrides.string(_root.$meta, 'goals.recomp', {}) ?? 'Rekomp';
}

// Path: sex
class _Translations$sex$tr implements Translations$sex$en {
	_Translations$sex$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get woman => TranslationOverrides.string(_root.$meta, 'sex.woman', {}) ?? 'Kadın';
	@override String get man => TranslationOverrides.string(_root.$meta, 'sex.man', {}) ?? 'Erkek';
}

// Path: today
class _Translations$today$tr implements Translations$today$en {
	_Translations$today$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get eaten => TranslationOverrides.string(_root.$meta, 'today.eaten', {}) ?? 'Yenilen';
	@override String get burned => TranslationOverrides.string(_root.$meta, 'today.burned', {}) ?? 'Yakılan';
	@override String get water => TranslationOverrides.string(_root.$meta, 'today.water', {}) ?? 'Su';
	@override String kcal_remaining({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.kcal_remaining', {'goal': goal}) ?? 'kcal kaldı · hedef ${goal}';
	@override String get add_food => TranslationOverrides.string(_root.$meta, 'today.add_food', {}) ?? 'Yemek ekle';
	@override String get add_water => TranslationOverrides.string(_root.$meta, 'today.add_water', {}) ?? 'Su ekle';
	@override String get open_coach => TranslationOverrides.string(_root.$meta, 'today.open_coach', {}) ?? 'Koçu aç';
	@override String get log_burn => TranslationOverrides.string(_root.$meta, 'today.log_burn', {}) ?? 'Yakım kaydet';
	@override String get nutrition => TranslationOverrides.string(_root.$meta, 'today.nutrition', {}) ?? 'Beslenme';
	@override String get nutrition_subtitle => TranslationOverrides.string(_root.$meta, 'today.nutrition_subtitle', {}) ?? 'Protein, karbonhidrat ve yağ — günlük hedeflere göre';
	@override String get protein => TranslationOverrides.string(_root.$meta, 'today.protein', {}) ?? 'Protein';
	@override String get carbs => TranslationOverrides.string(_root.$meta, 'today.carbs', {}) ?? 'Karbonhidrat';
	@override String get fat => TranslationOverrides.string(_root.$meta, 'today.fat', {}) ?? 'Yağ';
	@override String get alerts => TranslationOverrides.string(_root.$meta, 'today.alerts', {}) ?? 'Uyarılar';
	@override String get all_clear => TranslationOverrides.string(_root.$meta, 'today.all_clear', {}) ?? 'Her şey yolunda';
	@override String get needs_look => TranslationOverrides.string(_root.$meta, 'today.needs_look', {}) ?? 'Göz atılmalı';
	@override String get no_alerts => TranslationOverrides.string(_root.$meta, 'today.no_alerts', {}) ?? 'Şu an uyarı yok. Kayıt etmeye devam et.';
	@override String get home_widget => TranslationOverrides.string(_root.$meta, 'today.home_widget', {}) ?? 'Ana ekran widget’ı';
	@override String get refresh_widget => TranslationOverrides.string(_root.$meta, 'today.refresh_widget', {}) ?? 'Widget’ı yenile';
	@override String get widget_hint => TranslationOverrides.string(_root.$meta, 'today.widget_hint', {}) ?? 'Uygulamayı açmadan bakmak için AURA Bugün widget’ını ekle.';
}

// Path: log
class _Translations$log$tr implements Translations$log$en {
	_Translations$log$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'log.title', {}) ?? 'Kayıt';
	@override String get subtitle_today => TranslationOverrides.string(_root.$meta, 'log.subtitle_today', {}) ?? 'Bugünün öğün ve yakımlarını kaydet.';
	@override String get subtitle_past => TranslationOverrides.string(_root.$meta, 'log.subtitle_past', {}) ?? 'Bu günün kayıtlarını gözden geçir.';
	@override String get today_balance => TranslationOverrides.string(_root.$meta, 'log.today_balance', {}) ?? 'Bugünün dengesi';
	@override String get quick_add => TranslationOverrides.string(_root.$meta, 'log.quick_add', {}) ?? 'Hızlı ekle';
	@override String get custom => TranslationOverrides.string(_root.$meta, 'log.custom', {}) ?? 'Özel';
	@override String get burn => TranslationOverrides.string(_root.$meta, 'log.burn', {}) ?? 'Yakım';
	@override String get logged_today => TranslationOverrides.string(_root.$meta, 'log.logged_today', {}) ?? 'Bugün kaydedilenler';
	@override String get empty => TranslationOverrides.string(_root.$meta, 'log.empty', {}) ?? 'Henüz yok. Bir öğün veya yakımla başla.';
	@override String get remove_confirm => TranslationOverrides.string(_root.$meta, 'log.remove_confirm', {}) ?? 'Kayıt kaldırılsın mı?';
	@override String custom_title({required Object meal}) => TranslationOverrides.string(_root.$meta, 'log.custom_title', {'meal': meal}) ?? 'Özel ${meal}';
	@override String get name_needed => TranslationOverrides.string(_root.$meta, 'log.name_needed', {}) ?? 'İsim gerekli';
	@override String get macros => TranslationOverrides.string(_root.$meta, 'log.macros', {}) ?? 'Makrolar (g)';
	@override String get save_entry => TranslationOverrides.string(_root.$meta, 'log.save_entry', {}) ?? 'Kaydi kaydet';
	@override String get saving => TranslationOverrides.string(_root.$meta, 'log.saving', {}) ?? 'Kaydediliyor…';
}

// Path: body
class _Translations$body$tr implements Translations$body$en {
	_Translations$body$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'body.title', {}) ?? 'Vücut';
	@override String get overview => TranslationOverrides.string(_root.$meta, 'body.overview', {}) ?? 'Özet';
	@override String get athlete => TranslationOverrides.string(_root.$meta, 'body.athlete', {}) ?? 'Sporcu';
	@override String get bmi => TranslationOverrides.string(_root.$meta, 'body.bmi', {}) ?? 'Vücut kitle indeksi';
	@override String get bmr => TranslationOverrides.string(_root.$meta, 'body.bmr', {}) ?? 'BMR';
	@override String get tdee => TranslationOverrides.string(_root.$meta, 'body.tdee', {}) ?? 'TDEE';
	@override String get goal => TranslationOverrides.string(_root.$meta, 'body.goal', {}) ?? 'Hedef';
	@override String get height => TranslationOverrides.string(_root.$meta, 'body.height', {}) ?? 'Boy';
	@override String get weight => TranslationOverrides.string(_root.$meta, 'body.weight', {}) ?? 'Kilo';
	@override String get age => TranslationOverrides.string(_root.$meta, 'body.age', {}) ?? 'Yaş';
	@override String get sex => TranslationOverrides.string(_root.$meta, 'body.sex', {}) ?? 'Cinsiyet';
	@override String get body_type => TranslationOverrides.string(_root.$meta, 'body.body_type', {}) ?? 'Vücut tipi';
	@override String get activity => TranslationOverrides.string(_root.$meta, 'body.activity', {}) ?? 'Aktivite';
	@override String get using_tdee => TranslationOverrides.string(_root.$meta, 'body.using_tdee', {}) ?? 'Hedef olarak hesaplanan TDEE kullanılıyor.';
	@override String get set_custom_goal => TranslationOverrides.string(_root.$meta, 'body.set_custom_goal', {}) ?? 'Özel hedef (−300)';
	@override String get reset_tdee => TranslationOverrides.string(_root.$meta, 'body.reset_tdee', {}) ?? 'TDEE’ye dön';
	@override String get body_change => TranslationOverrides.string(_root.$meta, 'body.body_change', {}) ?? 'Vücut değişimi';
	@override String get need_checkins => TranslationOverrides.string(_root.$meta, 'body.need_checkins', {}) ?? 'En az 2 ölçüm gerekli';
	@override String get add_checkin => TranslationOverrides.string(_root.$meta, 'body.add_checkin', {}) ?? 'Ölçüm ekle';
	@override String get chart_hint => TranslationOverrides.string(_root.$meta, 'body.chart_hint', {}) ?? 'Grafik 2 ölçümden sonra görünür';
}

// Path: coach
class _Translations$coach$tr implements Translations$coach$en {
	_Translations$coach$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get title => TranslationOverrides.string(_root.$meta, 'coach.title', {}) ?? 'Koç';
	@override String get daily_assist => TranslationOverrides.string(_root.$meta, 'coach.daily_assist', {}) ?? 'Günlük destek';
	@override String get daily_assist_body => TranslationOverrides.string(_root.$meta, 'coach.daily_assist_body', {}) ?? 'Cihaz içi ipuçları ve yerel hatırlatmalar. Hesap yok, bulut koç yok.';
	@override String get guides => TranslationOverrides.string(_root.$meta, 'coach.guides', {}) ?? 'Rehberler';
	@override String get today_tips => TranslationOverrides.string(_root.$meta, 'coach.today_tips', {}) ?? 'Bugünün ipuçları';
	@override String get push_checkin => TranslationOverrides.string(_root.$meta, 'coach.push_checkin', {}) ?? 'Kontrol bildirimi';
	@override String get next_topic => TranslationOverrides.string(_root.$meta, 'coach.next_topic', {}) ?? 'Sonraki konu';
	@override String get local_reminders => TranslationOverrides.string(_root.$meta, 'coach.local_reminders', {}) ?? 'Yerel hatırlatmalar';
	@override String get warn_over_goal => TranslationOverrides.string(_root.$meta, 'coach.warn_over_goal', {}) ?? 'Hedefi aşınca uyar';
	@override String get journal => TranslationOverrides.string(_root.$meta, 'coach.journal', {}) ?? 'Bugün nasıl hissettin?';
	@override String get journal_hint => TranslationOverrides.string(_root.$meta, 'coach.journal_hint', {}) ?? 'Dürüst bir satır, mükemmel bir günlükten iyidir.';
	@override String get save_note => TranslationOverrides.string(_root.$meta, 'coach.save_note', {}) ?? 'Notu kaydet';
	@override String get long_press_delete => TranslationOverrides.string(_root.$meta, 'coach.long_press_delete', {}) ?? 'Silmek için basılı tut';
	@override String get health_coach => TranslationOverrides.string(_root.$meta, 'coach.health_coach', {}) ?? 'Sağlık koçu';
	@override String get food_coach => TranslationOverrides.string(_root.$meta, 'coach.food_coach', {}) ?? 'Beslenme koçu';
	@override String get loading_webllm => TranslationOverrides.string(_root.$meta, 'coach.loading_webllm', {}) ?? 'WebLLM yükleniyor…';
}

// Path: onboarding
class _Translations$onboarding$tr implements Translations$onboarding$en {
	_Translations$onboarding$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get welcome_title => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_title', {}) ?? 'Netlikle antrenman';
	@override String get welcome_body => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_body', {}) ?? 'AURA kalori, su ve koçluğu bu cihazda tutar.';
	@override String get body_title => TranslationOverrides.string(_root.$meta, 'onboarding.body_title', {}) ?? 'Vücut temeli';
	@override String get body_body => TranslationOverrides.string(_root.$meta, 'onboarding.body_body', {}) ?? 'Boy, kilo ve aktivite günlük enerji hedefini belirler.';
	@override String get name_title => TranslationOverrides.string(_root.$meta, 'onboarding.name_title', {}) ?? 'Sana nasıl hitap edelim?';
	@override String get name_hint => TranslationOverrides.string(_root.$meta, 'onboarding.name_hint', {}) ?? 'Görünen ad';
	@override String get ready_title => TranslationOverrides.string(_root.$meta, 'onboarding.ready_title', {}) ?? 'AURA’ya gir';
	@override String get ready_body => TranslationOverrides.string(_root.$meta, 'onboarding.ready_body', {}) ?? 'Yerel profilin hazır. Sırada izinler var.';
	@override String get kContinue => TranslationOverrides.string(_root.$meta, 'onboarding.kContinue', {}) ?? 'Devam';
	@override String get back => TranslationOverrides.string(_root.$meta, 'onboarding.back', {}) ?? 'Geri';
}

// Path: permissions
class _Translations$permissions$tr implements Translations$permissions$en {
	_Translations$permissions$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get intro_title => TranslationOverrides.string(_root.$meta, 'permissions.intro_title', {}) ?? 'Daha keskin bir gün';
	@override String get intro_body => TranslationOverrides.string(_root.$meta, 'permissions.intro_body', {}) ?? 'Yerel hatırlatmalar ve hareket AURA’nın temposuna yardım eder. İstediğin adımı atlayabilirsin.';
	@override String get notifications_title => TranslationOverrides.string(_root.$meta, 'permissions.notifications_title', {}) ?? 'Bildirimlere izin ver';
	@override String get notifications_body => TranslationOverrides.string(_root.$meta, 'permissions.notifications_body', {}) ?? 'Öğün, su ve hareket dokunuşları bu telefonda kalır.';
	@override String get location_title => TranslationOverrides.string(_root.$meta, 'permissions.location_title', {}) ?? 'Kullanırken konum';
	@override String get location_body => TranslationOverrides.string(_root.$meta, 'permissions.location_body', {}) ?? 'Açık hava seansları için isteğe bağlı — arka plan takibi yok.';
	@override String get fitness_title => TranslationOverrides.string(_root.$meta, 'permissions.fitness_title', {}) ?? 'Hareket ve fitness';
	@override String get fitness_body => TranslationOverrides.string(_root.$meta, 'permissions.fitness_body', {}) ?? 'Bu cihazdaki aktiviteden yakım tahminini iyileştirir.';
	@override String get allow => TranslationOverrides.string(_root.$meta, 'permissions.allow', {}) ?? 'İzin ver';
	@override String get not_now => TranslationOverrides.string(_root.$meta, 'permissions.not_now', {}) ?? 'Şimdi değil';
}

// Path: profile
class _Translations$profile$tr implements Translations$profile$en {
	_Translations$profile$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get athlete_fallback => TranslationOverrides.string(_root.$meta, 'profile.athlete_fallback', {}) ?? 'Sporcu';
	@override String get subtitle => TranslationOverrides.string(_root.$meta, 'profile.subtitle', {}) ?? 'Yerel AURA profili · salon temeli';
	@override String get edit_in_body => TranslationOverrides.string(_root.$meta, 'profile.edit_in_body', {}) ?? 'Vücut’ta düzenle';
	@override String get replay_onboarding => TranslationOverrides.string(_root.$meta, 'profile.replay_onboarding', {}) ?? 'Kurulumu yeniden oynat';
	@override String get review_permissions => TranslationOverrides.string(_root.$meta, 'profile.review_permissions', {}) ?? 'İzinleri gözden geçir';
}

// Path: sheets
class _Translations$sheets$tr implements Translations$sheets$en {
	_Translations$sheets$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get log_food_title => TranslationOverrides.string(_root.$meta, 'sheets.log_food_title', {}) ?? 'Yemek kaydet';
	@override String get log_food_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.log_food_subtitle', {}) ?? 'Bugün’de kal — öğün seç, sonra hazır öğe.';
	@override String get add_water_title => TranslationOverrides.string(_root.$meta, 'sheets.add_water_title', {}) ?? 'Su ekle';
	@override String get add_water_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.add_water_subtitle', {}) ?? 'Tek dokunuş hidrasyon halkasını dürüst tutar.';
	@override String get log_burn_title => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_title', {}) ?? 'Yakım kaydet';
	@override String get log_burn_subtitle => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_subtitle', {}) ?? 'Bugün’den çıkmadan hareketi kaydet.';
	@override String get coach_pulse_title => TranslationOverrides.string(_root.$meta, 'sheets.coach_pulse_title', {}) ?? 'Koç nabzı';
	@override String get quick_journal => TranslationOverrides.string(_root.$meta, 'sheets.quick_journal', {}) ?? 'Hızlı günlük';
	@override String get open_full_coach => TranslationOverrides.string(_root.$meta, 'sheets.open_full_coach', {}) ?? 'Tam Koç’u aç';
	@override String get what_logging => TranslationOverrides.string(_root.$meta, 'sheets.what_logging', {}) ?? 'Ne kaydediyorsun?';
	@override String get notifications => TranslationOverrides.string(_root.$meta, 'sheets.notifications', {}) ?? 'Bildirimler';
	@override String get no_notifications => TranslationOverrides.string(_root.$meta, 'sheets.no_notifications', {}) ?? 'Henüz bildirim yok.';
}

// Path: tips
class _Translations$tips$tr implements Translations$tips$en {
	_Translations$tips$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get today_tag => TranslationOverrides.string(_root.$meta, 'tips.today_tag', {}) ?? 'Bugün';
	@override String get today_title => TranslationOverrides.string(_root.$meta, 'tips.today_title', {}) ?? 'Bir bakış, sonra hareket';
	@override String get today_body => TranslationOverrides.string(_root.$meta, 'tips.today_body', {}) ?? 'Önce kalan kcal ve halkaya bak. Uyarı yoksa menülere dalma; sonraki öğünü 20 saniyede kaydet.';
	@override String get log_tag => TranslationOverrides.string(_root.$meta, 'tips.log_tag', {}) ?? 'Kayıt';
	@override String get log_title => TranslationOverrides.string(_root.$meta, 'tips.log_title', {}) ?? 'Hazır öğeler gram avından iyidir';
	@override String get log_body => TranslationOverrides.string(_root.$meta, 'tips.log_body', {}) ?? 'Etiket aramadan önce hızlı ekle’ye bas. Dürüst tahmin, boş günden iyidir — özel kayıtları sonra incelersin.';
	@override String get body_tag => TranslationOverrides.string(_root.$meta, 'tips.body_tag', {}) ?? 'Vücut';
	@override String get body_title => TranslationOverrides.string(_root.$meta, 'tips.body_title', {}) ?? 'Vücudu haftada bir ayarla';
	@override String get body_body => TranslationOverrides.string(_root.$meta, 'tips.body_body', {}) ?? 'Boy, kilo ve aktivite BMR/TDEE’yi sürer. Kiloyu haftalık güncelle; günlük gürültü hedefi sarsar.';
	@override String get coach_tag => TranslationOverrides.string(_root.$meta, 'tips.coach_tag', {}) ?? 'Koç';
	@override String get coach_title => TranslationOverrides.string(_root.$meta, 'tips.coach_title', {}) ?? 'Sonraki adımı sor';
	@override String get coach_body => TranslationOverrides.string(_root.$meta, 'tips.coach_body', {}) ?? 'Gerçek iPhone’da Sağlık veya Beslenme koçunu aç. Bugünün özetini ver; tam diyet değil, bir öğün veya bir yürüyüş iste.';
	@override String get widget_tag => TranslationOverrides.string(_root.$meta, 'tips.widget_tag', {}) ?? 'Widget';
	@override String get widget_title => TranslationOverrides.string(_root.$meta, 'tips.widget_title', {}) ?? 'Bakış yüzeyini sabitle';
	@override String get widget_body => TranslationOverrides.string(_root.$meta, 'tips.widget_body', {}) ?? 'AURA Bugün widget’ını ekle ve öğleden önce Live Activity başlat. Ada, uygulamayı açmadan “ne kadar kaldı?” diye cevap vermeli.';
	@override String get water_tag => TranslationOverrides.string(_root.$meta, 'tips.water_tag', {}) ?? 'Su';
	@override String get water_title => TranslationOverrides.string(_root.$meta, 'tips.water_title', {}) ?? 'Suyu alışkanlığa bağla';
	@override String get water_body => TranslationOverrides.string(_root.$meta, 'tips.water_body', {}) ?? 'İşe oturunca veya set bitince +250 ml kaydet. Su hedefi öğleden sonra koç uyarılarını temizler.';
}

// Path: empty
class _Translations$empty$tr implements Translations$empty$en {
	_Translations$empty$tr._(this._root);

	final TranslationsTr _root; // ignore: unused_field

	// Translations
	@override String get generic_title => TranslationOverrides.string(_root.$meta, 'empty.generic_title', {}) ?? 'Henüz bir şey yok';
	@override String get generic_body => TranslationOverrides.string(_root.$meta, 'empty.generic_body', {}) ?? 'Veri eklediğinde bu alanda görünecek.';
}

/// The flat map containing all translations for locale <tr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsTr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.ok' => TranslationOverrides.string(_root.$meta, 'common.ok', {}) ?? 'Tamam',
			'common.cancel' => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Vazgeç',
			'common.save' => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Kaydet',
			'common.delete' => TranslationOverrides.string(_root.$meta, 'common.delete', {}) ?? 'Sil',
			'common.edit' => TranslationOverrides.string(_root.$meta, 'common.edit', {}) ?? 'Düzenle',
			'common.close' => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Kapat',
			'common.back' => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Geri',
			'common.next' => TranslationOverrides.string(_root.$meta, 'common.next', {}) ?? 'İleri',
			'common.kContinue' => TranslationOverrides.string(_root.$meta, 'common.kContinue', {}) ?? 'Devam',
			'common.done' => TranslationOverrides.string(_root.$meta, 'common.done', {}) ?? 'Bitti',
			'common.loading' => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Yükleniyor…',
			'common.retry' => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Yeniden dene',
			'common.refresh' => TranslationOverrides.string(_root.$meta, 'common.refresh', {}) ?? 'Yenile',
			'common.not_now' => TranslationOverrides.string(_root.$meta, 'common.not_now', {}) ?? 'Şimdi değil',
			'common.remove' => TranslationOverrides.string(_root.$meta, 'common.remove', {}) ?? 'Kaldır',
			'common.kcal' => TranslationOverrides.string(_root.$meta, 'common.kcal', {}) ?? 'kcal',
			'common.ml' => TranslationOverrides.string(_root.$meta, 'common.ml', {}) ?? 'ml',
			'common.cm' => TranslationOverrides.string(_root.$meta, 'common.cm', {}) ?? 'cm',
			'common.kg' => TranslationOverrides.string(_root.$meta, 'common.kg', {}) ?? 'kg',
			'common.on' => TranslationOverrides.string(_root.$meta, 'common.on', {}) ?? 'Açık',
			'common.off' => TranslationOverrides.string(_root.$meta, 'common.off', {}) ?? 'Kapalı',
			'tabs.today' => TranslationOverrides.string(_root.$meta, 'tabs.today', {}) ?? 'Bugün',
			'tabs.log' => TranslationOverrides.string(_root.$meta, 'tabs.log', {}) ?? 'Kayıt',
			'tabs.body' => TranslationOverrides.string(_root.$meta, 'tabs.body', {}) ?? 'Vücut',
			'tabs.coach' => TranslationOverrides.string(_root.$meta, 'tabs.coach', {}) ?? 'Koç',
			'settings.language' => TranslationOverrides.string(_root.$meta, 'settings.language', {}) ?? 'Dil',
			'settings.english' => TranslationOverrides.string(_root.$meta, 'settings.english', {}) ?? 'English',
			'settings.turkish' => TranslationOverrides.string(_root.$meta, 'settings.turkish', {}) ?? 'Türkçe',
			'settings.appearance' => TranslationOverrides.string(_root.$meta, 'settings.appearance', {}) ?? 'Görünüm',
			'settings.theme_light' => TranslationOverrides.string(_root.$meta, 'settings.theme_light', {}) ?? 'Açık',
			'settings.theme_dark' => TranslationOverrides.string(_root.$meta, 'settings.theme_dark', {}) ?? 'Koyu',
			'settings.theme_system' => TranslationOverrides.string(_root.$meta, 'settings.theme_system', {}) ?? 'Sistem',
			'settings.font_scale' => TranslationOverrides.string(_root.$meta, 'settings.font_scale', {}) ?? 'Yazı boyutu',
			'meals.breakfast' => TranslationOverrides.string(_root.$meta, 'meals.breakfast', {}) ?? 'Kahvaltı',
			'meals.lunch' => TranslationOverrides.string(_root.$meta, 'meals.lunch', {}) ?? 'Öğle',
			'meals.dinner' => TranslationOverrides.string(_root.$meta, 'meals.dinner', {}) ?? 'Akşam',
			'meals.snack' => TranslationOverrides.string(_root.$meta, 'meals.snack', {}) ?? 'Atıştırmalık',
			'meals.drink' => TranslationOverrides.string(_root.$meta, 'meals.drink', {}) ?? 'İçecek',
			'meals.breakfast_caption' => TranslationOverrides.string(_root.$meta, 'meals.breakfast_caption', {}) ?? 'Güne yakıtla başla',
			'meals.lunch_caption' => TranslationOverrides.string(_root.$meta, 'meals.lunch_caption', {}) ?? 'Gündüz tabağı',
			'meals.dinner_caption' => TranslationOverrides.string(_root.$meta, 'meals.dinner_caption', {}) ?? 'Akşam öğünü',
			'meals.snack_caption' => TranslationOverrides.string(_root.$meta, 'meals.snack_caption', {}) ?? 'Küçük takviye',
			'meals.drink_caption' => TranslationOverrides.string(_root.$meta, 'meals.drink_caption', {}) ?? 'Su ve yudumlar',
			'activity.sedentary' => TranslationOverrides.string(_root.$meta, 'activity.sedentary', {}) ?? 'Hareketsiz',
			'activity.light' => TranslationOverrides.string(_root.$meta, 'activity.light', {}) ?? 'Hafif',
			'activity.moderate' => TranslationOverrides.string(_root.$meta, 'activity.moderate', {}) ?? 'Orta',
			'activity.active' => TranslationOverrides.string(_root.$meta, 'activity.active', {}) ?? 'Aktif',
			'activity.very_active' => TranslationOverrides.string(_root.$meta, 'activity.very_active', {}) ?? 'Çok aktif',
			'goals.lose' => TranslationOverrides.string(_root.$meta, 'goals.lose', {}) ?? 'Kes',
			'goals.maintain' => TranslationOverrides.string(_root.$meta, 'goals.maintain', {}) ?? 'Koruma',
			'goals.gain' => TranslationOverrides.string(_root.$meta, 'goals.gain', {}) ?? 'Kütle',
			'goals.recomp' => TranslationOverrides.string(_root.$meta, 'goals.recomp', {}) ?? 'Rekomp',
			'sex.woman' => TranslationOverrides.string(_root.$meta, 'sex.woman', {}) ?? 'Kadın',
			'sex.man' => TranslationOverrides.string(_root.$meta, 'sex.man', {}) ?? 'Erkek',
			'today.eaten' => TranslationOverrides.string(_root.$meta, 'today.eaten', {}) ?? 'Yenilen',
			'today.burned' => TranslationOverrides.string(_root.$meta, 'today.burned', {}) ?? 'Yakılan',
			'today.water' => TranslationOverrides.string(_root.$meta, 'today.water', {}) ?? 'Su',
			'today.kcal_remaining' => ({required Object goal}) => TranslationOverrides.string(_root.$meta, 'today.kcal_remaining', {'goal': goal}) ?? 'kcal kaldı · hedef ${goal}',
			'today.add_food' => TranslationOverrides.string(_root.$meta, 'today.add_food', {}) ?? 'Yemek ekle',
			'today.add_water' => TranslationOverrides.string(_root.$meta, 'today.add_water', {}) ?? 'Su ekle',
			'today.open_coach' => TranslationOverrides.string(_root.$meta, 'today.open_coach', {}) ?? 'Koçu aç',
			'today.log_burn' => TranslationOverrides.string(_root.$meta, 'today.log_burn', {}) ?? 'Yakım kaydet',
			'today.nutrition' => TranslationOverrides.string(_root.$meta, 'today.nutrition', {}) ?? 'Beslenme',
			'today.nutrition_subtitle' => TranslationOverrides.string(_root.$meta, 'today.nutrition_subtitle', {}) ?? 'Protein, karbonhidrat ve yağ — günlük hedeflere göre',
			'today.protein' => TranslationOverrides.string(_root.$meta, 'today.protein', {}) ?? 'Protein',
			'today.carbs' => TranslationOverrides.string(_root.$meta, 'today.carbs', {}) ?? 'Karbonhidrat',
			'today.fat' => TranslationOverrides.string(_root.$meta, 'today.fat', {}) ?? 'Yağ',
			'today.alerts' => TranslationOverrides.string(_root.$meta, 'today.alerts', {}) ?? 'Uyarılar',
			'today.all_clear' => TranslationOverrides.string(_root.$meta, 'today.all_clear', {}) ?? 'Her şey yolunda',
			'today.needs_look' => TranslationOverrides.string(_root.$meta, 'today.needs_look', {}) ?? 'Göz atılmalı',
			'today.no_alerts' => TranslationOverrides.string(_root.$meta, 'today.no_alerts', {}) ?? 'Şu an uyarı yok. Kayıt etmeye devam et.',
			'today.home_widget' => TranslationOverrides.string(_root.$meta, 'today.home_widget', {}) ?? 'Ana ekran widget’ı',
			'today.refresh_widget' => TranslationOverrides.string(_root.$meta, 'today.refresh_widget', {}) ?? 'Widget’ı yenile',
			'today.widget_hint' => TranslationOverrides.string(_root.$meta, 'today.widget_hint', {}) ?? 'Uygulamayı açmadan bakmak için AURA Bugün widget’ını ekle.',
			'log.title' => TranslationOverrides.string(_root.$meta, 'log.title', {}) ?? 'Kayıt',
			'log.subtitle_today' => TranslationOverrides.string(_root.$meta, 'log.subtitle_today', {}) ?? 'Bugünün öğün ve yakımlarını kaydet.',
			'log.subtitle_past' => TranslationOverrides.string(_root.$meta, 'log.subtitle_past', {}) ?? 'Bu günün kayıtlarını gözden geçir.',
			'log.today_balance' => TranslationOverrides.string(_root.$meta, 'log.today_balance', {}) ?? 'Bugünün dengesi',
			'log.quick_add' => TranslationOverrides.string(_root.$meta, 'log.quick_add', {}) ?? 'Hızlı ekle',
			'log.custom' => TranslationOverrides.string(_root.$meta, 'log.custom', {}) ?? 'Özel',
			'log.burn' => TranslationOverrides.string(_root.$meta, 'log.burn', {}) ?? 'Yakım',
			'log.logged_today' => TranslationOverrides.string(_root.$meta, 'log.logged_today', {}) ?? 'Bugün kaydedilenler',
			'log.empty' => TranslationOverrides.string(_root.$meta, 'log.empty', {}) ?? 'Henüz yok. Bir öğün veya yakımla başla.',
			'log.remove_confirm' => TranslationOverrides.string(_root.$meta, 'log.remove_confirm', {}) ?? 'Kayıt kaldırılsın mı?',
			'log.custom_title' => ({required Object meal}) => TranslationOverrides.string(_root.$meta, 'log.custom_title', {'meal': meal}) ?? 'Özel ${meal}',
			'log.name_needed' => TranslationOverrides.string(_root.$meta, 'log.name_needed', {}) ?? 'İsim gerekli',
			'log.macros' => TranslationOverrides.string(_root.$meta, 'log.macros', {}) ?? 'Makrolar (g)',
			'log.save_entry' => TranslationOverrides.string(_root.$meta, 'log.save_entry', {}) ?? 'Kaydi kaydet',
			'log.saving' => TranslationOverrides.string(_root.$meta, 'log.saving', {}) ?? 'Kaydediliyor…',
			'body.title' => TranslationOverrides.string(_root.$meta, 'body.title', {}) ?? 'Vücut',
			'body.overview' => TranslationOverrides.string(_root.$meta, 'body.overview', {}) ?? 'Özet',
			'body.athlete' => TranslationOverrides.string(_root.$meta, 'body.athlete', {}) ?? 'Sporcu',
			'body.bmi' => TranslationOverrides.string(_root.$meta, 'body.bmi', {}) ?? 'Vücut kitle indeksi',
			'body.bmr' => TranslationOverrides.string(_root.$meta, 'body.bmr', {}) ?? 'BMR',
			'body.tdee' => TranslationOverrides.string(_root.$meta, 'body.tdee', {}) ?? 'TDEE',
			'body.goal' => TranslationOverrides.string(_root.$meta, 'body.goal', {}) ?? 'Hedef',
			'body.height' => TranslationOverrides.string(_root.$meta, 'body.height', {}) ?? 'Boy',
			'body.weight' => TranslationOverrides.string(_root.$meta, 'body.weight', {}) ?? 'Kilo',
			'body.age' => TranslationOverrides.string(_root.$meta, 'body.age', {}) ?? 'Yaş',
			'body.sex' => TranslationOverrides.string(_root.$meta, 'body.sex', {}) ?? 'Cinsiyet',
			'body.body_type' => TranslationOverrides.string(_root.$meta, 'body.body_type', {}) ?? 'Vücut tipi',
			'body.activity' => TranslationOverrides.string(_root.$meta, 'body.activity', {}) ?? 'Aktivite',
			'body.using_tdee' => TranslationOverrides.string(_root.$meta, 'body.using_tdee', {}) ?? 'Hedef olarak hesaplanan TDEE kullanılıyor.',
			'body.set_custom_goal' => TranslationOverrides.string(_root.$meta, 'body.set_custom_goal', {}) ?? 'Özel hedef (−300)',
			'body.reset_tdee' => TranslationOverrides.string(_root.$meta, 'body.reset_tdee', {}) ?? 'TDEE’ye dön',
			'body.body_change' => TranslationOverrides.string(_root.$meta, 'body.body_change', {}) ?? 'Vücut değişimi',
			'body.need_checkins' => TranslationOverrides.string(_root.$meta, 'body.need_checkins', {}) ?? 'En az 2 ölçüm gerekli',
			'body.add_checkin' => TranslationOverrides.string(_root.$meta, 'body.add_checkin', {}) ?? 'Ölçüm ekle',
			'body.chart_hint' => TranslationOverrides.string(_root.$meta, 'body.chart_hint', {}) ?? 'Grafik 2 ölçümden sonra görünür',
			'coach.title' => TranslationOverrides.string(_root.$meta, 'coach.title', {}) ?? 'Koç',
			'coach.daily_assist' => TranslationOverrides.string(_root.$meta, 'coach.daily_assist', {}) ?? 'Günlük destek',
			'coach.daily_assist_body' => TranslationOverrides.string(_root.$meta, 'coach.daily_assist_body', {}) ?? 'Cihaz içi ipuçları ve yerel hatırlatmalar. Hesap yok, bulut koç yok.',
			'coach.guides' => TranslationOverrides.string(_root.$meta, 'coach.guides', {}) ?? 'Rehberler',
			'coach.today_tips' => TranslationOverrides.string(_root.$meta, 'coach.today_tips', {}) ?? 'Bugünün ipuçları',
			'coach.push_checkin' => TranslationOverrides.string(_root.$meta, 'coach.push_checkin', {}) ?? 'Kontrol bildirimi',
			'coach.next_topic' => TranslationOverrides.string(_root.$meta, 'coach.next_topic', {}) ?? 'Sonraki konu',
			'coach.local_reminders' => TranslationOverrides.string(_root.$meta, 'coach.local_reminders', {}) ?? 'Yerel hatırlatmalar',
			'coach.warn_over_goal' => TranslationOverrides.string(_root.$meta, 'coach.warn_over_goal', {}) ?? 'Hedefi aşınca uyar',
			'coach.journal' => TranslationOverrides.string(_root.$meta, 'coach.journal', {}) ?? 'Bugün nasıl hissettin?',
			'coach.journal_hint' => TranslationOverrides.string(_root.$meta, 'coach.journal_hint', {}) ?? 'Dürüst bir satır, mükemmel bir günlükten iyidir.',
			'coach.save_note' => TranslationOverrides.string(_root.$meta, 'coach.save_note', {}) ?? 'Notu kaydet',
			'coach.long_press_delete' => TranslationOverrides.string(_root.$meta, 'coach.long_press_delete', {}) ?? 'Silmek için basılı tut',
			'coach.health_coach' => TranslationOverrides.string(_root.$meta, 'coach.health_coach', {}) ?? 'Sağlık koçu',
			'coach.food_coach' => TranslationOverrides.string(_root.$meta, 'coach.food_coach', {}) ?? 'Beslenme koçu',
			'coach.loading_webllm' => TranslationOverrides.string(_root.$meta, 'coach.loading_webllm', {}) ?? 'WebLLM yükleniyor…',
			'onboarding.welcome_title' => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_title', {}) ?? 'Netlikle antrenman',
			'onboarding.welcome_body' => TranslationOverrides.string(_root.$meta, 'onboarding.welcome_body', {}) ?? 'AURA kalori, su ve koçluğu bu cihazda tutar.',
			'onboarding.body_title' => TranslationOverrides.string(_root.$meta, 'onboarding.body_title', {}) ?? 'Vücut temeli',
			'onboarding.body_body' => TranslationOverrides.string(_root.$meta, 'onboarding.body_body', {}) ?? 'Boy, kilo ve aktivite günlük enerji hedefini belirler.',
			'onboarding.name_title' => TranslationOverrides.string(_root.$meta, 'onboarding.name_title', {}) ?? 'Sana nasıl hitap edelim?',
			'onboarding.name_hint' => TranslationOverrides.string(_root.$meta, 'onboarding.name_hint', {}) ?? 'Görünen ad',
			'onboarding.ready_title' => TranslationOverrides.string(_root.$meta, 'onboarding.ready_title', {}) ?? 'AURA’ya gir',
			'onboarding.ready_body' => TranslationOverrides.string(_root.$meta, 'onboarding.ready_body', {}) ?? 'Yerel profilin hazır. Sırada izinler var.',
			'onboarding.kContinue' => TranslationOverrides.string(_root.$meta, 'onboarding.kContinue', {}) ?? 'Devam',
			'onboarding.back' => TranslationOverrides.string(_root.$meta, 'onboarding.back', {}) ?? 'Geri',
			'permissions.intro_title' => TranslationOverrides.string(_root.$meta, 'permissions.intro_title', {}) ?? 'Daha keskin bir gün',
			'permissions.intro_body' => TranslationOverrides.string(_root.$meta, 'permissions.intro_body', {}) ?? 'Yerel hatırlatmalar ve hareket AURA’nın temposuna yardım eder. İstediğin adımı atlayabilirsin.',
			'permissions.notifications_title' => TranslationOverrides.string(_root.$meta, 'permissions.notifications_title', {}) ?? 'Bildirimlere izin ver',
			'permissions.notifications_body' => TranslationOverrides.string(_root.$meta, 'permissions.notifications_body', {}) ?? 'Öğün, su ve hareket dokunuşları bu telefonda kalır.',
			'permissions.location_title' => TranslationOverrides.string(_root.$meta, 'permissions.location_title', {}) ?? 'Kullanırken konum',
			'permissions.location_body' => TranslationOverrides.string(_root.$meta, 'permissions.location_body', {}) ?? 'Açık hava seansları için isteğe bağlı — arka plan takibi yok.',
			'permissions.fitness_title' => TranslationOverrides.string(_root.$meta, 'permissions.fitness_title', {}) ?? 'Hareket ve fitness',
			'permissions.fitness_body' => TranslationOverrides.string(_root.$meta, 'permissions.fitness_body', {}) ?? 'Bu cihazdaki aktiviteden yakım tahminini iyileştirir.',
			'permissions.allow' => TranslationOverrides.string(_root.$meta, 'permissions.allow', {}) ?? 'İzin ver',
			'permissions.not_now' => TranslationOverrides.string(_root.$meta, 'permissions.not_now', {}) ?? 'Şimdi değil',
			'profile.athlete_fallback' => TranslationOverrides.string(_root.$meta, 'profile.athlete_fallback', {}) ?? 'Sporcu',
			'profile.subtitle' => TranslationOverrides.string(_root.$meta, 'profile.subtitle', {}) ?? 'Yerel AURA profili · salon temeli',
			'profile.edit_in_body' => TranslationOverrides.string(_root.$meta, 'profile.edit_in_body', {}) ?? 'Vücut’ta düzenle',
			'profile.replay_onboarding' => TranslationOverrides.string(_root.$meta, 'profile.replay_onboarding', {}) ?? 'Kurulumu yeniden oynat',
			'profile.review_permissions' => TranslationOverrides.string(_root.$meta, 'profile.review_permissions', {}) ?? 'İzinleri gözden geçir',
			'sheets.log_food_title' => TranslationOverrides.string(_root.$meta, 'sheets.log_food_title', {}) ?? 'Yemek kaydet',
			'sheets.log_food_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.log_food_subtitle', {}) ?? 'Bugün’de kal — öğün seç, sonra hazır öğe.',
			'sheets.add_water_title' => TranslationOverrides.string(_root.$meta, 'sheets.add_water_title', {}) ?? 'Su ekle',
			'sheets.add_water_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.add_water_subtitle', {}) ?? 'Tek dokunuş hidrasyon halkasını dürüst tutar.',
			'sheets.log_burn_title' => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_title', {}) ?? 'Yakım kaydet',
			'sheets.log_burn_subtitle' => TranslationOverrides.string(_root.$meta, 'sheets.log_burn_subtitle', {}) ?? 'Bugün’den çıkmadan hareketi kaydet.',
			'sheets.coach_pulse_title' => TranslationOverrides.string(_root.$meta, 'sheets.coach_pulse_title', {}) ?? 'Koç nabzı',
			'sheets.quick_journal' => TranslationOverrides.string(_root.$meta, 'sheets.quick_journal', {}) ?? 'Hızlı günlük',
			'sheets.open_full_coach' => TranslationOverrides.string(_root.$meta, 'sheets.open_full_coach', {}) ?? 'Tam Koç’u aç',
			'sheets.what_logging' => TranslationOverrides.string(_root.$meta, 'sheets.what_logging', {}) ?? 'Ne kaydediyorsun?',
			'sheets.notifications' => TranslationOverrides.string(_root.$meta, 'sheets.notifications', {}) ?? 'Bildirimler',
			'sheets.no_notifications' => TranslationOverrides.string(_root.$meta, 'sheets.no_notifications', {}) ?? 'Henüz bildirim yok.',
			'tips.today_tag' => TranslationOverrides.string(_root.$meta, 'tips.today_tag', {}) ?? 'Bugün',
			'tips.today_title' => TranslationOverrides.string(_root.$meta, 'tips.today_title', {}) ?? 'Bir bakış, sonra hareket',
			'tips.today_body' => TranslationOverrides.string(_root.$meta, 'tips.today_body', {}) ?? 'Önce kalan kcal ve halkaya bak. Uyarı yoksa menülere dalma; sonraki öğünü 20 saniyede kaydet.',
			'tips.log_tag' => TranslationOverrides.string(_root.$meta, 'tips.log_tag', {}) ?? 'Kayıt',
			'tips.log_title' => TranslationOverrides.string(_root.$meta, 'tips.log_title', {}) ?? 'Hazır öğeler gram avından iyidir',
			'tips.log_body' => TranslationOverrides.string(_root.$meta, 'tips.log_body', {}) ?? 'Etiket aramadan önce hızlı ekle’ye bas. Dürüst tahmin, boş günden iyidir — özel kayıtları sonra incelersin.',
			'tips.body_tag' => TranslationOverrides.string(_root.$meta, 'tips.body_tag', {}) ?? 'Vücut',
			'tips.body_title' => TranslationOverrides.string(_root.$meta, 'tips.body_title', {}) ?? 'Vücudu haftada bir ayarla',
			'tips.body_body' => TranslationOverrides.string(_root.$meta, 'tips.body_body', {}) ?? 'Boy, kilo ve aktivite BMR/TDEE’yi sürer. Kiloyu haftalık güncelle; günlük gürültü hedefi sarsar.',
			'tips.coach_tag' => TranslationOverrides.string(_root.$meta, 'tips.coach_tag', {}) ?? 'Koç',
			'tips.coach_title' => TranslationOverrides.string(_root.$meta, 'tips.coach_title', {}) ?? 'Sonraki adımı sor',
			'tips.coach_body' => TranslationOverrides.string(_root.$meta, 'tips.coach_body', {}) ?? 'Gerçek iPhone’da Sağlık veya Beslenme koçunu aç. Bugünün özetini ver; tam diyet değil, bir öğün veya bir yürüyüş iste.',
			'tips.widget_tag' => TranslationOverrides.string(_root.$meta, 'tips.widget_tag', {}) ?? 'Widget',
			'tips.widget_title' => TranslationOverrides.string(_root.$meta, 'tips.widget_title', {}) ?? 'Bakış yüzeyini sabitle',
			'tips.widget_body' => TranslationOverrides.string(_root.$meta, 'tips.widget_body', {}) ?? 'AURA Bugün widget’ını ekle ve öğleden önce Live Activity başlat. Ada, uygulamayı açmadan “ne kadar kaldı?” diye cevap vermeli.',
			'tips.water_tag' => TranslationOverrides.string(_root.$meta, 'tips.water_tag', {}) ?? 'Su',
			'tips.water_title' => TranslationOverrides.string(_root.$meta, 'tips.water_title', {}) ?? 'Suyu alışkanlığa bağla',
			'tips.water_body' => TranslationOverrides.string(_root.$meta, 'tips.water_body', {}) ?? 'İşe oturunca veya set bitince +250 ml kaydet. Su hedefi öğleden sonra koç uyarılarını temizler.',
			'empty.generic_title' => TranslationOverrides.string(_root.$meta, 'empty.generic_title', {}) ?? 'Henüz bir şey yok',
			'empty.generic_body' => TranslationOverrides.string(_root.$meta, 'empty.generic_body', {}) ?? 'Veri eklediğinde bu alanda görünecek.',
			_ => null,
		};
	}
}
