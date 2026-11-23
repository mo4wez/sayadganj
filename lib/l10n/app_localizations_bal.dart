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
  String versionLabel(Object version) {
    return 'ورژن $version • ۱۰۰٪ آفلاین';
  }

  @override
  String get appearanceSectionTitle => 'زاهری رنگ ءُ دروشم';

  @override
  String get themeModeSystem => 'سیستم';

  @override
  String get themeModeLight => 'روچ';

  @override
  String get themeModeDark => 'شپ';

  @override
  String get themeModePureBlack => 'پُرتہاریں شپ';

  @override
  String get fontSectionTitle => 'کِشک ءُ نبشتانک ءِ دروشم (Font)';

  @override
  String get fontSizeSectionTitle => 'نبشتانک ءِ کساس (Font Size)';

  @override
  String get resetFontSize => 'پدا ۱۰۰٪';

  @override
  String get fontSizePreviewText => 'بلوچی زبان مئے پجّار اِنت';

  @override
  String get notificationsSectionTitle => 'یات‌دھانی (Notifications)';

  @override
  String get historySectionTitle => 'دپتر';

  @override
  String get clearSearchHistoryTitle => 'شوهازانی دپتر ءَ ساپ کن';

  @override
  String get clearSearchHistorySubtitle =>
      'تازگیں شوهاز چہ حافظہ ءَ دور کنگ بنت';

  @override
  String get clearSearchHistoryDialogTitle => 'دپتر ساپ کنگ بہ بیت؟';

  @override
  String get clearSearchHistoryDialogBody =>
      'تئی تازگیں شوهازانی لڑ پہ مدامی پاک کنگ بیت۔';

  @override
  String get cancelAction => 'نہ';

  @override
  String get confirmClearAction => 'هو، ساپ کن';

  @override
  String get searchHistoryClearedSnack => 'شوهازانی دپتر ساپ بوت';

  @override
  String get aboutSectionTitle => 'مئے بابت ءَ';

  @override
  String get checkForUpdatesTitle => 'نوکیں ورژن ءِ پٹّ ءُ پول';

  @override
  String updateAvailableSubtitle(String version) {
    return 'نوکیں ورژن v$version دست کپت!';
  }

  @override
  String get checkLatestVersionSubtitle => 'گڈّی ورژن ءَ چکّاس کن';

  @override
  String get appIsUpToDateSnack => 'تئی پریام گڈّی ورژن اِنت';
}
