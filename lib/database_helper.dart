import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabaseHelper {
  Database? _database;

  Future<void> openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'note_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> AddNote(Note note) async {
    if (_database == null) {
      await openDb();
    }

    await _database!.insert(
      'notes',
      note.toMap(),
    );
  }

  Future<List<Note>> getNotes() async {
    if (_database == null) {
      await openDb();
    }

    final List<Map<String, dynamic>> maps = await _database!.query('notes');

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> updateNote(Note note) async {
    if (_database == null) {
      await openDb();
    }

    await _database!.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    if (_database == null) {
      await openDb();
    }

    await _database!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
