import 'dart:async';

import 'package:note_app/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDb {
  static final NoteDb instance = NoteDb._init();
  NoteDb._init();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'note.db'),
      onCreate: (db, version) {
        return db.execute('''
 CREATE TABLE $tableNotes(
              ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
              ${NoteFields.isImportant} BOOLEAN NOT NULL,
              ${NoteFields.number} INTEGER NOT NULL,
              ${NoteFields.title} TEXT NOT NULL,
              ${NoteFields.description} TEXT NOT NULL,
              ${NoteFields.time} TEXT NOT NULL
            )
    ''');
      },
      version: 1,
    );
  }

  Future create(Note note) async {
    final db = await database;
    final id = await db.insert(tableNotes, note.toMap());
    return note.copy(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final listMap = await db.query(tableNotes);
    return listMap
        .map(
          (e) => Note.fromMap(e),
        )
        .toList();
  }

  Future update(Note note) async {
    final db = await database;
    await db.update(tableNotes, note.toMap(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future delete(int id) async {
    final db = await database;
    await db.delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future<Note> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    } else {
      throw Exception('Note id Not Found');
    }
  }
}
