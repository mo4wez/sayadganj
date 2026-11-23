import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bal.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bal'),
    Locale('fa'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In bal, this message translates to:
  /// **'سیدگنج'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'سیدگنج — بلوچی بزانت‌بلد'**
  String get appSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In bal, this message translates to:
  /// **'گالے بہ شوهاز...'**
  String get searchHint;

  /// No description provided for @wordOfTheDay.
  ///
  /// In bal, this message translates to:
  /// **'روچ ءِ گال'**
  String get wordOfTheDay;

  /// No description provided for @luckyWord.
  ///
  /// In bal, this message translates to:
  /// **'پَدیمیں گال'**
  String get luckyWord;

  /// No description provided for @readFullDefinition.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں بزانت ءَ بوان'**
  String get readFullDefinition;

  /// No description provided for @streakDays.
  ///
  /// In bal, this message translates to:
  /// **'{count} روچ رِد'**
  String streakDays(int count);

  /// No description provided for @todayCount.
  ///
  /// In bal, this message translates to:
  /// **'مرچی: {count}'**
  String todayCount(int count);

  /// No description provided for @totalViewedCount.
  ///
  /// In bal, this message translates to:
  /// **'کُل دیستگیں: {count}'**
  String totalViewedCount(int count);

  /// No description provided for @recentlyViewedWords.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں دیستگیں گال'**
  String get recentlyViewedWords;

  /// No description provided for @clearAction.
  ///
  /// In bal, this message translates to:
  /// **'گار کنگ'**
  String get clearAction;

  /// No description provided for @emptyStreakPrompt.
  ///
  /// In bal, this message translates to:
  /// **'گالے پچ کن دانکہ تئی وانگ ءِ رِد ءُ تازگیں دیستگیں گال بنگیج بہ بنت'**
  String get emptyStreakPrompt;

  /// No description provided for @curatedWords.
  ///
  /// In bal, this message translates to:
  /// **'گچین کتگیں گال'**
  String get curatedWords;

  /// No description provided for @dictionaryTab.
  ///
  /// In bal, this message translates to:
  /// **'بزانت‌بلد'**
  String get dictionaryTab;

  /// No description provided for @settingsTitle.
  ///
  /// In bal, this message translates to:
  /// **'کاربوج'**
  String get settingsTitle;

  /// No description provided for @languageSettingTitle.
  ///
  /// In bal, this message translates to:
  /// **'زبان (Language)'**
  String get languageSettingTitle;

  /// No description provided for @languageBalochi.
  ///
  /// In bal, this message translates to:
  /// **'بلوچی'**
  String get languageBalochi;

  /// No description provided for @languagePersian.
  ///
  /// In bal, this message translates to:
  /// **'فارسی'**
  String get languagePersian;

  /// No description provided for @offlineBadge.
  ///
  /// In bal, this message translates to:
  /// **'۱۰۰٪ آفلاین'**
  String get offlineBadge;

  /// No description provided for @versionLabel.
  ///
  /// In bal, this message translates to:
  /// **'ورژن {version} • ۱۰۰٪ آفلاین'**
  String versionLabel(Object version);

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'زاهری رنگ ءُ دروشم'**
  String get appearanceSectionTitle;

  /// No description provided for @themeModeSystem.
  ///
  /// In bal, this message translates to:
  /// **'سیستم'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In bal, this message translates to:
  /// **'روچ'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In bal, this message translates to:
  /// **'شپ'**
  String get themeModeDark;

  /// No description provided for @themeModePureBlack.
  ///
  /// In bal, this message translates to:
  /// **'پُرتہاریں شپ'**
  String get themeModePureBlack;

  /// No description provided for @fontSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'کِشک ءُ نبشتانک ءِ دروشم (Font)'**
  String get fontSectionTitle;

  /// No description provided for @fontSizeSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'نبشتانک ءِ کساس (Font Size)'**
  String get fontSizeSectionTitle;

  /// No description provided for @resetFontSize.
  ///
  /// In bal, this message translates to:
  /// **'پدا ۱۰۰٪'**
  String get resetFontSize;

  /// No description provided for @fontSizePreviewText.
  ///
  /// In bal, this message translates to:
  /// **'بلوچی زبان مئے پجّار اِنت'**
  String get fontSizePreviewText;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'جار (Notifications)'**
  String get notificationsSectionTitle;

  /// No description provided for @historySectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'دپتر'**
  String get historySectionTitle;

  /// No description provided for @clearSearchHistoryTitle.
  ///
  /// In bal, this message translates to:
  /// **'شوهازانی دپتر ءَ ساپ کن'**
  String get clearSearchHistoryTitle;

  /// No description provided for @clearSearchHistorySubtitle.
  ///
  /// In bal, this message translates to:
  /// **'تازگیں شوهاز چہ حافظہ ءَ دور کنگ بنت'**
  String get clearSearchHistorySubtitle;

  /// No description provided for @clearSearchHistoryDialogTitle.
  ///
  /// In bal, this message translates to:
  /// **'دپتر ساپ کنگ بہ بیت؟'**
  String get clearSearchHistoryDialogTitle;

  /// No description provided for @clearSearchHistoryDialogBody.
  ///
  /// In bal, this message translates to:
  /// **'تئی تازگیں شوهازانی لڑ پہ مدامی پاک کنگ بیت۔'**
  String get clearSearchHistoryDialogBody;

  /// No description provided for @cancelAction.
  ///
  /// In bal, this message translates to:
  /// **'نہ'**
  String get cancelAction;

  /// No description provided for @confirmClearAction.
  ///
  /// In bal, this message translates to:
  /// **'هو، ساپ کن'**
  String get confirmClearAction;

  /// No description provided for @searchHistoryClearedSnack.
  ///
  /// In bal, this message translates to:
  /// **'شوهازانی دپتر ساپ بوت'**
  String get searchHistoryClearedSnack;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'مئے بابت ءَ'**
  String get aboutSectionTitle;

  /// No description provided for @checkForUpdatesTitle.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں ورژن ءِ پٹّ ءُ پول'**
  String get checkForUpdatesTitle;

  /// No description provided for @updateAvailableSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں ورژن v{version} دست کپت!'**
  String updateAvailableSubtitle(String version);

  /// No description provided for @checkLatestVersionSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'گڈّی ورژن ءَ چکّاس'**
  String get checkLatestVersionSubtitle;

  /// No description provided for @appIsUpToDateSnack.
  ///
  /// In bal, this message translates to:
  /// **'تئی پریام گڈّی ورژن اِنت'**
  String get appIsUpToDateSnack;

  /// No description provided for @channelTelegram.
  ///
  /// In bal, this message translates to:
  /// **'تلگرام (Telegram)'**
  String get channelTelegram;

  /// No description provided for @channelInstagram.
  ///
  /// In bal, this message translates to:
  /// **'اینستاگرام (Instagram)'**
  String get channelInstagram;

  /// No description provided for @channelYoutube.
  ///
  /// In bal, this message translates to:
  /// **'یوتیوب (YouTube)'**
  String get channelYoutube;

  /// No description provided for @channelCastbox.
  ///
  /// In bal, this message translates to:
  /// **'کست باکس (CastBox)'**
  String get channelCastbox;

  /// No description provided for @linkCopiedSnack.
  ///
  /// In bal, this message translates to:
  /// **'لینک کُپی بوت'**
  String get linkCopiedSnack;

  /// No description provided for @aboutSayadGanjDescription.
  ///
  /// In bal, this message translates to:
  /// **'سیدگنج، سیدھاشمی ءِ مستریں جھد پہ بلوچی زبان ءَ اِنت کہ تاکبند کندیل ءَ آئی دیتابیس، اندروید ءِ تہ ءَ مُدرنے رنگے ءَ دیم ءَ آرتگ، ما واجہ شبیر کلمتی ءُ آئی ھمراھاں کہ اے دیتابیس دیجیتالایز کتگ ءُ کارمرز کنگ ءِ موکل داتگ، منتوار ایں۔'**
  String get aboutSayadGanjDescription;

  /// No description provided for @totalWordsCount.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں گال: {count}'**
  String totalWordsCount(String count);

  /// No description provided for @takbandTitle.
  ///
  /// In bal, this message translates to:
  /// **'تاکبند کندیل (TakbandQandeel)'**
  String get takbandTitle;

  /// No description provided for @takbandSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'بلوچی زبان ءُ لبزانک ءِ دوزواهانی گَل'**
  String get takbandSubtitle;

  /// No description provided for @takbandDescription.
  ///
  /// In bal, this message translates to:
  /// **'ما بلوچی زبان ءُ لبزانک ءِ کسانیں نودربر ءُ دوزواھانی گَلے ایں کہ پہ بلوچی زبان ءِ دیمروئی، زانتکاری ءَ کار کنگ ءَ ایں۔'**
  String get takbandDescription;

  /// No description provided for @ourChannelsAndPodcast.
  ///
  /// In bal, this message translates to:
  /// **'مئے تاک ءُ پادکست'**
  String get ourChannelsAndPodcast;

  /// No description provided for @madeWithLove.
  ///
  /// In bal, this message translates to:
  /// **'گوں مھر ءَ'**
  String get madeWithLove;

  /// No description provided for @takbandName.
  ///
  /// In bal, this message translates to:
  /// **'تاکبند کندیل'**
  String get takbandName;

  /// No description provided for @dailyWordNotificationTitle.
  ///
  /// In bal, this message translates to:
  /// **'روچ ءِ گال ءِ جار'**
  String get dailyWordNotificationTitle;

  /// No description provided for @dailyWordNotificationSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'هر روچ یک نوکیں بلوچی گالے گوں آئی ءِ مانا ءَ دیم دیگ بیت'**
  String get dailyWordNotificationSubtitle;

  /// No description provided for @notificationPermissionDeniedSnack.
  ///
  /// In bal, this message translates to:
  /// **'پہ جار جنگ ءَ چہ موبائل ءِ کاربوج ءِ تہ ءَ اجازت بہ دئے'**
  String get notificationPermissionDeniedSnack;

  /// No description provided for @notificationTimeTitle.
  ///
  /// In bal, this message translates to:
  /// **'جار ءِ وهد'**
  String get notificationTimeTitle;

  /// No description provided for @themeModeSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'شپ ءُ روچ ءِ دروشم (Theme mode)'**
  String get themeModeSectionTitle;

  /// No description provided for @themeModeAutoOption.
  ///
  /// In bal, this message translates to:
  /// **'سیستم ءِ حساب ءَ (Auto)'**
  String get themeModeAutoOption;

  /// No description provided for @themeModeLightOption.
  ///
  /// In bal, this message translates to:
  /// **'روچ ءِ دروشم (Light)'**
  String get themeModeLightOption;

  /// No description provided for @themeModeDarkOption.
  ///
  /// In bal, this message translates to:
  /// **'شپ ءِ دروشم (Dark)'**
  String get themeModeDarkOption;

  /// No description provided for @pureBlackSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'تہاریں شپ ءِ دروشم (Pure black mode)'**
  String get pureBlackSectionTitle;

  /// No description provided for @standardDarkOption.
  ///
  /// In bal, this message translates to:
  /// **'سادگیں شپ (Standard)'**
  String get standardDarkOption;

  /// No description provided for @standardDarkSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'نرمیں سیاہ ءُ نیلیں پُشت‌در'**
  String get standardDarkSubtitle;

  /// No description provided for @pureBlackOption.
  ///
  /// In bal, this message translates to:
  /// **'پُرتہاریں شپ (Pure black)'**
  String get pureBlackOption;

  /// No description provided for @pureBlackSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں سیاہ (AMOLED) پہ شپ ءِ وانگ ءَ'**
  String get pureBlackSubtitle;

  /// No description provided for @themeColorSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'رنگ ءِ گچین (Theme color)'**
  String get themeColorSectionTitle;

  /// No description provided for @bottomBarSectionTitle.
  ///
  /// In bal, this message translates to:
  /// **'چیردیمی بار (Bottom bar)'**
  String get bottomBarSectionTitle;

  /// No description provided for @wordsStartingWithLetter.
  ///
  /// In bal, this message translates to:
  /// **'آب «{letter}» ءِ گال'**
  String wordsStartingWithLetter(String letter);

  /// No description provided for @changeAction.
  ///
  /// In bal, this message translates to:
  /// **'بدل کن'**
  String get changeAction;

  /// No description provided for @noWordsFoundTitle.
  ///
  /// In bal, this message translates to:
  /// **'هچ گالے دست نہ کپت'**
  String get noWordsFoundTitle;

  /// No description provided for @noWordsFoundSearchSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'دگہ گالے یا کسانیں بھرے بہ شوهاز'**
  String get noWordsFoundSearchSubtitle;

  /// No description provided for @noWordsFoundLetterSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'اے آب ءَ هچ گال نیست'**
  String get noWordsFoundLetterSubtitle;

  /// No description provided for @alphabetDialTooltip.
  ///
  /// In bal, this message translates to:
  /// **'چرخِ آب ءُ ب'**
  String get alphabetDialTooltip;

  /// No description provided for @bookmarksTab.
  ///
  /// In bal, this message translates to:
  /// **'نشان کتگیں'**
  String get bookmarksTab;

  /// No description provided for @recentSearchesTitle.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں شوهاز'**
  String get recentSearchesTitle;

  /// No description provided for @clearHistoryShort.
  ///
  /// In bal, this message translates to:
  /// **'ساپ کنگ'**
  String get clearHistoryShort;

  /// No description provided for @newWordAction.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں گال'**
  String get newWordAction;

  /// No description provided for @todayLabel.
  ///
  /// In bal, this message translates to:
  /// **'مرچی'**
  String get todayLabel;

  /// No description provided for @totalViewedLabel.
  ///
  /// In bal, this message translates to:
  /// **'کل دیستگیں'**
  String get totalViewedLabel;

  /// No description provided for @flashcardsTitle.
  ///
  /// In bal, this message translates to:
  /// **'گالانی تاکدیم'**
  String get flashcardsTitle;

  /// No description provided for @curatedShort.
  ///
  /// In bal, this message translates to:
  /// **'گچین کتگیں'**
  String get curatedShort;

  /// No description provided for @previousTooltip.
  ///
  /// In bal, this message translates to:
  /// **'پێشتر'**
  String get previousTooltip;

  /// No description provided for @nextTooltip.
  ///
  /// In bal, this message translates to:
  /// **'دیمتر'**
  String get nextTooltip;

  /// No description provided for @newDeckAction.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں تاکدیم'**
  String get newDeckAction;

  /// No description provided for @swipeOrTapHint.
  ///
  /// In bal, this message translates to:
  /// **'پہ دیمتر ءَ کشّ یا بہ ٹپّ'**
  String get swipeOrTapHint;

  /// No description provided for @tapToViewMeaning.
  ///
  /// In bal, this message translates to:
  /// **'بزانت ءِ چارگ ءَ بہ ٹپّ'**
  String get tapToViewMeaning;

  /// No description provided for @fullMeaningShort.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں بزانت'**
  String get fullMeaningShort;

  /// No description provided for @wordQuizBadge.
  ///
  /// In bal, this message translates to:
  /// **'گال چکّاس'**
  String get wordQuizBadge;

  /// No description provided for @quizPointsCount.
  ///
  /// In bal, this message translates to:
  /// **'{score} دَرَجَگ'**
  String quizPointsCount(int score);

  /// No description provided for @dailyQuizTitle.
  ///
  /// In bal, this message translates to:
  /// **'وتی بلوچی گالانی زانت ءَ بہ چکّاس'**
  String get dailyQuizTitle;

  /// No description provided for @dailyQuizSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'۵ جُست ءِ تہ ءَ گالانی راستیں بزانت ءَ گچین کن ءُ وتی دَرَجَگ ءَ گیش کن۔'**
  String get dailyQuizSubtitle;

  /// No description provided for @startQuizAction.
  ///
  /// In bal, this message translates to:
  /// **'چکّاس ءَ بندات کن'**
  String get startQuizAction;

  /// No description provided for @errorOccurredWithDetail.
  ///
  /// In bal, this message translates to:
  /// **'ردی یے بوت: {error}'**
  String errorOccurredWithDetail(String error);

  /// No description provided for @categorySubtitleWithCount.
  ///
  /// In bal, this message translates to:
  /// **'{subtitle} ({count} گال)'**
  String categorySubtitleWithCount(String subtitle, int count);

  /// No description provided for @wordDetailTitle.
  ///
  /// In bal, this message translates to:
  /// **'گال ءِ بزانت'**
  String get wordDetailTitle;

  /// No description provided for @removeBookmarkTooltip.
  ///
  /// In bal, this message translates to:
  /// **'نشان دور کنگ'**
  String get removeBookmarkTooltip;

  /// No description provided for @addBookmarkTooltip.
  ///
  /// In bal, this message translates to:
  /// **'نشان کنگ'**
  String get addBookmarkTooltip;

  /// No description provided for @wordBookmarkedSnack.
  ///
  /// In bal, this message translates to:
  /// **'گال نشان کنگ بوت'**
  String get wordBookmarkedSnack;

  /// No description provided for @wordUnbookmarkedSnack.
  ///
  /// In bal, this message translates to:
  /// **'گال چہ نشاناں دور کنگ بوت'**
  String get wordUnbookmarkedSnack;

  /// No description provided for @copyTooltip.
  ///
  /// In bal, this message translates to:
  /// **'کپی کنگ'**
  String get copyTooltip;

  /// No description provided for @wordAndMeaningCopiedSnack.
  ///
  /// In bal, this message translates to:
  /// **'گال ءُ مانا کپی بوت انت'**
  String get wordAndMeaningCopiedSnack;

  /// No description provided for @shareTooltip.
  ///
  /// In bal, this message translates to:
  /// **'بهر کنگ'**
  String get shareTooltip;

  /// No description provided for @shareFooterSignature.
  ///
  /// In bal, this message translates to:
  /// **'— سیدگنج بلوچی بزانت‌بلد'**
  String get shareFooterSignature;

  /// No description provided for @wordNotFoundTitle.
  ///
  /// In bal, this message translates to:
  /// **'گال دست نہ کپت'**
  String get wordNotFoundTitle;

  /// No description provided for @plainSpellingLabel.
  ///
  /// In bal, this message translates to:
  /// **'سادگیں نبشتانک: {word}'**
  String plainSpellingLabel(String word);

  /// No description provided for @noQuizWordsFound.
  ///
  /// In bal, this message translates to:
  /// **'پہ چکّاس ءَ گال دست نہ کپت'**
  String get noQuizWordsFound;

  /// No description provided for @quizQuestionPrompt.
  ///
  /// In bal, this message translates to:
  /// **'اے گال ءِ راستیں مانا کجام اِنت؟'**
  String get quizQuestionPrompt;

  /// No description provided for @seeResultsAction.
  ///
  /// In bal, this message translates to:
  /// **'آسر ءَ بچار'**
  String get seeResultsAction;

  /// No description provided for @nextQuestionAction.
  ///
  /// In bal, this message translates to:
  /// **'دیمتر ءِ جست'**
  String get nextQuestionAction;

  /// No description provided for @quizFeedbackHigh.
  ///
  /// In bal, this message translates to:
  /// **'باز وش! تئی بلوچی زانت مزن اِنت'**
  String get quizFeedbackHigh;

  /// No description provided for @quizFeedbackMid.
  ///
  /// In bal, this message translates to:
  /// **'شاباش! دیمتر ءَ انگت گهتر بئے'**
  String get quizFeedbackMid;

  /// No description provided for @quizFeedbackLow.
  ///
  /// In bal, this message translates to:
  /// **'جُهد ءَ برجاہ بدار، هر جستے نوکیں گالے'**
  String get quizFeedbackLow;

  /// No description provided for @quizCompleteTitle.
  ///
  /// In bal, this message translates to:
  /// **'چکّاس سرجم بوت!'**
  String get quizCompleteTitle;

  /// No description provided for @roundCorrectAnswersLabel.
  ///
  /// In bal, this message translates to:
  /// **'اے دور ءِ راستیں پسّو'**
  String get roundCorrectAnswersLabel;

  /// No description provided for @totalScoreLabel.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں دَرَجَگ'**
  String get totalScoreLabel;

  /// No description provided for @playNewRoundAction.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں دَورے بندات کن'**
  String get playNewRoundAction;

  /// No description provided for @backToDictionaryAction.
  ///
  /// In bal, this message translates to:
  /// **'واتر پہ بزانت بلد ءَ'**
  String get backToDictionaryAction;

  /// No description provided for @quickPeekBadge.
  ///
  /// In bal, this message translates to:
  /// **'زوتیں چارگ'**
  String get quickPeekBadge;

  /// No description provided for @specificWordNotFound.
  ///
  /// In bal, this message translates to:
  /// **'گال «{word}» دست نہ کپت'**
  String specificWordNotFound(String word);

  /// No description provided for @openFullPageAction.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں تاکدیم ءَ پچ کن'**
  String get openFullPageAction;

  /// No description provided for @relatedWordsQuickPeek.
  ///
  /// In bal, this message translates to:
  /// **'همگرنچیں گال (زوتیں چارگ)'**
  String get relatedWordsQuickPeek;

  /// No description provided for @seeWordLabel.
  ///
  /// In bal, this message translates to:
  /// **'بچار: {word}'**
  String seeWordLabel(String word);

  /// No description provided for @errorOccurredTitle.
  ///
  /// In bal, this message translates to:
  /// **'ردی یے بوت'**
  String get errorOccurredTitle;

  /// No description provided for @allWordsShownCount.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں {count} گال پیش دارگ بوت انت'**
  String allWordsShownCount(int count);

  /// No description provided for @alphabetDialTitle.
  ///
  /// In bal, this message translates to:
  /// **'آب ءُ ب ءِ چَهر'**
  String get alphabetDialTitle;

  /// No description provided for @wordCountShort.
  ///
  /// In bal, this message translates to:
  /// **'{count} گال'**
  String wordCountShort(int count);

  /// No description provided for @viewWordsForLetterAction.
  ///
  /// In bal, this message translates to:
  /// **'آب «{letter}» ءِ گالاں بچار'**
  String viewWordsForLetterAction(String letter);

  /// No description provided for @allNotationsTitle.
  ///
  /// In bal, this message translates to:
  /// **'گْونڈگال ءُ ٹِکّانی سرجمیں لڑ'**
  String get allNotationsTitle;

  /// No description provided for @entryNotationsTitle.
  ///
  /// In bal, this message translates to:
  /// **'گْونڈگال ءُ ٹِکانی بزانت'**
  String get entryNotationsTitle;

  /// No description provided for @fullListAction.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں لڑ'**
  String get fullListAction;

  /// No description provided for @fullAbbreviationsListAction.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں گْونڈگالانی لڑ'**
  String get fullAbbreviationsListAction;

  /// No description provided for @definitionHeaderTitle.
  ///
  /// In bal, this message translates to:
  /// **'بزانت ءُ گیشوار'**
  String get definitionHeaderTitle;

  /// No description provided for @structuredViewLabel.
  ///
  /// In bal, this message translates to:
  /// **'بھر کتگیں دروشم'**
  String get structuredViewLabel;

  /// No description provided for @rawTextViewLabel.
  ///
  /// In bal, this message translates to:
  /// **'سرجمیں نبشتانک'**
  String get rawTextViewLabel;

  /// No description provided for @letterSequenceLabel.
  ///
  /// In bal, this message translates to:
  /// **'آبانی رِد: {spelling}'**
  String letterSequenceLabel(String spelling);

  /// No description provided for @coreMeaningLabel.
  ///
  /// In bal, this message translates to:
  /// **'بُنی بزانت'**
  String get coreMeaningLabel;

  /// No description provided for @compoundsAndSubEntriesCount.
  ///
  /// In bal, this message translates to:
  /// **'گالرد ءُ بن‌تہر ({count})'**
  String compoundsAndSubEntriesCount(int count);

  /// No description provided for @allItemsCount.
  ///
  /// In bal, this message translates to:
  /// **'کل ({count})'**
  String allItemsCount(int count);

  /// No description provided for @wordRemovedFromBookmarksSnack.
  ///
  /// In bal, this message translates to:
  /// **'«{word}» چہ نشاناں دور کنگ بوت'**
  String wordRemovedFromBookmarksSnack(String word);

  /// No description provided for @undoAction.
  ///
  /// In bal, this message translates to:
  /// **'پدا بیار'**
  String get undoAction;

  /// No description provided for @bookmarksScreenTitle.
  ///
  /// In bal, this message translates to:
  /// **'نشان کتگیں گال'**
  String get bookmarksScreenTitle;

  /// No description provided for @listViewTooltip.
  ///
  /// In bal, this message translates to:
  /// **'لڑ ءِ دروشم'**
  String get listViewTooltip;

  /// No description provided for @carouselViewTooltip.
  ///
  /// In bal, this message translates to:
  /// **'تاکدیم ءِ دروشم'**
  String get carouselViewTooltip;

  /// No description provided for @noBookmarksTitle.
  ///
  /// In bal, this message translates to:
  /// **'انگت هچ گالے نشان نہ بوتگ'**
  String get noBookmarksTitle;

  /// No description provided for @noBookmarksSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'وتی دوست داشتگیں گالاں پہ زوت دست گرگ ءَ نشان بہ کن'**
  String get noBookmarksSubtitle;

  /// No description provided for @removeAction.
  ///
  /// In bal, this message translates to:
  /// **'دور کنگ'**
  String get removeAction;

  /// No description provided for @telegramShort.
  ///
  /// In bal, this message translates to:
  /// **'تلگرام'**
  String get telegramShort;

  /// No description provided for @instagramShort.
  ///
  /// In bal, this message translates to:
  /// **'اینستاگرام'**
  String get instagramShort;

  /// No description provided for @youtubeShort.
  ///
  /// In bal, this message translates to:
  /// **'یوتیوب'**
  String get youtubeShort;

  /// No description provided for @castboxShort.
  ///
  /// In bal, this message translates to:
  /// **'کست باکس'**
  String get castboxShort;

  /// No description provided for @followTakbandTitle.
  ///
  /// In bal, this message translates to:
  /// **'تاکبندکندیل ءِ همراه بہ بئے'**
  String get followTakbandTitle;

  /// No description provided for @followTakbandSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'اگاں سیدگنج پہ تو کارآمد بوتگ، مئے کسانیں لبزانکی گَبل ءِ تاک ءُ پادکستاں هم بچار دانکہ بلوچی زبان ءِ نوکیں کاراں سرپد بہ بئے.'**
  String get followTakbandSubtitle;

  /// No description provided for @dontShowAgainAction.
  ///
  /// In bal, this message translates to:
  /// **'دگہ پیش مدار'**
  String get dontShowAgainAction;

  /// No description provided for @maybeLaterAction.
  ///
  /// In bal, this message translates to:
  /// **'پدا بچاراں'**
  String get maybeLaterAction;

  /// No description provided for @splashSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'بلوچی ءَ پہ بلوچی بزانت‌بلد'**
  String get splashSubtitle;

  /// No description provided for @newVersionAvailableTitle.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں ورژن دست کپت (v{version})'**
  String newVersionAvailableTitle(String version);

  /// No description provided for @currentVersionLabel.
  ///
  /// In bal, this message translates to:
  /// **'تئی انّوگیں ورژن: v{version}'**
  String currentVersionLabel(String version);

  /// No description provided for @whatsNewLabel.
  ///
  /// In bal, this message translates to:
  /// **'نوکیں بدلی:'**
  String get whatsNewLabel;

  /// No description provided for @laterAction.
  ///
  /// In bal, this message translates to:
  /// **'پدا'**
  String get laterAction;

  /// No description provided for @downloadAction.
  ///
  /// In bal, this message translates to:
  /// **'اِیرگیج کن'**
  String get downloadAction;

  /// No description provided for @appNewVersionBannerTitle.
  ///
  /// In bal, this message translates to:
  /// **'سیدگنج ءِ نوکیں ورژن (v{version})'**
  String appNewVersionBannerTitle(String version);

  /// No description provided for @tapToDownloadSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'اِیرگیج کنگ ءِ ھاترا ٹپّ بہ جن'**
  String get tapToDownloadSubtitle;

  /// No description provided for @closeTooltip.
  ///
  /// In bal, this message translates to:
  /// **'بند کن'**
  String get closeTooltip;

  /// No description provided for @accentTeal.
  ///
  /// In bal, this message translates to:
  /// **'تیل سبز'**
  String get accentTeal;

  /// No description provided for @accentEmerald.
  ///
  /// In bal, this message translates to:
  /// **'شونز/سبز'**
  String get accentEmerald;

  /// No description provided for @accentBlue.
  ///
  /// In bal, this message translates to:
  /// **'نیل'**
  String get accentBlue;

  /// No description provided for @accentViolet.
  ///
  /// In bal, this message translates to:
  /// **'جَمو/وانگڑی'**
  String get accentViolet;

  /// No description provided for @accentAmber.
  ///
  /// In bal, this message translates to:
  /// **'زاپرانی'**
  String get accentAmber;

  /// No description provided for @accentRose.
  ///
  /// In bal, this message translates to:
  /// **'گُلابی'**
  String get accentRose;

  /// No description provided for @accentInk.
  ///
  /// In bal, this message translates to:
  /// **'سیاهی'**
  String get accentInk;

  /// No description provided for @colorStyleVividTitle.
  ///
  /// In bal, this message translates to:
  /// **'روشن (Vivid)'**
  String get colorStyleVividTitle;

  /// No description provided for @colorStyleVividSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'ساپ ءُ تچکیں رنگ پہ گیشتر زاهری ءَ'**
  String get colorStyleVividSubtitle;

  /// No description provided for @colorStyleSoftTitle.
  ///
  /// In bal, this message translates to:
  /// **'نرم (Soft)'**
  String get colorStyleSoftTitle;

  /// No description provided for @colorStyleSoftSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'آرامیں ءُ کم‌تیزیں رنگ پہ دراجیں وانگ ءَ'**
  String get colorStyleSoftSubtitle;

  /// No description provided for @colorStyleTintedTitle.
  ///
  /// In bal, this message translates to:
  /// **'رنگین (Tinted)'**
  String get colorStyleTintedTitle;

  /// No description provided for @colorStyleTintedSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'تاکدیم ءُ پشت‌در گوں گچین کتگیں رنگ ءِ ساھگ ءَ'**
  String get colorStyleTintedSubtitle;

  /// No description provided for @colorStyleMonochromeTitle.
  ///
  /// In bal, this message translates to:
  /// **'سادگ (Monochrome)'**
  String get colorStyleMonochromeTitle;

  /// No description provided for @colorStyleMonochromeSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'کاگد ءُ سیاہی ءِ سادگیں دروشم بید ء گیشیں رنگ ءَ'**
  String get colorStyleMonochromeSubtitle;

  /// No description provided for @bottomBarDockedTitle.
  ///
  /// In bal, this message translates to:
  /// **'لِچّتگیں (Docked)'**
  String get bottomBarDockedTitle;

  /// No description provided for @bottomBarDockedSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'چیر ءِ سیمسر ءَ لِچّتگیں سرجمیں بار'**
  String get bottomBarDockedSubtitle;

  /// No description provided for @bottomBarFloatingTitle.
  ///
  /// In bal, this message translates to:
  /// **'بالو (Floating)'**
  String get bottomBarFloatingTitle;

  /// No description provided for @bottomBarFloatingSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'کپسول ءِ دروشم ءَ آزادیں بار'**
  String get bottomBarFloatingSubtitle;

  /// No description provided for @fontVazirmatnTitle.
  ///
  /// In bal, this message translates to:
  /// **'وزیرمتن (Vazirmatn)'**
  String get fontVazirmatnTitle;

  /// No description provided for @fontVazirmatnSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'ساده، واناک ءُ مدرنیں کِشک پہ روچمرّگی وانگ ءَ'**
  String get fontVazirmatnSubtitle;

  /// No description provided for @fontDroshumTitle.
  ///
  /// In bal, this message translates to:
  /// **'دروشم بلوچی (Droshum Balochi)'**
  String get fontDroshumTitle;

  /// No description provided for @fontDroshumSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'بلوچی هاسیں کِشک پہ ادبی نبشتانک ءُ بزانت‌بلد ءَ'**
  String get fontDroshumSubtitle;

  /// No description provided for @fontSystemTitle.
  ///
  /// In bal, this message translates to:
  /// **'سیستم ءِ وتی کِشک (Default)'**
  String get fontSystemTitle;

  /// No description provided for @fontSystemSubtitle.
  ///
  /// In bal, this message translates to:
  /// **'موبائل ءِ بنیادی کِشک'**
  String get fontSystemSubtitle;

  /// No description provided for @colorStyleSettingTitle.
  ///
  /// In bal, this message translates to:
  /// **'رنگ ءِ انداز (Color Style)'**
  String get colorStyleSettingTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bal', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bal':
      return AppLocalizationsBal();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
