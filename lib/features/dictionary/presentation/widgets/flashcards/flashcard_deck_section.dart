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
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index, int total) {
    if (index < 0 || index >= total) return;
    HapticFeedback.selectionClick();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

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

        final safeIndex = _currentIndex.clamp(0, deck.words.length - 1);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Row(
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
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      '${safeIndex + 1} / ${deck.words.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Swipeable 3D Flashcard Viewport
                SizedBox(
                  height: 205,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: deck.words.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FlipWordCard(word: deck.words[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Bottom Controls (Prev / Refresh if random / Next)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.outlined(
                      tooltip: 'پێشتر',
                      onPressed: safeIndex > 0
                          ? () => _goToPage(safeIndex - 1, deck.words.length)
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
                          if (_pageController.hasClients) {
                            _pageController.jumpToPage(0);
                          }
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
                      onPressed: safeIndex < deck.words.length - 1
                          ? () => _goToPage(safeIndex + 1, deck.words.length)
                          : null,
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(LucideIcons.chevronLeft, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}
