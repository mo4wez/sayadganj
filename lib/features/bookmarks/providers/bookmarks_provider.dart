import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/user_db_service.dart';
import '../../dictionary/domain/word_entry.dart';

final bookmarksProvider = FutureProvider<List<WordEntry>>((ref) async {
  return UserDbService.instance.getBookmarks();
});

final isBookmarkedProvider = Provider.family<bool, int>((ref, wordId) {
  final bookmarksAsync = ref.watch(bookmarksProvider);
  return bookmarksAsync.maybeWhen(
    data: (bookmarks) => bookmarks.any((word) => word.id == wordId),
    orElse: () => false,
  );
});

class BookmarkController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> toggle(WordEntry word) async {
    final isNowSaved = await UserDbService.instance.toggleBookmark(word);
    ref.invalidate(bookmarksProvider);
    return isNowSaved;
  }

  Future<void> remove(int wordId) async {
    await UserDbService.instance.removeBookmark(wordId);
    ref.invalidate(bookmarksProvider);
  }
}

final bookmarkControllerProvider =
    AsyncNotifierProvider<BookmarkController, void>(BookmarkController.new);
