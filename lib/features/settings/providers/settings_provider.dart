import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/preferences_provider.dart';

class FontScaleNotifier extends Notifier<double> {
  static const String _prefKey = 'font_scale';

  @override
  double build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getDouble(_prefKey) ?? 1.0;
    return saved.clamp(0.85, 1.45);
  }

  Future<void> setScale(double scale) async {
    final clamped = scale.clamp(0.85, 1.45);
    if (state == clamped) return;
    state = clamped;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setDouble(_prefKey, clamped);
  }

  Future<void> reset() async {
    await setScale(1.0);
  }
}

final fontScaleProvider = NotifierProvider<FontScaleNotifier, double>(
  FontScaleNotifier.new,
);
