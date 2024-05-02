import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/song.dart';

class DatabaseHelper {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }
  initDB() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'coordinate_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE songs(
id INTEGER PRIMARY KEY AUTOINCREMENT,
songName TEXT,
artistName TEXT,
albumArtImagePath TEXT,
audioPath TEXT
)
''');
      },
      version: 1,
    );
  }

  Future<void> insertCoordinate(Song song) async {
    final db = await database;
    await db.insert('songs', {
      'songName': song.songName,
      'artistName': song.songName,
      'albumArtImagePath': song.albumArtImagePath,
      'audioPath': song.audioPath,
    });
  }
  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await database;
    return await db.query('songs');
  }
}