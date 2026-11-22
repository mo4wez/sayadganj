import 'word_entry.dart';

class QuizQuestion {
  final WordEntry targetWord;
  final List<WordEntry> options;

  const QuizQuestion({required this.targetWord, required this.options});

  static final RegExp _startsWithSeeAlsoRegex = RegExp(
    r'^ب[\u064B-\u065F\u0670]*چار(?:[\s:："\u201C\u201D«»]|$)',
  );

  static final RegExp _trailingSeeAlsoRegex = RegExp(
    r'(?:^|[\s۔.!؟،؛\-–—])ب[\u064B-\u065F\u0670]*چار[\s:："\u201C\u201D«»].*$',
  );

  /// Returns true when [entry] has a real standalone meaning suitable for a quiz.
  static bool isQuizEligible(WordEntry entry) {
    if (entry.fullWord.trim().isEmpty) return false;
    if (entry.fullWordWithSymbols.contains('✪')) return false;

    final cleaned = formatOptionDefinition(entry);
    if (cleaned.length < 6) return false;
    if (_startsWithSeeAlsoRegex.hasMatch(cleaned)) return false;

    return true;
  }

  /// Removes leading headword, "( letter spelling )" block, trailing "بچار" notes,
  /// and masks standalone headword repeats.
  static String formatOptionDefinition(WordEntry entry) {
    var text = entry.definition.trim();

    final headwords = [
      entry.fullWordWithSymbols.trim(),
      entry.fullWord.trim(),
    ].where((w) => w.isNotEmpty).toSet().toList();

    // 1. Strip leading "headword:" prefix
    for (final hw in headwords) {
      if (text.startsWith(hw)) {
        final after = text.substring(hw.length);
        if (after.isEmpty || RegExp(r'^[\s:：\-–—]').hasMatch(after)) {
          text = after.replaceFirst(RegExp(r'^[\s:：\-–—]+'), '');
          break;
        }
      }
    }

    // 2. Strip leading parenthesized letter-by-letter spelling e.g. "( لُ ڈّ )"
    text = text.replaceFirst(RegExp(r'^\s*\([^)]+\)\s*'), '');

    // 3. If the entire remaining text is a "بچار" redirect, return it so
    //    isQuizEligible() can filter it out; otherwise strip any trailing "بچار" note.
    final trimmedBeforeSeeAlso = text.trim();
    if (_startsWithSeeAlsoRegex.hasMatch(trimmedBeforeSeeAlso)) {
      return trimmedBeforeSeeAlso;
    }
    text = trimmedBeforeSeeAlso.replaceFirst(_trailingSeeAlsoRegex, '');

    // 4. Mask standalone occurrences of the headword inside the definition text
    for (final hw in headwords) {
      final pattern = RegExp(
        '(?<=^|[\\s،؛:.!؟«»"\'\\(\\)\\[\\]\\-–—])${RegExp.escape(hw)}(?=\$|[\\s،؛:.!؟«»"\'\\(\\)\\[\\]\\-–—])',
      );
      text = text.replaceAll(pattern, '«ـــ»');
    }

    return text.trim();
  }
}
