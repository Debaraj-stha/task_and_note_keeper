import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/model.dart';

class dbController {
  static Database? database;
  Future<Database?> get db async {
    if (database != null) {
      return database;
    } else {
      database = await initDataBase();
      return database;
    }
  }

  Future<Database> initDataBase() async {
    io.Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.toString(), "mydatabase.db");

    var db = await openDatabase(path, version: 1, onCreate: (db, version) {
      String sql =
          "create table notes(id TEXT,title TEXT,description TEXT,createdAt INTEGER)";
      String sql2 =
          "create table tasks(id TEXT,title TEXT,createdAt INTEGER,reminder INTEGER)";
      db.execute(sql);
      db.execute(sql2);
    });
    return db;
  }

  Future<Notes> insertNote(Notes note) async {
    var dbClient = await db;
    await dbClient!.insert('notes', note.toJson());
    return note;
  }

  Future<List<Notes>> getNotes() async {
    var dbClient = await db;
    if (dbClient == null) {
      return [];
    } else {
      final List<Map<String, Object?>> result = await dbClient.query('notes');
      return result.map((e) => Notes.fromJson(e)).toList();
    }
  }

  Future<Notes> updateNotes(Notes note, String id) async {
    var dbClient = await db;
    await dbClient!
        .update('notes', note.toJson(), where: "id=?", whereArgs: [id]);
    return note;
  }

  Future<bool> deleteNotes(String id) async {
    var dbClient = await db;
    await dbClient!.delete('notes', where: "id=?", whereArgs: [id]);
    return true;
  }

  Future<bool> deleteTasks(String id) async {
    var dbClient = await db;
    await dbClient!.delete("tasks", where: "id=?", whereArgs: [id]);
    return true;
  }

  Future<Tasks> updateTasks(Tasks task, String id) async {
    var dbClient = await db;
    await dbClient!
        .update('tasks', task.toJson(), where: "id=?", whereArgs: [id]);
    debugPrint(jsonEncode(task));
    debugPrint(id);
    return task;
  }

  Future<List<Tasks>> getTasks() async {
    var dbClient = await db;
    if (dbClient == null) {
      return [];
    }
    final List<Map<String, Object?>> result = await dbClient!.query("tasks");
    return result.map((e) => Tasks.fromJson(e)).toList();
  }

  Future<Tasks> insertTask(Tasks tasks) async {
    var dbClient = await db;
    await dbClient!.insert("tasks", tasks.toJson());
    debugPrint("tasks" + tasks.toString());
    return tasks;
  }
}
