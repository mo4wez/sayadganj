import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../providers/flashcard_deck_provider.dart';
import 'flip_word_card.dart';

class FlashcardDeckSection extends ConsumerStatefulWidget {
  const FlashcardDeckSection({super.key});

  @override
  ConsumerState<FlashcardDeckSection> createState() =>
      _FlashcardDeckSectionState();
}

class _FlashcardDeckSectionState extends ConsumerState<FlashcardDeckSection> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final deckAsync = ref.watch(flashcardDeckProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return deckAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (deck) {
        if (deck.words.isEmpty) return const SizedBox.shrink();

        final total = deck.words.length;
        final safeIndex = _currentIndex.clamp(0, total - 1);
        final hasMultiple = total > 1;

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
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
                              LucideIcons.layers,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'لبزانی تاکدیم',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        deck.isFromBookmarks ? 'نشان کتگیں' : 'گچین کتگیں',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${safeIndex + 1} / $total',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // CarouselSlider 3D Flashcard Deck
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  itemCount: total,
                  options: CarouselOptions(
                    height: 210,
                    viewportFraction: hasMultiple ? 0.85 : 0.92,
                    enlargeCenterPage: hasMultiple,
                    enlargeFactor: 0.16,
                    enableInfiniteScroll: hasMultiple,
                    onPageChanged: (index, _) {
                      setState(() => _currentIndex = index);
                    },
                  ),
                  itemBuilder: (context, index, _) {
                    final isCenter = index == safeIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FlipWordCard(
                        word: deck.words[index],
                        onInactiveTap: isCenter
                            ? null
                            : () => _carouselController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton.outlined(
                        tooltip: 'پێشتر',
                        onPressed: hasMultiple
                            ? () {
                                HapticFeedback.selectionClick();
                                _carouselController.previousPage(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                );
                              }
                            : null,
                        style: IconButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(LucideIcons.chevronRight, size: 18),
                      ),
                      if (!deck.isFromBookmarks)
                        TextButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            setState(() => _currentIndex = 0);
                            _carouselController.jumpToPage(0);
                            ref.invalidate(flashcardDeckProvider);
                          },
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            foregroundColor: colorScheme.primary,
                          ),
                          icon: const Icon(LucideIcons.shuffle, size: 15),
                          label: const Text('نوکیں تاکدیم'),
                        )
                      else
                        Text(
                          'پہ دیمتر ءَ کشّ یا بہ ٹپّ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      IconButton.outlined(
                        tooltip: 'دیمتر',
                        onPressed: hasMultiple
                            ? () {
                                HapticFeedback.selectionClick();
                                _carouselController.nextPage(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                );
                              }
                            : null,
                        style: IconButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(LucideIcons.chevronLeft, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}
