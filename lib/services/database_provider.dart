import 'dart:async';
import 'dart:io';

import 'package:my_tasks/models/Task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tasks.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Task ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT,"
          "description TEXT,"
          "archived BIT,"
          "img TEXT,"
          "progress INTEGER,"
          "creationDate INTEGER,"
          "dueDate Integer"
        ")");
    });
  }

  newTask(Task task) async {
    final db = await this.database;
    var res = await db.insert('Task', task.toJson());

    return res;
  }

  getActiveTasks() async {
    final db = await this.database;
    var res = await db.query('Task', where: 'archived = 0', orderBy: 'creationDate');
    List<Task> tasks =
        res.isNotEmpty ? res.map((task) => Task.fromJson(task)).toList() : [];

    return tasks;
  }

  getArchivedTasks() async {
    final db = await this.database;
    var res = await db.query('Task', where: 'archived = 1', orderBy: 'creationDate');
    List<Task> tasks =
        res.isNotEmpty ? res.map((task) => Task.fromJson(task)).toList() : [];

    return tasks;
  }

  getTask(int id) async {
    final db = await this.database;
    var res = await db.query('Task', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Task.fromJson(res.first) : null;
  }

  updateTask(Task task) async {
    final db = await this.database;
    var res = await db
        .update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);

    return res;
  }

  deleteTask(int id) async {
    final db = await this.database;

    db.delete('Task', where: 'id = ?', whereArgs: [id]);
  }
}
