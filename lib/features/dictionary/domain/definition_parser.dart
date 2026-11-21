class SubDefinitionEntry {
  final String title;
  final String body;

  const SubDefinitionEntry({required this.title, required this.body});
}

class ParsedDefinition {
  final String rawText;
  final String? phoneticSpelling;
  final String primaryMeaning;
  final List<SubDefinitionEntry> subEntries;
  final List<String> narrativeParagraphs;

  const ParsedDefinition({
    required this.rawText,
    this.phoneticSpelling,
    required this.primaryMeaning,
    this.subEntries = const [],
    this.narrativeParagraphs = const [],
  });

  bool get isStructured =>
      subEntries.isNotEmpty || narrativeParagraphs.length > 1;
}

class DefinitionParser {
  DefinitionParser._();

  static final RegExp _leadingPhoneticRegex = RegExp(
    r'^\(\s*([^\(\)]{2,45})\s*\)\s*',
  );

  static final RegExp _seeAlsoStartRegex = RegExp(
    r'^ب[\u064B-\u065F\u0670]*چار\b',
  );

  static ParsedDefinition parse({
    required String headword,
    required String definition,
  }) {
    final trimmed = definition.trim();
    if (trimmed.isEmpty) {
      return ParsedDefinition(rawText: definition, primaryMeaning: '');
    }

    String working = trimmed;

    // 1. Strip redundant leading "headword:" prefix if present
    final firstColon = _findTopLevelColon(working);
    if (firstColon > 0 && firstColon <= 35) {
      final prefix = working.substring(0, firstColon).trim();
      if (_matchesHeadword(prefix, headword)) {
        working = working.substring(firstColon + 1).trim();
      }
    }

    // 2. Extract leading letter-by-letter vocalization e.g. "(پْ. رُ. شَگْ)"
    String? phonetic;
    final phoneticMatch = _leadingPhoneticRegex.firstMatch(working);
    if (phoneticMatch != null) {
      final candidate = phoneticMatch.group(1)?.trim() ?? '';
      if (candidate.contains('.') || candidate.contains('۔')) {
        phonetic = candidate;
        working = working.substring(phoneticMatch.end).trim();
      }
    }

    // 3. Split into top-level sentences (respecting quotes and parentheses)
    final sentences = _splitTopLevelSentences(working);

    final primaryBuffer = <String>[];
    final subEntries = <SubDefinitionEntry>[];
    String? currentTitle;
    final currentBody = <String>[];

    void flushSubEntry() {
      if (currentTitle != null) {
        subEntries.add(
          SubDefinitionEntry(
            title: currentTitle!,
            body: currentBody.join(' ').trim(),
          ),
        );
        currentTitle = null;
        currentBody.clear();
      }
    }

    for (final sentence in sentences) {
      final colonIdx = _findTopLevelColon(sentence);

      if (colonIdx > 1 && colonIdx <= 60) {
        final candidateTitle = sentence.substring(0, colonIdx).trim();
        final candidateBody = sentence.substring(colonIdx + 1).trim();

        final isValidSubHeading =
            candidateBody.isNotEmpty &&
            !_seeAlsoStartRegex.hasMatch(candidateTitle) &&
            !candidateTitle.contains('،') &&
            !candidateTitle.contains('؛') &&
            !candidateTitle.startsWith('”') &&
            !candidateTitle.startsWith('"');

        if (isValidSubHeading) {
          flushSubEntry();
          currentTitle = candidateTitle;
          currentBody.add(candidateBody);
          continue;
        }
      }

      if (currentTitle != null) {
        currentBody.add(sentence);
      } else {
        primaryBuffer.add(sentence);
      }
    }
    flushSubEntry();

    final primaryMeaning = primaryBuffer.join(' ').trim();

    // 4. For long entries without sub-entries, group into 2-sentence paragraphs
    final narrativeParagraphs = <String>[];
    if (subEntries.isEmpty && working.length >= 240 && sentences.length >= 3) {
      for (int i = 0; i < sentences.length; i += 2) {
        final end = (i + 2 < sentences.length) ? i + 2 : sentences.length;
        narrativeParagraphs.add(sentences.sublist(i, end).join(' ').trim());
      }
    }

    return ParsedDefinition(
      rawText: definition,
      phoneticSpelling: phonetic,
      primaryMeaning: primaryMeaning.isNotEmpty ? primaryMeaning : working,
      subEntries: subEntries,
      narrativeParagraphs: narrativeParagraphs,
    );
  }

  static bool _matchesHeadword(String prefix, String headword) {
    final cleanPrefix = prefix
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670★✷✪]'), '')
        .trim();
    final cleanHeadword = headword
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670★✷✪]'), '')
        .trim();
    return cleanPrefix == cleanHeadword;
  }

  /// Finds the first ':' or '：' outside parentheses, braces, or quotation marks.
  static int _findTopLevelColon(String text) {
    int parenDepth = 0;
    int braceDepth = 0;
    bool inDoubleQuote = false;

    for (int i = 0; i < text.length; i++) {
      final ch = text[i];
      if (ch == '(' || ch == '[') {
        parenDepth++;
      } else if (ch == ')' || ch == ']') {
        if (parenDepth > 0) parenDepth--;
      } else if (ch == '{') {
        braceDepth++;
      } else if (ch == '}') {
        if (braceDepth > 0) braceDepth--;
      } else if (ch == '”' || ch == '«') {
        inDoubleQuote = true;
      } else if (ch == '“' || ch == '»') {
        inDoubleQuote = false;
      } else if (ch == '"') {
        inDoubleQuote = !inDoubleQuote;
      } else if ((ch == ':' || ch == '：') &&
          parenDepth == 0 &&
          braceDepth == 0 &&
          !inDoubleQuote) {
        return i;
      }
    }
    return -1;
  }

  /// Splits text at sentence boundaries (., ۔, ؟, !) outside quotes and brackets.
  static List<String> _splitTopLevelSentences(String text) {
    final results = <String>[];
    final buffer = StringBuffer();
    int parenDepth = 0;
    int braceDepth = 0;
    bool inQuote = false;

    for (int i = 0; i < text.length; i++) {
      final ch = text[i];
      buffer.write(ch);

      if (ch == '(' || ch == '[') {
        parenDepth++;
      } else if (ch == ')' || ch == ']') {
        if (parenDepth > 0) parenDepth--;
      } else if (ch == '{') {
        braceDepth++;
      } else if (ch == '}') {
        if (braceDepth > 0) braceDepth--;
      } else if (ch == '”' || ch == '«') {
        inQuote = true;
      } else if (ch == '“' || ch == '»') {
        inQuote = false;
      } else if (ch == '"') {
        inQuote = !inQuote;
      }

      final isTerminator = ch == '.' || ch == '۔' || ch == '؟' || ch == '!';
      if (isTerminator && parenDepth == 0 && braceDepth == 0 && !inQuote) {
        // Consume any trailing closing quote immediately attached to punctuation
        while (i + 1 < text.length &&
            (text[i + 1] == '“' ||
                text[i + 1] == '”' ||
                text[i + 1] == '"' ||
                text[i + 1] == '»')) {
          i++;
          buffer.write(text[i]);
          inQuote = false;
        }

        final nextChar = (i + 1 < text.length) ? text[i + 1] : ' ';
        if (nextChar == ' ' || nextChar == '\n' || i + 1 == text.length) {
          final sentence = buffer.toString().trim();
          if (sentence.isNotEmpty) {
            results.add(sentence);
          }
          buffer.clear();
        }
      }
    }

    final remainder = buffer.toString().trim();
    if (remainder.isNotEmpty) {
      results.add(remainder);
    }

    return results;
  }
}
