import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../providers/featured_carousel_provider.dart';
import '../word_detail_screen.dart';

class FeaturedWordSlide extends StatelessWidget {
  final FeaturedWordSlideItem item;
  final VoidCallback onShuffleLucky;

  const FeaturedWordSlide({
    super.key,
    required this.item,
    required this.onShuffleLucky,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final word = item.word;

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
                item.isWordOfTheDay
                    ? colorScheme.primary.withValues(alpha: 0.12)
                    : colorScheme.secondary.withValues(alpha: 0.85),
                colorScheme.surface,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
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
                      color: item.isWordOfTheDay
                          ? colorScheme.secondary
                          : colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.isWordOfTheDay
                              ? LucideIcons.sparkles
                              : LucideIcons.shuffle,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.isWordOfTheDay ? 'روچ ءِ لبز' : 'بختاوریں لبز',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onShuffleLucky,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: colorScheme.primary,
                    ),
                    icon: const Icon(LucideIcons.shuffle, size: 15),
                    label: Text(
                      item.isWordOfTheDay ? 'بختاوریں لبز' : 'نوکیں لبز',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                displayWord,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  word.definition,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 6),
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
    );
  }
}
