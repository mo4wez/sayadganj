import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/dictionary_providers.dart';
import '../providers/paginated_words_provider.dart';
import 'widgets/alphabet_dial_sheet.dart';
import 'widgets/animated_search_tools.dart';
import 'widgets/idle_dictionary_view.dart';
import 'widgets/paginated_word_list_view.dart';
import 'word_detail_screen.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _controller;
  late final FocusNode _searchFocusNode;
  bool _isSearchFocused = false;
  double _lastBottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = TextEditingController();
    _searchFocusNode = FocusNode()
      ..addListener(() {
        if (_isSearchFocused != _searchFocusNode.hasFocus) {
          setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
        }
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset =
        WidgetsBinding
            .instance
            .platformDispatcher
            .implicitView
            ?.viewInsets
            .bottom ??
        0.0;

    if (_lastBottomInset > 0 && bottomInset == 0 && _searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
    _lastBottomInset = bottomInset;
  }

  void _insertSpecialChar(String char) {
    if (ref.read(selectedLetterProvider) != null) {
      ref.read(selectedLetterProvider.notifier).clear();
    }

    final text = _controller.text;
    final selection = _controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;

    final updated = text.replaceRange(start, end, char);
    _controller.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + char.length),
    );

    if (!_searchFocusNode.hasFocus) {
      _searchFocusNode.requestFocus();
    }
    ref.read(searchQueryProvider.notifier).update(updated);
  }

  void _applyRecentSearch(String term) {
    ref.read(selectedLetterProvider.notifier).clear();
    _controller.text = term;
    _controller.selection = TextSelection.collapsed(offset: term.length);
    ref.read(searchQueryProvider.notifier).update(term);
    ref.read(searchHistoryControllerProvider.notifier).save(term);
  }

  void _handleLetterSelected(String? letter) {
    _searchFocusNode.unfocus();
    if (_controller.text.isNotEmpty) {
      _controller.clear();
    }
    ref.read(searchQueryProvider.notifier).clear();
    ref.read(selectedLetterProvider.notifier).select(letter);
  }

  Future<void> _openAlphabetDial(String? activeLetter) async {
    final buckets = await ref.read(letterBucketsProvider.future);
    if (!mounted || buckets.isEmpty) return;

    AlphabetDialSheet.show(
      context,
      buckets: buckets,
      initialLetter: activeLetter,
      onConfirmLetter: (chosen) => _handleLetterSelected(chosen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final scope = ref.watch(searchScopeProvider);
    final selectedLetter = ref.watch(selectedLetterProvider);
    final searchPageAsync = ref.watch(paginatedSearchWordsProvider);
    final letterPageAsync = ref.watch(paginatedLetterWordsProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasSearchQuery = query.trim().isNotEmpty;
    final hasLetterFilter = selectedLetter != null && selectedLetter.isNotEmpty;
    final showSearchTools = _isSearchFocused || query.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ClipRect(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  primary: false,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.bookOpenText,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('سیدگنج'),
                    ],
                  ),
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: PinnedHeaderSliver(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        border: innerBoxIsScrolled
                            ? Border(
                                bottom: BorderSide(
                                  color: colorScheme.outlineVariant,
                                  width: 1,
                                ),
                              )
                            : null,
                      ),
                      child: TapRegion(
                        onTapOutside: (_) {
                          if (_searchFocusNode.hasFocus) {
                            _searchFocusNode.unfocus();
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      focusNode: _searchFocusNode,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                        hintText: 'گالے بہ شوهاز...',
                                        prefixIcon: const Icon(
                                          LucideIcons.search,
                                          size: 20,
                                        ),
                                        suffixIcon: query.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(
                                                  LucideIcons.x,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  _controller.clear();
                                                  ref
                                                      .read(
                                                        searchQueryProvider
                                                            .notifier,
                                                      )
                                                      .clear();
                                                },
                                              )
                                            : null,
                                      ),
                                      onChanged: (text) {
                                        if (text.isNotEmpty &&
                                            hasLetterFilter) {
                                          ref
                                              .read(
                                                selectedLetterProvider.notifier,
                                              )
                                              .clear();
                                        }
                                        ref
                                            .read(searchQueryProvider.notifier)
                                            .update(text);
                                      },
                                      onSubmitted: (text) {
                                        ref
                                            .read(
                                              searchHistoryControllerProvider
                                                  .notifier,
                                            )
                                            .save(text);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _AlphabetDialButton(
                                    activeLetter: selectedLetter,
                                    onTap: () =>
                                        _openAlphabetDial(selectedLetter),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSearchTools(
                              visible: showSearchTools,
                              onInsertChar: _insertSpecialChar,
                            ),
                            if (!hasSearchQuery && hasLetterFilter)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  10,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LucideIcons.compass,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'آب «${selectedLetter == 'ا' ? 'ا / آ' : selectedLetter}» ءِ گال',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _openAlphabetDial(selectedLetter),
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          foregroundColor: colorScheme.primary,
                                        ),
                                        child: const Text('بدل کن'),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: Icon(
                                          LucideIcons.x,
                                          size: 16,
                                          color: colorScheme.primary,
                                        ),
                                        onPressed: () =>
                                            _handleLetterSelected(null),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: hasSearchQuery
                ? PaginatedWordListView(
                    useSliverOverlap: true,
                    asyncState: searchPageAsync,
                    onLoadMore: () => ref
                        .read(paginatedSearchWordsProvider.notifier)
                        .loadMore(),
                    highlightQuery: query,
                    scope: scope,
                    emptyIcon: LucideIcons.searchX,
                    emptyTitle: 'هچ گالے دست نہ کپت',
                    emptySubtitle: 'دگہ گالے یا کسانیں بھرے بہ شوهاز',
                    onTapWord: (word) {
                      if (query.trim().isNotEmpty) {
                        ref
                            .read(searchHistoryControllerProvider.notifier)
                            .save(query);
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WordDetailScreen(wordId: word.id),
                        ),
                      );
                    },
                  )
                : hasLetterFilter
                ? PaginatedWordListView(
                    useSliverOverlap: true,
                    asyncState: letterPageAsync,
                    onLoadMore: () => ref
                        .read(paginatedLetterWordsProvider.notifier)
                        .loadMore(),
                    emptyIcon: LucideIcons.bookX,
                    emptyTitle: 'هچ گالے دست نہ کپت',
                    emptySubtitle: 'اے آب ءَ هچ گال نیست',
                    onTapWord: (word) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WordDetailScreen(wordId: word.id),
                        ),
                      );
                    },
                  )
                : IdleDictionaryView(
                    recentAsync: recentAsync,
                    onSelectTerm: _applyRecentSearch,
                    onRemoveTerm: (term) => ref
                        .read(searchHistoryControllerProvider.notifier)
                        .remove(term),
                    onClearAll: () => ref
                        .read(searchHistoryControllerProvider.notifier)
                        .clearAll(),
                  ),
          ),
        ),
      ),
    );
  }
}

class _AlphabetDialButton extends StatelessWidget {
  final String? activeLetter;
  final VoidCallback onTap;

  const _AlphabetDialButton({required this.activeLetter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = activeLetter != null && activeLetter!.isNotEmpty;

    return Tooltip(
      message: 'چرخِ آب ءُ ب',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? colorScheme.primary : colorScheme.outline,
            width: isActive ? 1.6 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isActive
                  ? Text(
                      activeLetter == 'ا' ? 'ا/آ' : activeLetter!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: activeLetter == 'ا' ? 15 : 20,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      LucideIcons.compass,
                      size: 22,
                      color: colorScheme.primary,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
