import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/dictionary/domain/word_entry.dart';
import '../../features/dictionary/domain/quiz_question.dart';
import '../../features/dictionary/domain/search_scope.dart';
import '../../features/dictionary/domain/cross_reference_parser.dart';
import '../../features/dictionary/domain/discovery_category.dart';

class LetterBucket {
  final String letter;
  final int count;

  const LetterBucket({required this.letter, required this.count});
}

class DictionaryDbService {
  DictionaryDbService._();
  static final DictionaryDbService instance = DictionaryDbService._();

  static const String _dbFileName = "sayadganj.db";
  static const String _assetPath = 'assets/db/sayadganj.db';

  Database? _db;

  /// Lazily opens (and on first run, copies) the read-only dictionary DB.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    try {
      final dbDir = await getDatabasesPath();
      final dbPath = join(dbDir, _dbFileName);

      if (!await File(dbPath).exists()) {
        await _copyAssetTo(dbPath);
      }
      return await openDatabase(dbPath, readOnly: true);
    } catch (e) {
      throw Exception('Could not open dictionary database: $e');
    }
  }

  Future<void> _copyAssetTo(String dbPath) async {
    // Ensure the target directory exists.
    await Directory(dirname(dbPath)).create(recursive: true);

    final ByteData data = await rootBundle.load(_assetPath);
    final Uint8List bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<List<WordEntry>> searchWords(
    String query, {
    SearchScope scope = SearchScope.containsHeadword,
    int limit = 40,
    int offset = 0,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final escaped = trimmed
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_')
        .replaceAll("'", "''");

    final db = await database;

    final (
      String whereClause,
      List<Object?> whereArgs,
      String orderBy,
    ) = switch (scope) {
      SearchScope.startsWith => (
        r"full_word LIKE ? ESCAPE '\' OR full_word_with_symbols LIKE ? ESCAPE '\'",
        ['$escaped\%', '$escaped%'],
        'full_word ASC',
      ),
      SearchScope.containsHeadword => (
        r"full_word LIKE ? ESCAPE '\' OR full_word_with_symbols LIKE ? ESCAPE '\'",
        ['%$escaped\%', '\%$escaped%'],
        'full_word ASC',
      ),
      SearchScope.inDefinitions => (
        r"SUBSTR(definition, INSTR(definition, ':') + 1) LIKE ? ESCAPE '\' "
            r"AND full_word NOT LIKE ? ESCAPE '\' "
            r"AND full_word_with_symbols NOT LIKE ? ESCAPE '\'",
        ['%$escaped%', '%$escaped\%', '\%$escaped%'],
        'full_word ASC',
      ),
    };

    final rows = await db.query(
      'sayadganj',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return rows.map((row) => WordEntry.fromMap(row)).toList();
  }

  Future<WordEntry?> getWordById(int id) async {
    final db = await database;

    final rows = await db.query(
      'sayadganj',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return WordEntry.fromMap(rows.first);
  }

  Future<WordEntry?> getWordOfTheDay() async {
    final db = await database;

    final countResult = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM sayadganj',
    );
    final total = (countResult.first['total'] as num?)?.toInt() ?? 0;
    if (total == 0) return null;

    // Deterministic daily index based on year, month, and day
    final now = DateTime.now();
    final daySeed = now.year * 10000 + now.month * 100 + now.day;
    final offset = daySeed % total;

    final rows = await db.query('sayadganj', limit: 1, offset: offset);

    if (rows.isEmpty) return null;
    return WordEntry.fromMap(rows.first);
  }

  Future<WordEntry?> getRandomWord() async {
    final db = await database;

    final rows = await db.query('sayadganj', orderBy: 'RANDOM()', limit: 1);

    if (rows.isEmpty) return null;
    return WordEntry.fromMap(rows.first);
  }

  Future<int> getTotalWordCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) AS total FROM sayadganj');
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  static const List<String> _balochiAlphabetOrder = [
    'ا',
    'ب',
    'پ',
    'ت',
    'ٹ',
    'ث',
    'ج',
    'چ',
    'ح',
    'خ',
    'د',
    'ڈ',
    'ذ',
    'ر',
    'ڑ',
    'ز',
    'ژ',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ک',
    'گ',
    'ل',
    'م',
    'ن',
    'و',
    'ھ',
    'ه',
    'ی',
    'ے',
  ];

  Future<List<LetterBucket>> getLetterBuckets() async {
    final db = await database;

    final rows = await db.rawQuery('''
      SELECT
        CASE SUBSTR(TRIM(full_word), 1, 1)
          WHEN 'آ' THEN 'ا'
          WHEN 'أ' THEN 'ا'
          WHEN 'إ' THEN 'ا'
          WHEN 'ي' THEN 'ی'
          WHEN 'ك' THEN 'ک'
          ELSE SUBSTR(TRIM(full_word), 1, 1)
        END AS first_char,
        COUNT(*) AS total
      FROM sayadganj
      WHERE TRIM(full_word) != ''
      GROUP BY first_char
    ''');

    final counts = <String, int>{};
    for (final row in rows) {
      final char = (row['first_char'] as String?) ?? '';
      final total = (row['total'] as num?)?.toInt() ?? 0;
      if (char.isNotEmpty && total > 0) {
        counts[char] = (counts[char] ?? 0) + total;
      }
    }

    // Keep strictly authentic Balochi alphabet letters in proper order
    final result = <LetterBucket>[];
    for (final letter in _balochiAlphabetOrder) {
      final count = counts[letter];
      if (count != null && count > 0) {
        result.add(LetterBucket(letter: letter, count: count));
      }
    }

    return result;
  }

  Future<List<WordEntry>> getWordsByLetter(
    String letter, {
    int limit = 40,
    int offset = 0,
  }) async {
    final db = await database;

    final List<String> variants = switch (letter) {
      'ا' => ['ا%', 'آ%', 'أ%', 'إ%'],
      'ی' => ['ی%', 'ي%'],
      'ک' => ['ک%', 'ك%'],
      _ => ['$letter%'],
    };

    final whereClause = List.filled(
      variants.length,
      'TRIM(full_word) LIKE ?',
    ).join(' OR ');

    final rows = await db.query(
      'sayadganj',
      where: whereClause,
      whereArgs: variants,
      orderBy: 'full_word ASC',
      limit: limit,
      offset: offset,
    );

    return rows.map((row) => WordEntry.fromMap(row)).toList();
  }

  Future<List<WordEntry>> getSampleWordsByLetter(
    String letter, {
    int limit = 3,
  }) async {
    return getWordsByLetter(letter, limit: limit);
  }

  Future<QuizQuestion?> getRandomQuizQuestion() async {
    final db = await database;

    final rows = await db.query(
      'sayadganj',
      where:
          "TRIM(full_word) != '' "
          'AND LENGTH(TRIM(definition)) >= 10 '
          "AND full_word_with_symbols NOT LIKE '%✪%'",
      orderBy: 'RANDOM()',
      limit: 24,
    );

    final eligible = rows
        .map((row) => WordEntry.fromMap(row))
        .where(QuizQuestion.isQuizEligible)
        .take(4)
        .toList();

    if (eligible.length < 4) return null;

    final target = eligible.first;
    final shuffledOptions = List<WordEntry>.of(eligible)..shuffle();

    return QuizQuestion(targetWord: target, options: shuffledOptions);
  }

  static String _escapeLike(String input) {
    return input
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }

  Future<WordEntry?> findWordByHeadword(String target) async {
    final cleaned = CrossReferenceParser.cleanTarget(target);
    if (cleaned.isEmpty) return null;

    final db = await database;

    // 1. Exact match against vocalized or plain headword
    final exactRows = await db.query(
      'sayadganj',
      where: 'TRIM(full_word_with_symbols) = ? OR TRIM(full_word) = ?',
      whereArgs: [cleaned, cleaned],
      limit: 1,
    );
    if (exactRows.isNotEmpty) {
      return WordEntry.fromMap(exactRows.first);
    }

    // 2. Normalized match (strips diacritics, ZWNJ, symbols, and Arabic/Urdu variants)
    final normalized = CrossReferenceParser.normalizeHeadword(cleaned);
    if (normalized.isEmpty) return null;

    final normalizedRows = await db.query(
      'sayadganj',
      where:
          "REPLACE(TRIM(full_word), '\u200C', '') = ? "
          "OR REPLACE(TRIM(full_word_with_symbols), '\u200C', '') = ?",
      whereArgs: [normalized, normalized],
      limit: 1,
    );
    if (normalizedRows.isNotEmpty) {
      return WordEntry.fromMap(normalizedRows.first);
    }

    final escaped = _escapeLike(normalized);

    // 3. Prefix match across both full_word and full_word_with_symbols
    final prefixRows = await db.query(
      'sayadganj',
      where:
          r"REPLACE(TRIM(full_word), '\u200C', '') LIKE ? ESCAPE '\' "
          r"OR REPLACE(TRIM(full_word_with_symbols), '\u200C', '') LIKE ? ESCAPE '\'",
      whereArgs: ['$escaped%', '$escaped%'],
      orderBy: 'LENGTH(TRIM(full_word)) ASC',
      limit: 1,
    );
    if (prefixRows.isNotEmpty) {
      return WordEntry.fromMap(prefixRows.first);
    }

    // 4. Contains fallback (matches searchWords behavior when a symbol/mark precedes the headword)
    final containsRows = await db.query(
      'sayadganj',
      where:
          r"REPLACE(full_word, '\u200C', '') LIKE ? ESCAPE '\' "
          r"OR REPLACE(full_word_with_symbols, '\u200C', '') LIKE ? ESCAPE '\'",
      whereArgs: ['%$escaped%', '%$escaped%'],
      orderBy: 'LENGTH(TRIM(full_word)) ASC',
      limit: 1,
    );
    if (containsRows.isNotEmpty) {
      return WordEntry.fromMap(containsRows.first);
    }

    return null;
  }

  Future<List<WordEntry>> getDiscoveryWords(
    DiscoveryCategory category, {
    int limit = 50,
  }) async {
    final db = await database;

    switch (category) {
      case DiscoveryCategory.richDefinitions:
        final rows = await db.query(
          'sayadganj',
          where: "TRIM(full_word) != '' AND LENGTH(TRIM(definition)) >= 140",
          orderBy: 'LENGTH(definition) DESC',
          limit: limit,
        );
        return rows.map((row) => WordEntry.fromMap(row)).toList();

      case DiscoveryCategory.vocalizedWords:
        final rows = await db.query(
          'sayadganj',
          where:
              "TRIM(full_word_with_symbols) != '' "
              'AND TRIM(full_word_with_symbols) != TRIM(full_word)',
          orderBy: 'RANDOM()',
          limit: limit,
        );
        return rows.map((row) => WordEntry.fromMap(row)).toList();

      case DiscoveryCategory.proverbsAndSources:
        final rows = await db.query(
          'sayadganj',
          where:
              "definition LIKE '%بَت%' "
              "OR definition LIKE '%شیرازی%' "
              "OR definition LIKE '%ب۔ق%' "
              "OR full_word_with_symbols LIKE '%★%' "
              "OR full_word_with_symbols LIKE '%✪%'",
          orderBy: 'full_word ASC',
          limit: limit,
        );
        return rows.map((row) => WordEntry.fromMap(row)).toList();

      case DiscoveryCategory.pastWeekWords:
        final total = await getTotalWordCount();
        if (total <= 0) return const [];

        final now = DateTime.now();
        final todayDays =
            DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;

        final results = <WordEntry>[];
        for (int i = 1; i <= 7; i++) {
          final offset = (todayDays - i).abs() % total;
          final rows = await db.query('sayadganj', limit: 1, offset: offset);
          if (rows.isNotEmpty) {
            results.add(WordEntry.fromMap(rows.first));
          }
        }
        return results;
    }
  }

  Future<List<WordEntry>> getRandomWords({int limit = 10}) async {
    final db = await database;

    final rows = await db.query(
      'sayadganj',
      where: "TRIM(full_word) != '' AND LENGTH(TRIM(definition)) >= 8",
      orderBy: 'RANDOM()',
      limit: limit,
    );

    return rows.map((row) => WordEntry.fromMap(row)).toList();
  }
}
