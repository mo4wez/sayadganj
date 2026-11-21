class ViewedWordEntry {
  final int wordId;
  final String fullWord;
  final String fullWordWithSymbols;
  final int viewedAt;

  const ViewedWordEntry({
    required this.wordId,
    required this.fullWord,
    required this.fullWordWithSymbols,
    required this.viewedAt,
  });

  String get displayWord =>
      fullWordWithSymbols.isNotEmpty ? fullWordWithSymbols : fullWord;

  factory ViewedWordEntry.fromMap(Map<String, Object?> map) {
    return ViewedWordEntry(
      wordId: (map['word_id'] as num).toInt(),
      fullWord: (map['full_word'] as String?) ?? '',
      fullWordWithSymbols: (map['full_word_with_symbols'] as String?) ?? '',
      viewedAt: (map['viewed_at'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReadingActivitySummary {
  final int streakDays;
  final int todayCount;
  final int totalUniqueCount;
  final List<ViewedWordEntry> recentWords;

  const ReadingActivitySummary({
    required this.streakDays,
    required this.todayCount,
    required this.totalUniqueCount,
    required this.recentWords,
  });

  static const empty = ReadingActivitySummary(
    streakDays: 0,
    todayCount: 0,
    totalUniqueCount: 0,
    recentWords: [],
  );
}
