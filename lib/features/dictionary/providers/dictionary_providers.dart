import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../../../core/database/user_db_service.dart';
import '../domain/word_entry.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String newQuery) {
    if (state == newQuery) return;
    state = newQuery;
  }

  void clear() {
    if (state.isEmpty) return;
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final searchResultsProvider = FutureProvider<List<WordEntry>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) return const [];

  return DictionaryDbService.instance.searchWords(query);
});

final wordDetailProvider = FutureProvider.family<WordEntry?, int>((
  ref,
  wordId,
) async {
  return DictionaryDbService.instance.getWordById(wordId);
});

final recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  return UserDbService.instance.getRecentSearches();
});

class SearchHistoryController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save(String query) async {
    await UserDbService.instance.addSearchQuery(query);
    ref.invalidate(recentSearchesProvider);
  }

  Future<void> remove(String query) async {
    await UserDbService.instance.removeSearchQuery(query);
    ref.invalidate(recentSearchesProvider);
  }

  Future<void> clearAll() async {
    await UserDbService.instance.clearSearchHistory();
    ref.invalidate(recentSearchesProvider);
  }
}

final searchHistoryControllerProvider =
    AsyncNotifierProvider<SearchHistoryController, void>(
      SearchHistoryController.new,
    );
