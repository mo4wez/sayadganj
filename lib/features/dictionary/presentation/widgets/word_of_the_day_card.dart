import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/database/dictionary_db_service.dart';
import '../../providers/dictionary_providers.dart';
import '../word_detail_screen.dart';

class WordOfTheDayCard extends ConsumerStatefulWidget {
  const WordOfTheDayCard({super.key});

  @override
  ConsumerState<WordOfTheDayCard> createState() => _WordOfTheDayCardState();
}

class _WordOfTheDayCardState extends ConsumerState<WordOfTheDayCard> {
  bool _loadingRandom = false;

  Future<void> _openRandomWord() async {
    if (_loadingRandom) return;
    setState(() => _loadingRandom = true);

    try {
      final randomWord = await DictionaryDbService.instance.getRandomWord();
      if (!mounted || randomWord == null) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WordDetailScreen(wordId: randomWord.id),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingRandom = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wotdAsync = ref.watch(wordOfTheDayProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return wotdAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (word) {
        if (word == null) return const SizedBox.shrink();

        final displayWord = word.fullWordWithSymbols.isNotEmpty
            ? word.fullWordWithSymbols
            : word.fullWord;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WordDetailScreen(wordId: word.id),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.10),
                    colorScheme.surface,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.sparkles,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'روچ ءِ لبز',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _loadingRandom ? null : _openRandomWord,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: colorScheme.primary,
                        ),
                        icon: _loadingRandom
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            : const Icon(LucideIcons.shuffle, size: 15),
                        label: const Text('بختاوریں لبز'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayWord,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    word.definition,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'سرجمیں مانا ءَ بوان',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronLeft,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}
