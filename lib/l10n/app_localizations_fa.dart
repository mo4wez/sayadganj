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
  String get appDescription => 'اولین فرهنگ واژگان زبان بلوچی';

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
  String get notificationsSectionTitle => 'یادآورها (Notifications)';

  @override
  String get historySectionTitle => 'تاریخچه (History)';

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

  @override
  String get channelTelegram => 'تلگرام (Telegram)';

  @override
  String get channelInstagram => 'اینستاگرام (Instagram)';

  @override
  String get channelYoutube => 'یوتیوب (YouTube)';

  @override
  String get channelCastbox => 'کست‌باکس (CastBox)';

  @override
  String get linkCopiedSnack => 'لینک کپی شد';

  @override
  String get aboutSayadGanjDescription =>
      'سیدگنج، بزرگ‌ترین اثر سید هاشمی برای زبان بلوچی است که تاکبند کندیل پایگاه داده آن را در قالب یک برنامه مدرن اندروید عرضه کرده است. از جناب شبیر کلمتی و همراهانشان که این پایگاه داده را دیجیتال‌سازی کرده و اجازه استفاده از آن را دادند سپاسگزاریم.';

  @override
  String totalWordsCount(String count) {
    return 'تعداد کل واژه‌ها: $count';
  }

  @override
  String get takbandTitle => 'تاکبند کندیل (TakbandQandeel)';

  @override
  String get takbandSubtitle => 'گروه دوستداران زبان و ادبیات بلوچی';

  @override
  String get takbandDescription =>
      'ما گروه کوچکی از دانشجویان و دوستداران زبان و ادبیات بلوچی هستیم که برای گسترش و آگاهی‌بخشی زبان بلوچی فعالیت می‌کنیم.';

  @override
  String get ourChannelsAndPodcast => 'کانال‌ها و پادکست ما';

  @override
  String get madeWithLove => 'ساخته‌شده با';

  @override
  String get takbandName => 'تاکبند کندیل';

  @override
  String get dailyWordNotificationTitle => 'اعلان واژه روز';

  @override
  String get dailyWordNotificationSubtitle =>
      'هر روز یک واژه جدید بلوچی همراه با معنی آن ارسال می‌شود';

  @override
  String get notificationPermissionDeniedSnack =>
      'برای دریافت اعلان، دسترسی را از تنظیمات گوشی فعال کنید';

  @override
  String get notificationTimeTitle => 'زمان اعلان';

  @override
  String get themeModeSectionTitle => 'حالت روشن و تاریک (Theme mode)';

  @override
  String get themeModeAutoOption => 'هماهنگ با سیستم (Auto)';

  @override
  String get themeModeLightOption => 'حالت روشن (Light)';

  @override
  String get themeModeDarkOption => 'حالت تاریک (Dark)';

  @override
  String get pureBlackSectionTitle => 'حالت تاریک مطلق (Pure black mode)';

  @override
  String get standardDarkOption => 'تاریک استاندارد (Standard)';

  @override
  String get standardDarkSubtitle => 'پس‌زمینه تیره و سرمه‌ای ملایم';

  @override
  String get pureBlackOption => 'تاریک مطلق (Pure black)';

  @override
  String get pureBlackSubtitle => 'سیاه کامل (AMOLED) برای مطالعه در شب';

  @override
  String get themeColorSectionTitle => 'انتخاب رنگ (Theme color)';

  @override
  String get bottomBarSectionTitle => 'نوار پایین (Bottom bar)';

  @override
  String wordsStartingWithLetter(String letter) {
    return 'واژه‌های حرف «$letter»';
  }

  @override
  String get changeAction => 'تغییر';

  @override
  String get noWordsFoundTitle => 'واژه‌ای یافت نشد';

  @override
  String get noWordsFoundSearchSubtitle =>
      'واژه دیگری یا بخش کوتاه‌تری را جستجو کنید';

  @override
  String get noWordsFoundLetterSubtitle => 'واژه‌ای با این حرف وجود ندارد';

  @override
  String get alphabetDialTooltip => 'چرخ الفبا';

  @override
  String get bookmarksTab => 'نشان‌شده‌ها';

  @override
  String get recentSearchesTitle => 'جستجوهای اخیر';

  @override
  String get clearHistoryShort => 'پاک کردن';

  @override
  String get newWordAction => 'واژه جدید';

  @override
  String get todayLabel => 'امروز';

  @override
  String get totalViewedLabel => 'کل دیده‌شده';

  @override
  String get flashcardsTitle => 'کارت‌های واژگان';

  @override
  String get curatedShort => 'برگزیده';

  @override
  String get previousTooltip => 'قبلی';

  @override
  String get nextTooltip => 'بعدی';

  @override
  String get newDeckAction => 'دسته جدید';

  @override
  String get swipeOrTapHint => 'برای بعدی بکشید یا ضربه بزنید';

  @override
  String get tapToViewMeaning => 'برای دیدن معنی ضربه بزنید';

  @override
  String get fullMeaningShort => 'معنی کامل';

  @override
  String get wordQuizBadge => 'آزمون واژگان';

  @override
  String quizPointsCount(int score) {
    return '$score امتیاز';
  }

  @override
  String get dailyQuizTitle => 'دانش واژگان بلوچی خود را بسنجید';

  @override
  String get dailyQuizSubtitle =>
      'در ۵ پرسش معنی درست واژه‌ها را انتخاب کنید و امتیاز خود را افزایش دهید.';

  @override
  String get startQuizAction => 'شروع آزمون';

  @override
  String errorOccurredWithDetail(String error) {
    return 'خطایی رخ داد: $error';
  }

  @override
  String categorySubtitleWithCount(String subtitle, int count) {
    return '$subtitle ($count واژه)';
  }

  @override
  String get wordDetailTitle => 'معنی واژه';

  @override
  String get removeBookmarkTooltip => 'حذف نشان';

  @override
  String get addBookmarkTooltip => 'نشان کردن';

  @override
  String get wordBookmarkedSnack => 'واژه نشان شد';

  @override
  String get wordUnbookmarkedSnack => 'نشان واژه حذف شد';

  @override
  String get copyTooltip => 'کپی کردن';

  @override
  String get wordAndMeaningCopiedSnack => 'واژه و معنی کپی شدند';

  @override
  String get shareTooltip => 'اشتراک‌گذاری';

  @override
  String get shareFooterSignature => '— سیدگنج، فرهنگ واژگان بلوچی';

  @override
  String get wordNotFoundTitle => 'واژه یافت نشد';

  @override
  String plainSpellingLabel(String word) {
    return 'نگارش ساده: $word';
  }

  @override
  String get noQuizWordsFound => 'واژه‌ای برای آزمون یافت نشد';

  @override
  String get quizQuestionPrompt => 'معنی درست این واژه کدام است؟';

  @override
  String get seeResultsAction => 'مشاهده نتیجه';

  @override
  String get nextQuestionAction => 'پرسش بعدی';

  @override
  String get quizFeedbackHigh => 'بسیار عالی! دانش واژگان بلوچی شما چشمگیر است';

  @override
  String get quizFeedbackMid => 'آفرین! در ادامه بهتر هم خواهید شد';

  @override
  String get quizFeedbackLow => 'تلاش را ادامه دهید، هر پرسش یک واژه تازه است';

  @override
  String get quizCompleteTitle => 'آزمون به پایان رسید!';

  @override
  String get roundCorrectAnswersLabel => 'پاسخ‌های درست این دور';

  @override
  String get totalScoreLabel => 'امتیاز کل';

  @override
  String get playNewRoundAction => 'شروع دور جدید';

  @override
  String get backToDictionaryAction => 'بازگشت به واژه‌نامه';

  @override
  String get quickPeekBadge => 'نگاه سریع';

  @override
  String specificWordNotFound(String word) {
    return 'واژه «$word» یافت نشد';
  }

  @override
  String get openFullPageAction => 'باز کردن صفحه کامل';

  @override
  String get relatedWordsQuickPeek => 'واژه‌های مرتبط (نگاه سریع)';

  @override
  String seeWordLabel(String word) {
    return 'ببینید: $word';
  }

  @override
  String get errorOccurredTitle => 'خطایی رخ داد';

  @override
  String allWordsShownCount(int count) {
    return 'همه $count واژه نمایش داده شد';
  }

  @override
  String get alphabetDialTitle => 'چرخ الفبا';

  @override
  String wordCountShort(int count) {
    return '$count واژه';
  }

  @override
  String viewWordsForLetterAction(String letter) {
    return 'مشاهده واژه‌های حرف «$letter»';
  }

  @override
  String get allNotationsTitle => 'فهرست کامل اختصارها و نشانه‌ها';

  @override
  String get entryNotationsTitle => 'معنی اختصارها و نشانه‌ها';

  @override
  String get fullListAction => 'فهرست کامل';

  @override
  String get fullAbbreviationsListAction => 'فهرست کامل اختصارها';

  @override
  String get definitionHeaderTitle => 'معنی و توضیح';

  @override
  String get structuredViewLabel => 'نمای بخش‌بندی‌شده';

  @override
  String get rawTextViewLabel => 'متن کامل';

  @override
  String letterSequenceLabel(String spelling) {
    return 'ترتیب حروف: $spelling';
  }

  @override
  String get coreMeaningLabel => 'معنی اصلی';

  @override
  String compoundsAndSubEntriesCount(int count) {
    return 'ترکیب‌ها و زیرمدخل‌ها ($count)';
  }

  @override
  String allItemsCount(int count) {
    return 'همه ($count)';
  }

  @override
  String wordRemovedFromBookmarksSnack(String word) {
    return '«$word» از نشان‌شده‌ها حذف شد';
  }

  @override
  String get undoAction => 'بازگردانی';

  @override
  String get bookmarksScreenTitle => 'واژه‌های نشان‌شده';

  @override
  String get listViewTooltip => 'نمای فهرست';

  @override
  String get carouselViewTooltip => 'نمای کارتی';

  @override
  String get noBookmarksTitle => 'هنوز واژه‌ای نشان نشده است';

  @override
  String get noBookmarksSubtitle =>
      'واژه‌های دلخواه خود را برای دسترسی سریع نشان کنید';

  @override
  String get removeAction => 'حذف';

  @override
  String get telegramShort => 'تلگرام';

  @override
  String get instagramShort => 'اینستاگرام';

  @override
  String get youtubeShort => 'یوتیوب';

  @override
  String get castboxShort => 'کست‌باکس';

  @override
  String get followTakbandTitle => 'همراه تاکبند کندیل شوید';

  @override
  String get followTakbandSubtitle =>
      'اگر سیدگنج برای شما مفید بوده است، کانال‌ها و پادکست گروه ادبی ما را هم دنبال کنید تا از کارهای تازه زبان بلوچی باخبر شوید.';

  @override
  String get dontShowAgainAction => 'دیگر نشان نده';

  @override
  String get maybeLaterAction => 'بعداً می‌بینم';

  @override
  String get splashSubtitle => 'فرهنگ واژگان بلوچی به بلوچی';

  @override
  String newVersionAvailableTitle(String version) {
    return 'نسخه جدید در دسترس است (v$version)';
  }

  @override
  String currentVersionLabel(String version) {
    return 'نسخه فعلی شما: v$version';
  }

  @override
  String get whatsNewLabel => 'تغییرات جدید:';

  @override
  String get laterAction => 'بعداً';

  @override
  String get downloadAction => 'دانلود';

  @override
  String appNewVersionBannerTitle(String version) {
    return 'نسخه جدید سیدگنج (v$version)';
  }

  @override
  String get tapToDownloadSubtitle => 'برای دانلود ضربه بزنید';

  @override
  String get closeTooltip => 'بستن';

  @override
  String get accentTeal => 'سبز آبی';

  @override
  String get accentEmerald => 'زمردی / سبز';

  @override
  String get accentBlue => 'آبی';

  @override
  String get accentViolet => 'بنفش';

  @override
  String get accentAmber => 'کهربایی / زعفرانی';

  @override
  String get accentRose => 'صورتی / رز';

  @override
  String get accentInk => 'جوهری';

  @override
  String get colorStyleVividTitle => 'زنده (Vivid)';

  @override
  String get colorStyleVividSubtitle =>
      'رنگ‌های شفاف و پرانرژی برای وضوح بیشتر';

  @override
  String get colorStyleSoftTitle => 'نرم (Soft)';

  @override
  String get colorStyleSoftSubtitle =>
      'رنگ‌های آرام و ملایم برای مطالعه طولانی';

  @override
  String get colorStyleTintedTitle => 'ته‌رنگ‌دار (Tinted)';

  @override
  String get colorStyleTintedSubtitle =>
      'کارت‌ها و پس‌زمینه با سایه‌ای از رنگ انتخابی';

  @override
  String get colorStyleMonochromeTitle => 'تک‌رنگ (Monochrome)';

  @override
  String get colorStyleMonochromeSubtitle =>
      'نمای ساده کاغذ و جوهر بدون رنگ اضافه';

  @override
  String get bottomBarDockedTitle => 'چسبیده (Docked)';

  @override
  String get bottomBarDockedSubtitle => 'نوار کامل چسبیده به لبه پایین';

  @override
  String get bottomBarFloatingTitle => 'شناور (Floating)';

  @override
  String get bottomBarFloatingSubtitle => 'نوار آزاد به شکل کپسول';

  @override
  String get fontVazirmatnTitle => 'وزیرمتن (Vazirmatn)';

  @override
  String get fontVazirmatnSubtitle =>
      'فونت ساده، خوانا و مدرن برای مطالعه روزمره';

  @override
  String get fontDroshumTitle => 'دروشم بلوچی (Droshum Balochi)';

  @override
  String get fontDroshumSubtitle =>
      'فونت ویژه بلوچی برای متون ادبی و فرهنگ واژگان';

  @override
  String get fontSystemTitle => 'فونت پیش‌فرض سیستم (Default)';

  @override
  String get fontSystemSubtitle => 'فونت پایه گوشی';

  @override
  String get colorStyleSettingTitle => 'سبک رنگ (Color Style)';

  @override
  String get searchScopeContainsHeadword => 'در سرواژه';

  @override
  String get searchScopeStartsWith => 'شروع با';

  @override
  String get searchScopeInDefinitions => 'در معنی‌ها';

  @override
  String wordOfTheDayNotificationTitle(String word) {
    return 'واژه روز: $word';
  }

  @override
  String get timePickerHelpText => 'انتخاب زمان';

  @override
  String get confirmAction => 'تایید';

  @override
  String get cancelTimeAction => 'لغو';

  @override
  String get timePickerHourLabel => 'ساعت';

  @override
  String get timePickerMinuteLabel => 'دقیقه';

  @override
  String get errorInvalidTimeText => 'زمان معتبری وارد کنید';
}
