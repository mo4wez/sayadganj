import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/user_db_service.dart';
import '../domain/reading_activity.dart';
import '../domain/word_entry.dart';

final readingActivityProvider = FutureProvider<ReadingActivitySummary>((
  ref,
) async {
  return UserDbService.instance.getReadingActivity();
});

class ReadingActivityController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> recordView(WordEntry word) async {
    await UserDbService.instance.recordWordView(word);
    ref.invalidate(readingActivityProvider);
  }

  Future<void> clearRecentWords() async {
    await UserDbService.instance.clearViewedWords();
    ref.invalidate(readingActivityProvider);
  }
}

final readingActivityControllerProvider =
    AsyncNotifierProvider<ReadingActivityController, void>(
      ReadingActivityController.new,
    );
