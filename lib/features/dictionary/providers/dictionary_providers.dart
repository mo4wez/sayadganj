import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
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
