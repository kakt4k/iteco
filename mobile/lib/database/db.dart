import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/di/di.dart';
import 'package:mobile/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'mydb.db');
    final Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, text TEXT);',
        );
      },
    );
    return db;
  }

  static Future<int> insertNote(String text) async {
    final Database db = await _openDatabase();
    final id = await db.rawInsert('INSERT INTO notes(text) VALUES(?);', [text]);
    db.close();
    return id;
  }

  static Future<List> getNotes() async {
    final Database db = await _openDatabase();
    final response = await db.rawQuery('SELECT * FROM notes;');
    db.close();
    return response.toList();
  }

  static Future<void> deleteNote(int id) async {
    final Database db = await _openDatabase();
    await db.rawDelete('DELETE FROM notes WHERE id = ?;', [id]);
    db.close();
  }

  static Future<void> updateNote(int id, String newText) async {
    final Database db = await _openDatabase();
    await db.rawUpdate('UPDATE notes SET text=? WHERE id=?;', [newText, id]);
    db.close();
  }

  static Future<void> sendInBackend() async {
    final Database db = await _openDatabase();
    final dio = getIt<Dio>();
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    List responseNotes = await db.rawQuery('SELECT text FROM notes;');
    List notesList = responseNotes.map((item) => item['text']).toList();
    final notes = NotesModel(notes: notesList);
    await dio.put(
      '/notes',
      data: notes.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    db.close();
  }

  static Future<void> clearNotes() async{
    final Database db = await _openDatabase();
    await db.rawDelete('DELETE FROM notes;');
    db.close();
  }
}
