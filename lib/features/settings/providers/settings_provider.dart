import 'package:flutter_riverpod/flutter_riverpod.dart';

class FontScaleNotifier extends Notifier<double> {
  @override
  double build() => 1.0;

  void setScale(double scale) {
    final clamped = scale.clamp(0.85, 1.45);
    if (state == clamped) return;
    state = clamped;
  }

  void reset() {
    state = 1.0;
  }
}

final fontScaleProvider = NotifierProvider<FontScaleNotifier, double>(
  FontScaleNotifier.new,
);
