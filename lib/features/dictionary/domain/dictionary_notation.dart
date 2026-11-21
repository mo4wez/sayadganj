enum NotationCategory {
  language('زبان'),
  abbreviation('گْونڈگال'),
  source('بُنزہ ءُ وانگی'),
  symbol('ٹِک ءُ نشانی');

  final String label;
  const NotationCategory(this.label);
}

class DictionaryNotation {
  final String num;
  final String short;
  final String long;
  final NotationCategory category;

  const DictionaryNotation({
    required this.num,
    required this.short,
    required this.long,
    required this.category,
  });

  bool get isSymbol => category == NotationCategory.symbol;
}

class DictionaryNotationRegistry {
  DictionaryNotationRegistry._();

  static const List<DictionaryNotation> table1Languages = [
    DictionaryNotation(
      num: '۱',
      short: 'انگ',
      long: 'انگریزی',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۲',
      short: 'پا',
      long: 'پارسی',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۳',
      short: 'پھ',
      long: 'پھلوی',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۴',
      short: 'ستا',
      long: 'اوستا',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۵',
      short: 'سن',
      long: 'سنسکرت',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۶',
      short: 'سند',
      long: 'سندی',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۷',
      short: 'گیل',
      long: 'گیلککی',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۸',
      short: 'فب',
      long: 'فارسی باستان',
      category: NotationCategory.language,
    ),
    DictionaryNotation(
      num: '۹',
      short: 'ھن',
      long: 'ھندی',
      category: NotationCategory.language,
    ),
  ];

  static const List<DictionaryNotation> table2General = [
    DictionaryNotation(
      num: '۱',
      short: 'اک',
      long: 'انچوس کہ',
      category: NotationCategory.abbreviation,
    ),
    DictionaryNotation(
      num: '۲',
      short: 'پ ک',
      long: 'پیش چہ کرستانی',
      category: NotationCategory.abbreviation,
    ),
    DictionaryNotation(
      num: '۳',
      short: 'س م',
      long: 'سنٹی میٹر',
      category: NotationCategory.abbreviation,
    ),
    DictionaryNotation(
      num: '۴',
      short: 'بَت',
      long: 'بَتَل',
      category: NotationCategory.abbreviation,
    ),
  ];

  static const List<DictionaryNotation> table3Sources = [
    DictionaryNotation(
      num: '۱',
      short: 'ب۔ق',
      long: 'برھان قطع: محمد حسین بن خلف تبریزی',
      category: NotationCategory.source,
    ),
    DictionaryNotation(
      num: '۲',
      short: 'سغ',
      long: 'سفدی',
      category: NotationCategory.source,
    ),
    DictionaryNotation(
      num: '۳',
      short: 'شیرازی',
      long: 'گِسی زبان گال کہ چہ ”فرھنگ عامیانہ شیراز“ ءَ حسین امداد ءِ وانگی ”شیراز“ ءِ بزاات ءَ اِنت ،زیرگ بوتگ',
      category: NotationCategory.source,
    ),
    DictionaryNotation(
      num: '۴',
      short: 'طب',
      long: 'طبری (واژنامہ طبری)',
      category: NotationCategory.source,
    ),
  ];

  static const List<DictionaryNotation> table4Symbols = [
    DictionaryNotation(
      num: '۱',
      short: '★',
      long: 'گیش کُرتگیں گال ءَ بزانتانی گُڈ سرءَ جنگ بوتگ۔',
      category: NotationCategory.symbol,
    ),
    DictionaryNotation(
      num: '۲',
      short: '✷',
      long: 'گیش کرتگیں بزانتانی بنگیج ءَکارمرز بوتگ۔',
      category: NotationCategory.symbol,
    ),
    DictionaryNotation(
      num: '۳',
      short: '✪',
      long: 'ھما گال کہ سیدھاشمی ءَ نبشتگ انت بلے بزانت نبشتگ نہ کرتگ انت آیانی گُڈ سر ءَ اے ٹِک جنگ بوتگ',
      category: NotationCategory.symbol,
    ),
  ];

  static final List<DictionaryNotation> all = [
    ...table3Sources,
    ...table1Languages,
    ...table2General,
    ...table4Symbols,
  ];

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670]');

  /// Normalizes Arabic/Balochi character variants and diacritics for matching.
  static String normalize(String input) {
    return input
        .replaceAll(_diacriticsRegex, '')
        .replaceAll('ه', 'ھ')
        .replaceAll('ہ', 'ھ')
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('.', '۔')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static final Map<String, DictionaryNotation> _normalizedLookup = {
    for (final item in all) normalize(item.short): item,
  };

  /// Regex matching standalone word tokens (including multi-word "پ ک", "ب۔ق") or symbols.
  static final RegExp tokenPattern = RegExp(
    r'[★✷✪]|'
    r'(?<![\u0600-\u06FF])'
    r'(?:پ[\u064B-\u065F\u0670]*\s+ک[\u064B-\u065F\u0670]*|'
    r'س[\u064B-\u065F\u0670]*\s+م[\u064B-\u065F\u0670]*|'
    r'ب[\u064B-\u065F\u0670]*[۔.]ق[\u064B-\u065F\u0670]*|'
    r'[\u0621-\u06D3\u06D5-\u06FF\u064B-\u065F\u0670]+)'
    r'(?![\u0600-\u06FF])',
  );

  static DictionaryNotation? matchToken(String rawToken) {
    return _normalizedLookup[normalize(rawToken)];
  }

  /// Finds all unique notations present in a headword and/or definition.
  static List<DictionaryNotation> findInEntry({
    required String headword,
    required String definition,
  }) {
    final combined = '$headword $definition';
    final found = <DictionaryNotation>[];
    final seenShorts = <String>{};

    for (final match in tokenPattern.allMatches(combined)) {
      final token = match.group(0);
      if (token == null) continue;
      final notation = matchToken(token);
      if (notation != null && seenShorts.add(notation.short)) {
        found.add(notation);
      }
    }

    return found;
  }
}
