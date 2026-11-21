import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/featured_carousel_provider.dart';
import 'featured_word_slide.dart';

class WordOfTheDayCard extends ConsumerStatefulWidget {
  const WordOfTheDayCard({super.key});

  @override
  ConsumerState<WordOfTheDayCard> createState() => _WordOfTheDayCardState();
}

class _WordOfTheDayCardState extends ConsumerState<WordOfTheDayCard> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _activeIndex = 0;

  void _shuffleAndJumpToLucky(int slideCount) {
    HapticFeedback.selectionClick();
    ref.invalidate(featuredCarouselProvider);
    final targetIndex = slideCount > 1 ? 1 : 0;
    setState(() => _activeIndex = targetIndex);
    _carouselController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slidesAsync = ref.watch(featuredCarouselProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return slidesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (slides) {
        if (slides.isEmpty) return const SizedBox.shrink();

        final safeIndex = _activeIndex.clamp(0, slides.length - 1);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: slides.length,
              options: CarouselOptions(
                height: 204,
                viewportFraction: 1.0,
                enableInfiniteScroll: slides.length > 1,
                onPageChanged: (index, _) {
                  setState(() => _activeIndex = index);
                },
              ),
              itemBuilder: (context, index, _) {
                return FeaturedWordSlide(
                  item: slides[index],
                  onShuffleLucky: () => _shuffleAndJumpToLucky(slides.length),
                );
              },
            ),
            if (slides.length > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  final isSelected = index == safeIndex;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _carouselController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isSelected ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ],
        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}
