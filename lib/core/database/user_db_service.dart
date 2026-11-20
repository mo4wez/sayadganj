import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/dictionary/domain/word_entry.dart';

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
}
