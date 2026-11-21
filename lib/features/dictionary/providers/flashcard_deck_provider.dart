import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../../bookmarks/providers/bookmarks_provider.dart';
import '../domain/word_entry.dart';

class FlashcardDeckState {
  final List<WordEntry> words;
  final bool isFromBookmarks;

  const FlashcardDeckState({
    required this.words,
    required this.isFromBookmarks,
  });
}

final flashcardDeckProvider = FutureProvider<FlashcardDeckState>((ref) async {
  final bookmarks = await ref.watch(bookmarksProvider.future);
  if (bookmarks.isNotEmpty) {
    return FlashcardDeckState(words: bookmarks, isFromBookmarks: true);
  }

  final randomWords = await DictionaryDbService.instance.getRandomWords(
    limit: 10,
  );
  return FlashcardDeckState(words: randomWords, isFromBookmarks: false);
});
