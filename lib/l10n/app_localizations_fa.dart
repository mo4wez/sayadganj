// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'سیدگنج';

  @override
  String get appSubtitle => 'سیدگنج — فرهنگ واژگان بلوچی';

  @override
  String get searchHint => 'جستجوی واژه...';

  @override
  String get wordOfTheDay => 'واژه روز';

  @override
  String get luckyWord => 'واژه تصادفی';

  @override
  String get readFullDefinition => 'مشاهده معنی کامل';

  @override
  String streakDays(int count) {
    return '$count روز پیوسته';
  }

  @override
  String todayCount(int count) {
    return 'امروز: $count';
  }

  @override
  String totalViewedCount(int count) {
    return 'کل دیده‌شده: $count';
  }

  @override
  String get recentlyViewedWords => 'واژه‌های اخیر';

  @override
  String get clearAction => 'پاک کردن';

  @override
  String get emptyStreakPrompt =>
      'واژه‌ای را باز کنید تا روند مطالعه و واژه‌های اخیر شما آغاز شود';

  @override
  String get curatedWords => 'واژه‌های برگزیده';

  @override
  String get dictionaryTab => 'واژه‌نامه';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get languageSettingTitle => 'زبان برنامه';

  @override
  String get languageBalochi => 'بلوچی';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get offlineBadge => '۱۰۰٪ آفلاین';

  @override
  String versionLabel(String version) {
    return 'نسخه $version • ۱۰۰٪ آفلاین';
  }
}
