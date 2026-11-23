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
  /// **'پدیمیں گال'**
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
  /// **'کل دیستگیں: {count}'**
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
  /// **'زبان / زُبان'**
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
  /// **'یات‌دھانی (Notifications)'**
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
  /// **'گڈّی ورژن ءَ چکّاس کن'**
  String get checkLatestVersionSubtitle;

  /// No description provided for @appIsUpToDateSnack.
  ///
  /// In bal, this message translates to:
  /// **'تئی پریام گڈّی ورژن اِنت'**
  String get appIsUpToDateSnack;
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
