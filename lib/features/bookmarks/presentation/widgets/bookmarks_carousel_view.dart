import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../dictionary/domain/word_entry.dart';
import 'bookmark_carousel_card.dart';

class BookmarksCarouselView extends StatefulWidget {
  final List<WordEntry> words;
  final ValueChanged<WordEntry> onRemoveWord;

  const BookmarksCarouselView({
    super.key,
    required this.words,
    required this.onRemoveWord,
  });

  @override
  State<BookmarksCarouselView> createState() => _BookmarksCarouselViewState();
}

class _BookmarksCarouselViewState extends State<BookmarksCarouselView> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final total = widget.words.length;
    final safeIndex = _currentIndex.clamp(0, total - 1);
    final hasMultiple = total > 1;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        // Progress pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '${safeIndex + 1} / $total',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Main Carousel
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: total,
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: hasMultiple ? 0.85 : 0.92,
              enlargeCenterPage: hasMultiple,
              enlargeFactor: 0.14,
              enableInfiniteScroll: hasMultiple,
              onPageChanged: (index, _) {
                setState(() => _currentIndex = index);
              },
            ),
            itemBuilder: (context, index, _) {
              final word = widget.words[index];
              final isCenter = index == safeIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: BookmarkCarouselCard(
                  word: word,
                  onRemove: () => widget.onRemoveWord(word),
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
        ),
        const SizedBox(height: 14),

        // Bottom Controls
        Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            0,
            24,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
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
                icon: const Icon(LucideIcons.chevronRight, size: 20),
              ),
              Text(
                'پہ دیمتر ءَ کشّ یا بہ ٹپّ',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
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
                icon: const Icon(LucideIcons.chevronLeft, size: 20),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 200.ms);
  }
}
