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
  String versionLabel(Object version) {
    return 'نسخه $version • ۱۰۰٪ آفلاین';
  }

  @override
  String get appearanceSectionTitle => 'ظاهر و رنگ برنامه';

  @override
  String get themeModeSystem => 'سیستم';

  @override
  String get themeModeLight => 'روشن';

  @override
  String get themeModeDark => 'تاریک';

  @override
  String get themeModePureBlack => 'تاریک مطلق';

  @override
  String get fontSectionTitle => 'فونت و سبک نوشتار';

  @override
  String get fontSizeSectionTitle => 'اندازه متن';

  @override
  String get resetFontSize => 'بازنشانی به ۱۰۰٪';

  @override
  String get fontSizePreviewText => 'زبان بلوچی هویت ماست';

  @override
  String get notificationsSectionTitle => 'یادآورها (اعلان‌ها)';

  @override
  String get historySectionTitle => 'تاریخچه';

  @override
  String get clearSearchHistoryTitle => 'پاک کردن تاریخچه جستجو';

  @override
  String get clearSearchHistorySubtitle => 'جستجوهای اخیر از حافظه حذف می‌شوند';

  @override
  String get clearSearchHistoryDialogTitle => 'تاریخچه جستجو پاک شود؟';

  @override
  String get clearSearchHistoryDialogBody =>
      'فهرست جستجوهای اخیر شما برای همیشه پاک خواهد شد.';

  @override
  String get cancelAction => 'انصراف';

  @override
  String get confirmClearAction => 'بله، پاک کن';

  @override
  String get searchHistoryClearedSnack => 'تاریخچه جستجو پاک شد';

  @override
  String get aboutSectionTitle => 'درباره ما';

  @override
  String get checkForUpdatesTitle => 'بررسی نسخه جدید';

  @override
  String updateAvailableSubtitle(String version) {
    return 'نسخه جدید v$version در دسترس است!';
  }

  @override
  String get checkLatestVersionSubtitle => 'بررسی آخرین نسخه منتشرشده';

  @override
  String get appIsUpToDateSnack => 'برنامه به‌روز است';
}
