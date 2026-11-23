// ignore_for_file: depend_on_referenced_packages
import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/balochi_intl_delegates.dart';
import 'core/navigation/main_shell_screen.dart';
import 'core/notifications/word_notification_service.dart';
import 'core/services/preferences_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/font_family_provider.dart';
import 'core/theme/theme_appearance_provider.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/community/providers/community_prompt_provider.dart';
import 'features/settings/providers/locale_provider.dart';
import 'features/settings/providers/notification_settings_provider.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/updates/providers/app_update_provider.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  try {
    await WordNotificationService.instance.initialize(
      navigatorKey: rootNavigatorKey,
    );
  } catch (e, st) {
    debugPrint('WordNotificationService init failed: $e\n$st');
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const SayadGanjApp(),
    ),
  );
}

class SayadGanjApp extends ConsumerStatefulWidget {
  const SayadGanjApp({super.key});

  @override
  ConsumerState<SayadGanjApp> createState() => _SayadGanjAppState();
}

class _SayadGanjAppState extends ConsumerState<SayadGanjApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(communityPromptProvider.notifier).recordAppSession();
      ref.read(appUpdateProvider.notifier).check(silent: true);

      final notif = ref.read(notificationSettingsProvider);
      if (notif.enabled) {
        WordNotificationService.instance.scheduleRollingWordOfTheDay(
          hour: notif.hour,
          minute: notif.minute,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('bal'), Locale('fa')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        BalochiMaterialLocalizationsDelegate(),
        BalochiCupertinoLocalizationsDelegate(),
        BalochiWidgetsLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      navigatorKey: rootNavigatorKey,
      title: 'سیدگنج',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        fontFamily: selectedFont.fontFamily,
        appearance: appearance,
      ),
      darkTheme: AppTheme.dark(
        fontFamily: selectedFont.fontFamily,
        appearance: appearance,
      ),
      themeMode: themeMode,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const SplashScreen(nextScreen: MainShellScreen()),
    );
  }
}
