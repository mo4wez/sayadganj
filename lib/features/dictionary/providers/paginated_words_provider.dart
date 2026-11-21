import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../domain/word_entry.dart';
import 'dictionary_providers.dart';

class PaginatedWordsState {
  final List<WordEntry> items;
  final bool hasMore;
  final bool isLoadingMore;

  const PaginatedWordsState({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  static const empty = PaginatedWordsState(
    items: [],
    hasMore: false,
    isLoadingMore: false,
  );

  PaginatedWordsState copyWith({
    List<WordEntry>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginatedWordsState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PaginatedLetterWordsNotifier extends AsyncNotifier<PaginatedWordsState> {
  static const int _pageSize = 40;

  @override
  Future<PaginatedWordsState> build() async {
    final letter = ref.watch(selectedLetterProvider);
    if (letter == null || letter.isEmpty) {
      return PaginatedWordsState.empty;
    }

    final firstPage = await DictionaryDbService.instance.getWordsByLetter(
      letter,
      limit: _pageSize,
      offset: 0,
    );

    return PaginatedWordsState(
      items: firstPage,
      hasMore: firstPage.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    final activeLetter = ref.read(selectedLetterProvider);
    if (activeLetter == null || activeLetter.isEmpty) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = await DictionaryDbService.instance.getWordsByLetter(
        activeLetter,
        limit: _pageSize,
        offset: current.items.length,
      );

      if (ref.read(selectedLetterProvider) != activeLetter) return;

      state = AsyncData(
        PaginatedWordsState(
          items: [...current.items, ...nextPage],
          hasMore: nextPage.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (ref.read(selectedLetterProvider) != activeLetter) return;
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final paginatedLetterWordsProvider =
    AsyncNotifierProvider<PaginatedLetterWordsNotifier, PaginatedWordsState>(
      PaginatedLetterWordsNotifier.new,
    );

class PaginatedSearchWordsNotifier extends AsyncNotifier<PaginatedWordsState> {
  static const int _pageSize = 40;

  @override
  Future<PaginatedWordsState> build() async {
    final query = ref.watch(searchQueryProvider);
    final scope = ref.watch(searchScopeProvider);

    if (query.trim().isEmpty) {
      return PaginatedWordsState.empty;
    }

    final firstPage = await DictionaryDbService.instance.searchWords(
      query,
      scope: scope,
      limit: _pageSize,
      offset: 0,
    );

    return PaginatedWordsState(
      items: firstPage,
      hasMore: firstPage.length == _pageSize,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    final activeQuery = ref.read(searchQueryProvider);
    final activeScope = ref.read(searchScopeProvider);
    if (activeQuery.trim().isEmpty) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = await DictionaryDbService.instance.searchWords(
        activeQuery,
        scope: activeScope,
        limit: _pageSize,
        offset: current.items.length,
      );

      if (ref.read(searchQueryProvider) != activeQuery ||
          ref.read(searchScopeProvider) != activeScope) {
        return;
      }

      state = AsyncData(
        PaginatedWordsState(
          items: [...current.items, ...nextPage],
          hasMore: nextPage.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (ref.read(searchQueryProvider) != activeQuery ||
          ref.read(searchScopeProvider) != activeScope) {
        return;
      }
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final paginatedSearchWordsProvider =
    AsyncNotifierProvider<PaginatedSearchWordsNotifier, PaginatedWordsState>(
      PaginatedSearchWordsNotifier.new,
    );
