import 'word_entry.dart';

class QuizQuestion {
  final WordEntry targetWord;
  final List<WordEntry> options;

  const QuizQuestion({required this.targetWord, required this.options});

  /// Strips a leading "headword:" prefix so answer options don't give away the word
  static String formatOptionDefinition(WordEntry entry) {
    var text = entry.definition.trim();
    final prefixes = [
      entry.fullWordWithSymbols.trim(),
      entry.fullWord.trim(),
    ].where((p) => p.isNotEmpty);

    for (final prefix in prefixes) {
      if (text.startsWith(prefix)) {
        text = text.substring(prefix.length).trimLeft();
        text = text.replaceFirst(RegExp(r'^[:：\-–—]\s*'), '');
        break;
      }
    }

    return text.isNotEmpty ? text : entry.definition.trim();
  }
}
