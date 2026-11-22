import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/dictionary/domain/word_entry.dart';
import '../../features/dictionary/domain/reading_activity.dart';

class UserDbService {
  UserDbService._();
  static final UserDbService instance = UserDbService._();

  static const String _dbFileName = 'sayadganj_user.db';
  Database? _db;

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _dbFileName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            word_id INTEGER PRIMARY KEY,
            full_word TEXT NOT NULL,
            full_word_with_symbols TEXT NOT NULL,
            definition TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE search_history (
            query TEXT PRIMARY KEY,
            searched_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // --- Bookmarks ---

  Future<List<WordEntry>> getBookmarks() async {
    final db = await database;
    final rows = await db.query('bookmarks', orderBy: 'created_at DESC');

    return rows
        .map(
          (row) => WordEntry(
            id: (row['word_id'] as num).toInt(),
            fullWord: row['full_word'] as String? ?? '',
            fullWordWithSymbols: row['full_word_with_symbols'] as String? ?? '',
            definition: row['definition'] as String? ?? '',
          ),
        )
        .toList();
  }

  Future<bool> toggleBookmark(WordEntry word) async {
    final db = await database;
    final existing = await db.query(
      'bookmarks',
      columns: ['word_id'],
      where: 'word_id = ?',
      whereArgs: [word.id],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      await db.delete('bookmarks', where: 'word_id = ?', whereArgs: [word.id]);
      return false;
    } else {
      await db.insert('bookmarks', {
        'word_id': word.id,
        'full_word': word.fullWord,
        'full_word_with_symbols': word.fullWordWithSymbols,
        'definition': word.definition,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
  }

  Future<void> removeBookmark(int wordId) async {
    final db = await database;
    await db.delete('bookmarks', where: 'word_id = ?', whereArgs: [wordId]);
  }

  // --- Search History ---

  Future<List<String>> getRecentSearches({int limit = 12}) async {
    final db = await database;
    final rows = await db.query(
      'search_history',
      orderBy: 'searched_at DESC',
      limit: limit,
    );
    return rows.map((row) => row['query'] as String).toList();
  }

  Future<void> addSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final db = await database;
    await db.insert('search_history', {
      'query': trimmed,
      'searched_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Keep only the latest 15 searches
    await db.execute('''
      DELETE FROM search_history
      WHERE query NOT IN (
        SELECT query FROM search_history ORDER BY searched_at DESC LIMIT 15
      )
    ''');
  }

  Future<void> removeSearchQuery(String query) async {
    final db = await database;
    await db.delete('search_history', where: 'query = ?', whereArgs: [query]);
  }

  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  bool _activityTablesReady = false;

  Future<void> _ensureActivityTables(Database db) async {
    if (_activityTablesReady) return;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS viewed_words (
        word_id INTEGER PRIMARY KEY,
        full_word TEXT NOT NULL,
        full_word_with_symbols TEXT NOT NULL,
        viewed_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS reading_days (
        day_key TEXT PRIMARY KEY,
        views_count INTEGER NOT NULL DEFAULT 1
      )
    ''');

    _activityTablesReady = true;
  }

  static String _dayKey(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> recordWordView(WordEntry word) async {
    final db = await database;
    await _ensureActivityTables(db);

    final now = DateTime.now();
    final today = _dayKey(now);

    await db.insert('viewed_words', {
      'word_id': word.id,
      'full_word': word.fullWord,
      'full_word_with_symbols': word.fullWordWithSymbols,
      'viewed_at': now.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    final updated = await db.rawUpdate(
      'UPDATE reading_days SET views_count = views_count + 1 WHERE day_key = ?',
      [today],
    );
    if (updated == 0) {
      await db.insert('reading_days', {
        'day_key': today,
        'views_count': 1,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<ReadingActivitySummary> getReadingActivity({
    int recentLimit = 10,
  }) async {
    final db = await database;
    await _ensureActivityTables(db);

    final recentRows = await db.query(
      'viewed_words',
      orderBy: 'viewed_at DESC',
      limit: recentLimit,
    );
    final recentWords = recentRows
        .map((row) => ViewedWordEntry.fromMap(row))
        .toList();

    final countRow = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM viewed_words',
    );
    final totalUnique = (countRow.first['total'] as num?)?.toInt() ?? 0;

    final dayRows = await db.query('reading_days', orderBy: 'day_key DESC');

    final now = DateTime.now();
    final todayKey = _dayKey(now);
    final yesterdayKey = _dayKey(now.subtract(const Duration(days: 1)));

    int todayCount = 0;
    final activeDays = <String>{};

    for (final row in dayRows) {
      final key = (row['day_key'] as String?) ?? '';
      final count = (row['views_count'] as num?)?.toInt() ?? 0;
      if (key.isNotEmpty && count > 0) {
        activeDays.add(key);
        if (key == todayKey) {
          todayCount = count;
        }
      }
    }

    int streak = 0;
    DateTime? cursor;
    if (activeDays.contains(todayKey)) {
      cursor = DateTime(now.year, now.month, now.day);
    } else if (activeDays.contains(yesterdayKey)) {
      final y = now.subtract(const Duration(days: 1));
      cursor = DateTime(y.year, y.month, y.day);
    }

    while (cursor != null && activeDays.contains(_dayKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return ReadingActivitySummary(
      streakDays: streak,
      todayCount: todayCount,
      totalUniqueCount: totalUnique,
      recentWords: recentWords,
    );
  }

  Future<void> clearViewedWords() async {
    final db = await database;
    await _ensureActivityTables(db);
    await db.delete('viewed_words');
  }
}
