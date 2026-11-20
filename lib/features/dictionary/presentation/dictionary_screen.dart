import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/theme_mode_provider.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/word_card.dart';
import 'word_detail_screen.dart';
import 'widgets/word_of_the_day_card.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyRecentSearch(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.collapsed(offset: term.length);
    ref.read(searchQueryProvider.notifier).update(term);
    ref.read(searchHistoryControllerProvider.notifier).save(term);
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
        actions: [
          IconButton(
            tooltip: isDark ? 'روشنیں رنگ' : 'تاریکیں رنگ',
            icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
            onPressed: () {
              final platformBrightness = MediaQuery.platformBrightnessOf(
                context,
              );
              ref
                  .read(themeModeProvider.notifier)
                  .toggleTheme(platformBrightness);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'لبزے بہ شوهاز...',
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 18),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchQueryProvider.notifier).clear();
                        },
                      )
                    : null,
              ),
              onChanged: (text) {
                ref.read(searchQueryProvider.notifier).update(text);
              },
              onSubmitted: (text) {
                ref.read(searchHistoryControllerProvider.notifier).save(text);
              },
            ),
          ),
          Expanded(
            child: query.trim().isEmpty
                ? _IdleDictionaryView(
                    recentAsync: recentAsync,
                    onSelectTerm: _applyRecentSearch,
                    onRemoveTerm: (term) => ref
                        .read(searchHistoryControllerProvider.notifier)
                        .remove(term),
                    onClearAll: () => ref
                        .read(searchHistoryControllerProvider.notifier)
                        .clearAll(),
                  )
                : resultsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => _EmptyPromptState(
                      icon: LucideIcons.circleAlert,
                      title: 'ردی یے بوت',
                      subtitle: '$err',
                    ),
                    data: (words) {
                      if (words.isEmpty) {
                        return const _EmptyPromptState(
                          icon: LucideIcons.searchX,
                          title: 'هچ لبزے دست نہ کپت',
                          subtitle: 'دگہ لبزے یا کسانیں بھرے بہ شوهاز',
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
                                onTap: () {
                                  ref
                                      .read(
                                        searchHistoryControllerProvider
                                            .notifier,
                                      )
                                      .save(query);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          WordDetailScreen(wordId: word.id),
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
                  ),
          ),
        ],
      ),
    );
  }
}

class _IdleDictionaryView extends StatelessWidget {
  final AsyncValue<List<String>> recentAsync;
  final ValueChanged<String> onSelectTerm;
  final ValueChanged<String> onRemoveTerm;
  final VoidCallback onClearAll;

  const _IdleDictionaryView({
    required this.recentAsync,
    required this.onSelectTerm,
    required this.onRemoveTerm,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recents = recentAsync.maybeWhen(
      data: (list) => list,
      orElse: () => const <String>[],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        const WordOfTheDayCard(),
        if (recents.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.history,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text('تازگیں شوهاز', style: theme.textTheme.labelMedium),
                ],
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text('پاک کنگ'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recents.map((term) {
              return InputChip(
                label: Text(term),
                onPressed: () => onSelectTerm(term),
                onDeleted: () => onRemoveTerm(term),
                deleteIcon: const Icon(LucideIcons.x, size: 14),
                backgroundColor: colorScheme.surface,
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            }).toList(),
          ),
        ] else ...[
          const SizedBox(height: 36),
          const _EmptyPromptState(
            icon: LucideIcons.search,
            title: 'بلوچی لبزبلد',
            subtitle: 'پہ شوهاز کنگ ءَ یک لبزے بُرز ءَ نبیس',
          ),
        ],
      ],
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
