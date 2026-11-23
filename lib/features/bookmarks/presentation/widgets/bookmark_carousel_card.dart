import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../dictionary/domain/word_entry.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dictionary/presentation/word_detail_screen.dart';

class BookmarkCarouselCard extends StatelessWidget {
  final WordEntry word;
  final VoidCallback onRemove;
  final VoidCallback? onInactiveTap;

  const BookmarkCarouselCard({
    super.key,
    required this.word,
    required this.onRemove,
    this.onInactiveTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final headword = word.fullWordWithSymbols.isNotEmpty
        ? word.fullWordWithSymbols
        : word.fullWord;
    final hasPlainForm =
        word.fullWordWithSymbols.isNotEmpty &&
        word.fullWordWithSymbols != word.fullWord;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap:
            onInactiveTap ??
            () {
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
                colorScheme.primary.withValues(alpha: 0.09),
                colorScheme.surface,
              ],
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top row: Bookmark badge + quick copy/delete actions
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.bookmarkCheck,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: l10n.copyTooltip,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(LucideIcons.copy, size: 17),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Clipboard.setData(
                        ClipboardData(text: '$headword\n${word.definition}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.wordAndMeaningCopiedSnack),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: l10n.removeAction,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      LucideIcons.trash2,
                      size: 17,
                      color: colorScheme.error,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onRemove();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Headword & plain spelling pill
              Text(
                headword,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontSize: 26,
                ),
              ),
              if (hasPlainForm) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      word.fullWord,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Expanded meaning preview
              Expanded(
                child: Text(
                  word.definition,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Footer CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10n.readFullDefinition,
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
    );
  }
}
