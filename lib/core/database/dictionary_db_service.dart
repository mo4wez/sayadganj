import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/dictionary/domain/word_entry.dart';
import '../../features/dictionary/domain/quiz_question.dart';
import '../../features/dictionary/domain/search_scope.dart';

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
        ['$escaped%', '$escaped%'],
        'full_word ASC',
      ),
      SearchScope.containsHeadword => (
        r"full_word LIKE ? ESCAPE '\' OR full_word_with_symbols LIKE ? ESCAPE '\'",
        ['%$escaped%', '%$escaped%'],
        "CASE WHEN full_word LIKE '$escaped%' ESCAPE '\\' THEN 0 ELSE 1 END, full_word ASC",
      ),
      SearchScope.inDefinitions => (
        r"full_word LIKE ? ESCAPE '\' OR full_word_with_symbols LIKE ? ESCAPE '\' OR definition LIKE ? ESCAPE '\'",
        ['%$escaped%', '%$escaped%', '%$escaped%'],
        "CASE WHEN full_word LIKE '$escaped%' ESCAPE '\\' THEN 0 "
            "WHEN full_word LIKE '%$escaped%' ESCAPE '\\' THEN 1 ELSE 2 END, full_word ASC",
      ),
    };

    final rows = await db.query(
      'sayadganj',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: 60,
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
    int limit = 150,
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
      where: "TRIM(full_word) != '' AND LENGTH(TRIM(definition)) >= 8",
      orderBy: 'RANDOM()',
      limit: 4,
    );

    if (rows.length < 4) return null;

    final entries = rows.map((row) => WordEntry.fromMap(row)).toList();
    final target = entries.first;
    final shuffledOptions = List<WordEntry>.of(entries)..shuffle();

    return QuizQuestion(targetWord: target, options: shuffledOptions);
  }
}
