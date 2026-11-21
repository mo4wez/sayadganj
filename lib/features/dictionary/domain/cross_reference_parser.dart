class CrossReferenceParser {
  CrossReferenceParser._();

  static final RegExp _seeAlsoRegex = RegExp(
    r'''بچار\s*["«'“]([^"»'”]+)["»'”]''',
  );

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670]');

  /// Extracts unique referenced headwords from a definition string.
  static List<String> extractTargets(String definition) {
    final matches = _seeAlsoRegex.allMatches(definition);
    final results = <String>[];

    for (final match in matches) {
      final raw = match.group(1)?.trim() ?? '';
      if (raw.isNotEmpty && !results.contains(raw)) {
        results.add(raw);
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
