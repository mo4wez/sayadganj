import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../domain/word_entry.dart';
import 'dictionary_providers.dart';

class FeaturedWordSlideItem {
  final WordEntry word;
  final bool isWordOfTheDay;

  const FeaturedWordSlideItem({
    required this.word,
    required this.isWordOfTheDay,
  });
}

final featuredCarouselProvider = FutureProvider<List<FeaturedWordSlideItem>>((
  ref,
) async {
  final wotd = await ref.watch(wordOfTheDayProvider.future);
  final randomWords = await DictionaryDbService.instance.getRandomWords(
    limit: 5,
  );

  final slides = <FeaturedWordSlideItem>[];
  if (wotd != null) {
    slides.add(FeaturedWordSlideItem(word: wotd, isWordOfTheDay: true));
  }

  for (final item in randomWords) {
    if (wotd == null || item.id != wotd.id) {
      slides.add(FeaturedWordSlideItem(word: item, isWordOfTheDay: false));
    }
  }

  return slides;
});
