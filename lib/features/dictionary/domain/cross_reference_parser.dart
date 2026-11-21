class CrossReferenceParser {
  CrossReferenceParser._();

  static final RegExp _seeAlsoRegex = RegExp(
    r'''ب[\u064B-\u065F\u0670]*چار[\s:：\-–—]*(?:'''
    // 1. Closed quotes (handles straight, curly, single, guillemets, or same-side quotes like “ word “)
    r'''["'«»“”‘’]([^"'«»“”‘’\n]+)["'«»“”‘’]|'''
    // 2. Unclosed opening quote (captures until punctuation or end of line)
    r'''["'«»“”‘’]([^"'«»“”‘’،؛:.!؟\(\)\[\]\-–—\n]+)|'''
    // 3. Unquoted single word right after بچار
    r'''([^\s"'«»“”‘’،؛:.!؟\(\)\[\]\-–—/\\]+)'''
    r''')''',
  );

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670]');
  static final RegExp _edgePunctuationRegex = RegExp(
    r'^[\s،؛:.!؟\-–—]+|[\s،؛:.!؟\-–—]+$',
  );

  /// Extracts unique referenced headwords from a definition string.
  static List<String> extractTargets(String definition) {
    final matches = _seeAlsoRegex.allMatches(definition);
    final results = <String>[];

    for (final match in matches) {
      final raw = match.group(1) ?? match.group(2) ?? match.group(3) ?? '';
      final cleaned = raw.replaceAll(_edgePunctuationRegex, '').trim();

      if (cleaned.isNotEmpty && !results.contains(cleaned)) {
        results.add(cleaned);
      }
    }

    return results;
  }

  /// Strips diacritics/shadda and normalizes Arabic/Balochi character variants for DB lookup.
  static String normalizeHeadword(String input) {
    final stripped = input.trim().replaceAll(_diacriticsRegex, '');
    final buffer = StringBuffer();

    for (int i = 0; i < stripped.length; i++) {
      final ch = stripped[i];
      buffer.write(switch (ch) {
        'آ' || 'أ' || 'إ' => 'ا',
        'ي' => 'ی',
        'ك' => 'ک',
        _ => ch,
      });
    }

    return buffer.toString();
  }
}
