import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/preferences_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _prefKey = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_prefKey);

    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_prefKey, mode.name);
  }

  Future<void> toggleTheme(Brightness currentPlatformBrightness) async {
    final isCurrentlyDark =
        state == ThemeMode.dark ||
        (state == ThemeMode.system &&
            currentPlatformBrightness == Brightness.dark);
    await setThemeMode(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
