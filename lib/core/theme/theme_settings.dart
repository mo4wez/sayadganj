import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

enum AppAccentColor {
  teal(id: 'teal', lightColor: Color(0xFF0F766E), darkColor: Color(0xFF2DD4BF)),
  emerald(
    id: 'emerald',
    lightColor: Color(0xFF15803D),
    darkColor: Color(0xFF4ADE80),
  ),
  blue(id: 'blue', lightColor: Color(0xFF1D4ED8), darkColor: Color(0xFF60A5FA)),
  violet(
    id: 'violet',
    lightColor: Color(0xFF6D28D9),
    darkColor: Color(0xFFA78BFA),
  ),
  amber(
    id: 'amber',
    lightColor: Color(0xFFB45309),
    darkColor: Color(0xFFFBBF24),
  ),
  rose(id: 'rose', lightColor: Color(0xFFBE123C), darkColor: Color(0xFFFB7185)),
  ink(id: 'ink', lightColor: Color(0xFF334155), darkColor: Color(0xFFCBD5E1));

  final String id;
  final Color lightColor;
  final Color darkColor;

  const AppAccentColor({
    required this.id,
    required this.lightColor,
    required this.darkColor,
  });

  static AppAccentColor fromId(String? id) {
    return AppAccentColor.values.firstWhere(
      (item) => item.id == id,
      orElse: () => AppAccentColor.teal,
    );
  }

  String localizedLabel(AppLocalizations l10n) => switch (this) {
    AppAccentColor.teal => l10n.accentTeal,
    AppAccentColor.emerald => l10n.accentEmerald,
    AppAccentColor.blue => l10n.accentBlue,
    AppAccentColor.violet => l10n.accentViolet,
    AppAccentColor.amber => l10n.accentAmber,
    AppAccentColor.rose => l10n.accentRose,
    AppAccentColor.ink => l10n.accentInk,
  };
}

enum AppColorStyle {
  vivid(id: 'vivid'),
  soft(id: 'soft'),
  tinted(id: 'tinted'),
  monochrome(id: 'monochrome');

  final String id;

  const AppColorStyle({required this.id});

  static AppColorStyle fromId(String? id) {
    return AppColorStyle.values.firstWhere(
      (item) => item.id == id,
      orElse: () => AppColorStyle.vivid,
    );
  }

  String localizedTitle(AppLocalizations l10n) => switch (this) {
    AppColorStyle.vivid => l10n.colorStyleVividTitle,
    AppColorStyle.soft => l10n.colorStyleSoftTitle,
    AppColorStyle.tinted => l10n.colorStyleTintedTitle,
    AppColorStyle.monochrome => l10n.colorStyleMonochromeTitle,
  };

  String localizedSubtitle(AppLocalizations l10n) => switch (this) {
    AppColorStyle.vivid => l10n.colorStyleVividSubtitle,
    AppColorStyle.soft => l10n.colorStyleSoftSubtitle,
    AppColorStyle.tinted => l10n.colorStyleTintedSubtitle,
    AppColorStyle.monochrome => l10n.colorStyleMonochromeSubtitle,
  };
}

enum BottomBarStyle {
  docked(id: 'docked'),
  floating(id: 'floating');

  final String id;

  const BottomBarStyle({required this.id});

  static BottomBarStyle fromId(String? id) {
    return BottomBarStyle.values.firstWhere(
      (item) => item.id == id,
      orElse: () => BottomBarStyle.docked,
    );
  }

  String localizedTitle(AppLocalizations l10n) => switch (this) {
    BottomBarStyle.docked => l10n.bottomBarDockedTitle,
    BottomBarStyle.floating => l10n.bottomBarFloatingTitle,
  };

  String localizedSubtitle(AppLocalizations l10n) => switch (this) {
    BottomBarStyle.docked => l10n.bottomBarDockedSubtitle,
    BottomBarStyle.floating => l10n.bottomBarFloatingSubtitle,
  };
}

class ThemeAppearanceState {
  final bool isPureBlack;
  final AppAccentColor accentColor;
  final AppColorStyle colorStyle;
  final BottomBarStyle bottomBarStyle;

  const ThemeAppearanceState({
    this.isPureBlack = false,
    this.accentColor = AppAccentColor.teal,
    this.colorStyle = AppColorStyle.vivid,
    this.bottomBarStyle = BottomBarStyle.docked,
  });

  ThemeAppearanceState copyWith({
    bool? isPureBlack,
    AppAccentColor? accentColor,
    AppColorStyle? colorStyle,
    BottomBarStyle? bottomBarStyle,
  }) {
    return ThemeAppearanceState(
      isPureBlack: isPureBlack ?? this.isPureBlack,
      accentColor: accentColor ?? this.accentColor,
      colorStyle: colorStyle ?? this.colorStyle,
      bottomBarStyle: bottomBarStyle ?? this.bottomBarStyle,
    );
  }
}
