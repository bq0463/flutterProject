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

  Future<Database> initDB() async {
    final path = await getDatabasesPath();
    final Future<Database> database = openDatabase(
      join(path, 'coordinate_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE songs(
id INTEGER PRIMARY KEY AUTOINCREMENT,
songName TEXT,
artistName TEXT,
albumArtImagePath TEXT,
audioPath TEXT,
note TEXT,
comment TEXT
)
''');
      },
      version: 2,
    );
    return database;
  }

  Future<void> insertSong(Song song) async {
    final db = await database;
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> getSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('songs');

    return List.generate(maps.length, (i) {
      return Song(
        songName: maps[i]['songName'],
        artistName: maps[i]['artistName'],
        albumArtImagePath: maps[i]['albumArtImagePath'],
        audioPath: maps[i]['audioPath'],
        comment: maps[i]['comment'],
        note: maps[i]['note'],
      );
    });
  }
}
