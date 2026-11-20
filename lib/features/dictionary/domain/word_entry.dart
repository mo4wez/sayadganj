class WordEntry {
  final int id;
  final String fullWord;
  final String fullWordWithSymbols;
  final String definition;

  const WordEntry({
    required this.id,
    required this.fullWord,
    required this.fullWordWithSymbols,
    required this.definition,
  });

  factory WordEntry.fromMap(Map<String, dynamic> map) {
    return WordEntry(
      id: (map['id'] as num?)?.toInt() ?? 0,
      fullWord: map['full_word'] as String? ?? '',
      fullWordWithSymbols: map['full_word_with_symbols'] as String? ?? '',
      definition: map['definition'] as String? ?? '',
    );
  }
}
