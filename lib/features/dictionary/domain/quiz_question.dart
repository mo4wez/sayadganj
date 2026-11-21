import 'word_entry.dart';

class QuizQuestion {
  final WordEntry targetWord;
  final List<WordEntry> options;

  const QuizQuestion({required this.targetWord, required this.options});

  /// Removes leading headword + "( letter spelling )" block and masks standalone headword repeats
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

    // 3. Mask standalone occurrences of the headword inside the definition text
    for (final hw in headwords) {
      final pattern = RegExp(
        '(?<=^|[\\s،؛:.!؟«»"\'\\(\\)\\[\\]\\-–—])${RegExp.escape(hw)}(?=\$|[\\s،؛:.!؟«»"\'\\(\\)\\[\\]\\-–—])',
      );
      text = text.replaceAll(pattern, '«ـــ»');
    }

    final cleaned = text.trim();
    return cleaned.isNotEmpty ? cleaned : entry.definition.trim();
  }
}
