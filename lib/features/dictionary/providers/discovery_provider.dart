import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../domain/discovery_category.dart';
import '../domain/word_entry.dart';

final discoveryWordsProvider =
    FutureProvider.family<List<WordEntry>, DiscoveryCategory>((
      ref,
      category,
    ) async {
      return DictionaryDbService.instance.getDiscoveryWords(category);
    });
