import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/preferences_provider.dart';
import '../../l10n/app_localizations.dart';

enum AppFont {
  vazirmatn(
    id: 'vazirmatn',
    fontFamily: 'Vazirmatn',
    title: 'وزیرمتن (Vazirmatn)',
    subtitle: 'ساده، واناک ءُ مدرنیں کِشک پہ روچمرّگی وانگ ءَ',
  ),
  droshumBalochi(
    id: 'droshumBalochi',
    fontFamily: 'DroshumBalochi',
    title: 'دروشم بلوچی (Droshum Balochi)',
    subtitle: 'بلوچی هاسیں کِشک پہ ادبی نبشتانک ءُ بزانت‌بلد ءَ',
  ),
  system(
    id: 'system',
    fontFamily: null,
    title: 'سیستم ءِ وتی کِشک (Default)',
    subtitle: 'موبائل ءِ بنیادی کِشک',
  );

  final String id;
  final String? fontFamily;
  final String title;
  final String subtitle;

  const AppFont({
    required this.id,
    required this.fontFamily,
    required this.title,
    required this.subtitle,
  });

  static AppFont fromId(String? id) {
    return AppFont.values.firstWhere(
      (font) => font.id == id,
      orElse: () => AppFont.vazirmatn,
    );
  }

  String localizedTitle(AppLocalizations l10n) => switch (this) {
    AppFont.vazirmatn => l10n.fontVazirmatnTitle,
    AppFont.droshumBalochi => l10n.fontDroshumTitle,
    AppFont.system => l10n.fontSystemTitle,
  };

  String localizedSubtitle(AppLocalizations l10n) => switch (this) {
    AppFont.vazirmatn => l10n.fontVazirmatnSubtitle,
    AppFont.droshumBalochi => l10n.fontDroshumSubtitle,
    AppFont.system => l10n.fontSystemSubtitle,
  };
}

class FontFamilyNotifier extends Notifier<AppFont> {
  static const String _prefKey = 'app_font_family';

  @override
  AppFont build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return AppFont.fromId(prefs.getString(_prefKey));
  }

  Future<void> setFont(AppFont font) async {
    if (state == font) return;
    state = font;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_prefKey, font.id);
  }
}

final fontFamilyProvider = NotifierProvider<FontFamilyNotifier, AppFont>(
  FontFamilyNotifier.new,
);
