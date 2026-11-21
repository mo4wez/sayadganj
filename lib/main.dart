import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/navigation/main_shell_screen.dart';
import 'core/services/preferences_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/font_family_provider.dart';
import 'core/theme/theme_appearance_provider.dart';
import 'core/theme/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const SayadGanjApp(),
    ),
  );
}

class SayadGanjApp extends ConsumerWidget {
  const SayadGanjApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final appearance = ref.watch(themeAppearanceProvider);

    return MaterialApp(
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
      home: const MainShellScreen(),
    );
  }
}
