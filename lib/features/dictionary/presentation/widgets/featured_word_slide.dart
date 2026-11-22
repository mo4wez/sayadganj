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

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670★✷✪]');

  String _cleanPreviewDefinition(String headword, String rawDefinition) {
    final trimmed = rawDefinition.trim();
    final colonIndex = trimmed.indexOf(':');
    if (colonIndex > 0 && colonIndex <= 32) {
      final cleanPrefix = trimmed
          .substring(0, colonIndex)
          .replaceAll(_diacriticsRegex, '')
          .trim();
      final cleanHeadword = headword.replaceAll(_diacriticsRegex, '').trim();
      if (cleanPrefix == cleanHeadword) {
        return trimmed.substring(colonIndex + 1).trim();
      }
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final word = item.word;

    final displayWord = word.fullWordWithSymbols.isNotEmpty
        ? word.fullWordWithSymbols
        : word.fullWord;
    final previewMeaning = _cleanPreviewDefinition(
      word.fullWord,
      word.definition,
    );

    final gradientStartAlpha = isDark
        ? (item.isWordOfTheDay ? 0.16 : 0.11)
        : (item.isWordOfTheDay ? 0.08 : 0.05);

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
                colorScheme.primary.withValues(alpha: gradientStartAlpha),
                colorScheme.surface,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top badge + shuffle action
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
                          item.isWordOfTheDay
                              ? LucideIcons.sparkles
                              : LucideIcons.shuffle,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.isWordOfTheDay ? 'روچ ءِ گال' : 'پَدیمیں گال',
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
                      item.isWordOfTheDay ? 'پَدیمیں گال' : 'نوکیں گال',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Headword
              Text(
                displayWord,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontSize: 24,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),

              // High-contrast meaning surface box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(
                      alpha: isDark ? 0.72 : 0.90,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    previewMeaning,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      height: 1.55,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Bottom CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'سرجمیں بزانت ءَ بوان',
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
