import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/preferences_provider.dart';

class CommunityPromptController extends Notifier<bool> {
  static const _sessionsKey = 'community_sessions_count';
  static const _wordsViewedKey = 'community_words_viewed';
  static const _lastShownMsKey = 'community_last_shown_ms';
  static const _optedOutKey = 'community_prompt_opted_out';

  static const int _minSessions = 3;
  static const int _minWordsViewed = 5;
  static const Duration _cooldown = Duration(days: 30);

  @override
  bool build() => false;

  void recordAppSession() {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = prefs.getInt(_sessionsKey) ?? 0;
    prefs.setInt(_sessionsKey, current + 1);
  }

  void recordWordOpened() {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = prefs.getInt(_wordsViewedKey) ?? 0;
    prefs.setInt(_wordsViewedKey, current + 1);
  }

  /// Evaluates calm eligibility rules and sets state = true if appropriate to show.
  bool evaluateAndTriggerIfEligible() {
    if (state) return false;

    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs.getBool(_optedOutKey) ?? false) return false;

    final sessions = prefs.getInt(_sessionsKey) ?? 0;
    final wordsViewed = prefs.getInt(_wordsViewedKey) ?? 0;
    if (sessions < _minSessions || wordsViewed < _minWordsViewed) {
      return false;
    }

    final lastShownMs = prefs.getInt(_lastShownMsKey) ?? 0;
    if (lastShownMs > 0) {
      final elapsed = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(lastShownMs),
      );
      if (elapsed < _cooldown) return false;
    }

    prefs.setInt(_lastShownMsKey, DateTime.now().millisecondsSinceEpoch);
    state = true;
    return true;
  }

  void dismissForNow() {
    state = false;
  }

  Future<void> optOutPermanently() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_optedOutKey, true);
    state = false;
  }
}

final communityPromptProvider =
    NotifierProvider<CommunityPromptController, bool>(
      CommunityPromptController.new,
    );
