import 'package:material_ui/material_ui.dart';

enum AppAccentColor {
  teal(
    id: 'teal',
    label: 'تیل سبز',
    lightColor: Color(0xFF0F766E),
    darkColor: Color(0xFF2DD4BF),
  ),
  emerald(
    id: 'emerald',
    label: 'زمرد',
    lightColor: Color(0xFF15803D),
    darkColor: Color(0xFF4ADE80),
  ),
  blue(
    id: 'blue',
    label: 'نیل',
    lightColor: Color(0xFF1D4ED8),
    darkColor: Color(0xFF60A5FA),
  ),
  violet(
    id: 'violet',
    label: 'بنفش',
    lightColor: Color(0xFF6D28D9),
    darkColor: Color(0xFFA78BFA),
  ),
  amber(
    id: 'amber',
    label: 'زعفرانی',
    lightColor: Color(0xFFB45309),
    darkColor: Color(0xFFFBBF24),
  ),
  rose(
    id: 'rose',
    label: 'مرجان',
    lightColor: Color(0xFFBE123C),
    darkColor: Color(0xFFFB7185),
  ),
  ink(
    id: 'ink',
    label: 'سیاہی',
    lightColor: Color(0xFF334155),
    darkColor: Color(0xFFCBD5E1),
  );

  final String id;
  final String label;
  final Color lightColor;
  final Color darkColor;

  const AppAccentColor({
    required this.id,
    required this.label,
    required this.lightColor,
    required this.darkColor,
  });

  static AppAccentColor fromId(String? id) {
    return AppAccentColor.values.firstWhere(
      (item) => item.id == id,
      orElse: () => AppAccentColor.teal,
    );
  }
}

enum AppColorStyle {
  vivid(
    id: 'vivid',
    title: 'روشن (Vivid)',
    subtitle: 'صاف ءُ تچکیں رنگ پہ گیشتر زاہری ءَ',
  ),
  soft(
    id: 'soft',
    title: 'نرم (Soft)',
    subtitle: 'آرامیں ءُ کم‌تیزیں رنگ پہ دراجیں وانگ ءَ',
  ),
  tinted(
    id: 'tinted',
    title: 'رنگین (Tinted)',
    subtitle: 'تاکدیم ءُ پشت‌در گوں گچین کتگیں رنگ ءِ ساھگ ءَ',
  ),
  monochrome(
    id: 'monochrome',
    title: 'سادہ (Monochrome)',
    subtitle: 'کاگد ءُ سیاہی ءِ سادگیں دروشم بید ء گیشیں رنگ ءَ',
  );

  final String id;
  final String title;
  final String subtitle;

  const AppColorStyle({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  static AppColorStyle fromId(String? id) {
    return AppColorStyle.values.firstWhere(
      (item) => item.id == id,
      orElse: () => AppColorStyle.vivid,
    );
  }
}

enum BottomBarStyle {
  docked(
    id: 'docked',
    title: 'چسپتگیں (Docked)',
    subtitle: 'چیر ءِ سیمسر ءَ چسپتگیں سرجمیں بار',
  ),
  floating(
    id: 'floating',
    title: 'بالو (Floating)',
    subtitle: 'کپسیول ءِ دروشم ءَ آزادیں بار',
  );

  final String id;
  final String title;
  final String subtitle;

  const BottomBarStyle({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  static BottomBarStyle fromId(String? id) {
    return BottomBarStyle.values.firstWhere(
      (item) => item.id == id,
      orElse: () => BottomBarStyle.docked,
    );
  }
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
