import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/dictionary/domain/word_entry.dart';

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

  Future<List<WordEntry>> searchWords(String query) async {
    final trimmed = query.trim();
    final escaped = trimmed
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_')
        .replaceAll("'", "''");
    // If the search box is empty, return an empty list right away
    if (trimmed.isEmpty) return [];

    final db = await database;

    final rows = await db.query(
      'sayadganj',
      where: 'full_word LIKE ? OR full_word_with_symbols LIKE ?',
      whereArgs: ['%$trimmed%', '%$trimmed%'],
      orderBy:
          "CASE WHEN full_word LIKE '$escaped%' ESCAPE '\\' THEN 0 ELSE 1 END, full_word ASC",
      limit: 50,
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
}
