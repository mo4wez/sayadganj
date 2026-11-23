// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Baluchi (`bal`).
class AppLocalizationsBal extends AppLocalizations {
  AppLocalizationsBal([String locale = 'bal']) : super(locale);

  @override
  String get appTitle => 'سیدگنج';

  @override
  String get appSubtitle => 'سیدگنج — بلوچی بزانت‌بلد';

  @override
  String get searchHint => 'گالے بہ شوهاز...';

  @override
  String get wordOfTheDay => 'روچ ءِ گال';

  @override
  String get luckyWord => 'پدیمیں گال';

  @override
  String get readFullDefinition => 'سرجمیں بزانت ءَ بوان';

  @override
  String streakDays(int count) {
    return '$count روچ رِد';
  }

  @override
  String todayCount(int count) {
    return 'مرچی: $count';
  }

  @override
  String totalViewedCount(int count) {
    return 'کل دیستگیں: $count';
  }

  @override
  String get recentlyViewedWords => 'نوکیں دیستگیں گال';

  @override
  String get clearAction => 'گار کنگ';

  @override
  String get emptyStreakPrompt =>
      'گالے پچ کن دانکہ تئی وانگ ءِ رِد ءُ تازگیں دیستگیں گال بنگیج بہ بنت';

  @override
  String get curatedWords => 'گچین کتگیں گال';

  @override
  String get dictionaryTab => 'بزانت‌بلد';

  @override
  String get settingsTitle => 'کاربوج';

  @override
  String get languageSettingTitle => 'زبان / زُبان';

  @override
  String get languageBalochi => 'بلوچی';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get offlineBadge => '۱۰۰٪ آفلاین';

  @override
  String versionLabel(String version) {
    return 'ورژن $version • ۱۰۰٪ آفلاین';
  }
}
