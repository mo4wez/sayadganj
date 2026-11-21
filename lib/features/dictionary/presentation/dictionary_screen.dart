import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../domain/word_entry.dart';
import '../providers/dictionary_providers.dart';
import 'widgets/alphabet_dial_sheet.dart';
import 'widgets/idle_dictionary_view.dart';
import 'widgets/animated_search_tools.dart';
import 'widgets/word_card.dart';
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

    // Unfocus search field automatically when the soft keyboard is dismissed
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

  void _openAlphabetDial(String? activeLetter) {
    final buckets = ref.read(letterBucketsProvider).value ?? const [];
    if (buckets.isEmpty) return;

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
    final selectedLetter = ref.watch(selectedLetterProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final letterWordsAsync = ref.watch(letterWordsProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasSearchQuery = query.trim().isNotEmpty;
    final hasLetterFilter = selectedLetter != null && selectedLetter.isNotEmpty;
    final showSearchTools = _isSearchFocused || query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          TapRegion(
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
                            hintText: 'لبزے بہ شوهاز...',
                            prefixIcon: const Icon(
                              LucideIcons.search,
                              size: 20,
                            ),
                            suffixIcon: query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(LucideIcons.x, size: 18),
                                    onPressed: () {
                                      _controller.clear();
                                      ref
                                          .read(searchQueryProvider.notifier)
                                          .clear();
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (text) {
                            if (text.isNotEmpty && hasLetterFilter) {
                              ref.read(selectedLetterProvider.notifier).clear();
                            }
                            ref.read(searchQueryProvider.notifier).update(text);
                          },
                          onSubmitted: (text) {
                            ref
                                .read(searchHistoryControllerProvider.notifier)
                                .save(text);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      _AlphabetDialButton(
                        activeLetter: selectedLetter,
                        onTap: () => _openAlphabetDial(selectedLetter),
                      ),
                    ],
                  ),
                ),
                AnimatedSearchTools(
                  visible: showSearchTools,
                  onInsertChar: _insertSpecialChar,
                ),
              ],
            ),
          ),
          Expanded(
            child: hasSearchQuery
                ? _buildWordList(
                    asyncWords: resultsAsync,
                    emptyIcon: LucideIcons.searchX,
                    emptyTitle: 'هچ لبزے دست نہ کپت',
                    emptySubtitle: 'دگہ لبزے یا کسانیں بھرے بہ شوهاز',
                    saveQueryOnTap: true,
                    queryToSave: query,
                  )
                : hasLetterFilter
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
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
                                  'حرف «${selectedLetter == 'ا' ? 'ا / آ' : selectedLetter}» ءِ لبز',
                                  style: theme.textTheme.labelMedium?.copyWith(
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
                                onPressed: () => _handleLetterSelected(null),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildWordList(
                          asyncWords: letterWordsAsync,
                          emptyIcon: LucideIcons.bookX,
                          emptyTitle: 'هچ لبزے دست نہ کپت',
                          emptySubtitle: 'اے حرف ءَ هچ لبز نیست',
                          saveQueryOnTap: false,
                        ),
                      ),
                    ],
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
        ],
      ),
    );
  }

  Widget _buildWordList({
    required AsyncValue<List<WordEntry>> asyncWords,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptySubtitle,
    required bool saveQueryOnTap,
    String queryToSave = '',
  }) {
    final scope = ref.watch(searchScopeProvider);

    return asyncWords.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _EmptyPromptState(
        icon: LucideIcons.circleAlert,
        title: 'ردی یے بوت',
        subtitle: '$err',
      ),
      data: (words) {
        if (words.isEmpty) {
          return _EmptyPromptState(
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: emptySubtitle,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: words.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final word = words[index];
            return WordCard(
                  word: word,
                  highlightQuery: saveQueryOnTap ? queryToSave : '',
                  scope: scope,
                  onTap: () {
                    if (saveQueryOnTap && queryToSave.trim().isNotEmpty) {
                      ref
                          .read(searchHistoryControllerProvider.notifier)
                          .save(queryToSave);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WordDetailScreen(wordId: word.id),
                      ),
                    );
                  },
                )
                .animate()
                .fadeIn(duration: 180.ms)
                .slideY(begin: 0.03, end: 0, duration: 180.ms);
          },
        );
      },
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

class _EmptyPromptState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyPromptState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
