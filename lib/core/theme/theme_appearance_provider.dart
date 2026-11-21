import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/preferences_provider.dart';
import 'theme_settings.dart';

class ThemeAppearanceNotifier extends Notifier<ThemeAppearanceState> {
  static const String _pureBlackKey = 'theme_pure_black';
  static const String _accentKey = 'theme_accent_color';
  static const String _colorStyleKey = 'theme_color_style';
  static const String _bottomBarKey = 'theme_bottom_bar_style';

  @override
  ThemeAppearanceState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return ThemeAppearanceState(
      isPureBlack: prefs.getBool(_pureBlackKey) ?? false,
      accentColor: AppAccentColor.fromId(prefs.getString(_accentKey)),
      colorStyle: AppColorStyle.fromId(prefs.getString(_colorStyleKey)),
      bottomBarStyle: BottomBarStyle.fromId(prefs.getString(_bottomBarKey)),
    );
  }

  Future<void> setPureBlack(bool value) async {
    if (state.isPureBlack == value) return;
    state = state.copyWith(isPureBlack: value);
    await ref.read(sharedPreferencesProvider).setBool(_pureBlackKey, value);
  }

  Future<void> setAccentColor(AppAccentColor color) async {
    if (state.accentColor == color) return;
    state = state.copyWith(accentColor: color);
    await ref.read(sharedPreferencesProvider).setString(_accentKey, color.id);
  }

  Future<void> setColorStyle(AppColorStyle style) async {
    if (state.colorStyle == style) return;
    state = state.copyWith(colorStyle: style);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_colorStyleKey, style.id);
  }

  Future<void> setBottomBarStyle(BottomBarStyle style) async {
    if (state.bottomBarStyle == style) return;
    state = state.copyWith(bottomBarStyle: style);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_bottomBarKey, style.id);
  }
}

final themeAppearanceProvider =
    NotifierProvider<ThemeAppearanceNotifier, ThemeAppearanceState>(
      ThemeAppearanceNotifier.new,
    );
