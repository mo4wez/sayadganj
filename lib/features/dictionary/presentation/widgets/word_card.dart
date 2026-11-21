import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/quiz_question.dart';
import '../../domain/search_scope.dart';
import '../../domain/word_entry.dart';
import 'highlighted_text.dart';

class WordCard extends StatelessWidget {
  final WordEntry word;
  final VoidCallback onTap;
  final String highlightQuery;
  final SearchScope scope;

  const WordCard({
    super.key,
    required this.word,
    required this.onTap,
    this.highlightQuery = '',
    this.scope = SearchScope.containsHeadword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final headword = word.fullWordWithSymbols.isNotEmpty
        ? word.fullWordWithSymbols
        : word.fullWord;

    final previewDefinition = scope == SearchScope.inDefinitions
        ? QuizQuestion.formatOptionDefinition(word)
        : word.definition;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: headword,
                      query: scope == SearchScope.inDefinitions
                          ? ''
                          : highlightQuery,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                      highlightColor: colorScheme.onPrimary,
                      highlightBackgroundColor: colorScheme.primary,
                    ),
                    const SizedBox(height: 6),
                    HighlightedText(
                      text: previewDefinition,
                      query: highlightQuery,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                      highlightColor: colorScheme.primary,
                      highlightBackgroundColor: colorScheme.primary.withValues(
                        alpha: 0.16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                LucideIcons.chevronLeft,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
