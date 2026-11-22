class CrossReferenceParser {
  CrossReferenceParser._();

  // Includes standard quotes, guillemets, and CJK/math double-angle brackets (《》〈〉≫≪)
  static const String _quoteChars = r'''"'«»‹›《》〈〉≫≪⟫⟪“”„‟‘’‚‛′″''';

  // Invisible Unicode format/control chars, non-breaking space, and tatweel
  static final RegExp _invisibleCharsRegex = RegExp(
    r'[\u00A0\u061C\u0640\u200B-\u200F\uFEFF]',
  );

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670]');

  // Matches anything at the start/end that is NOT a Balochi/Arabic letter, diacritic, or digit
  static final RegExp _nonWordEdgeRegex = RegExp(
    r'^[^\u0621-\u06D3\u06D5-\u06FF\u064B-\u065F\u06700-9\u06F0-\u06F9]+|'
    r'[^\u0621-\u06D3\u06D5-\u06FF\u064B-\u065F\u06700-9\u06F0-\u06F9]+$',
  );

  static final RegExp _seeAlsoRegex = RegExp(
    'ب[\\u064B-\\u065F\\u0670]*چار[\\s:：\\-–—]*(?:'
    // 1. Closed quotes/brackets (including mismatched pairs like "جونگ》)
    '[$_quoteChars]([^$_quoteChars\\n]+)[$_quoteChars]|'
    // 2. Unclosed opening quote/bracket
    '[$_quoteChars]([^$_quoteChars،؛:.!؟\\(\\)\\[\\]\\-–—\\n]+)|'
    // 3. Unquoted single word right after بچار
    '([^\\s$_quoteChars،؛:.!؟\\(\\)\\[\\]\\-–—/\\\\]+)'
    ')',
  );

  /// Removes invisible Unicode marks and any leading/trailing quotes, brackets, or symbols.
  static String cleanTarget(String raw) {
    return raw
        .replaceAll(_invisibleCharsRegex, '')
        .replaceAll(_nonWordEdgeRegex, '')
        .trim();
  }

  /// Extracts unique referenced headwords from a definition string.
  static List<String> extractTargets(String definition) {
    final matches = _seeAlsoRegex.allMatches(definition);
    final results = <String>[];

    for (final match in matches) {
      final raw = match.group(1) ?? match.group(2) ?? match.group(3) ?? '';
      final cleaned = cleanTarget(raw);

      if (cleaned.isNotEmpty && !results.contains(cleaned)) {
        results.add(cleaned);
      }
    }

    return results;
  }

  /// Strips diacritics, invisible chars, edge symbols, and normalizes letter variants.
  static String normalizeHeadword(String input) {
    final stripped = cleanTarget(input).replaceAll(_diacriticsRegex, '');
    final buffer = StringBuffer();

    for (int i = 0; i < stripped.length; i++) {
      final ch = stripped[i];
      buffer.write(switch (ch) {
        'آ' || 'أ' || 'إ' => 'ا',
        'ي' || 'ى' || 'ې' => 'ی',
        'ك' || 'ڪ' => 'ک',
        'ہ' || 'ۀ' => 'ه',
        'ؤ' => 'و',
        'ئ' => 'ی',
        _ => ch,
      });
    }

    return buffer.toString();
  }
}
