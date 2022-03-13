import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = "Clientezy.db";
  static final _dbVersion = 1;
  static final _tableName = "Clients";
  static final columnid = "id";
  static final ClientNmae = "Clientname";
  static final Mobileno = "Mobileno";
  static final DOB = "DOB";
  static final Lat = "lat";
  static final Long = "long";
  static final Type = "type";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _dataBase;
  Future<Database?> get database async {
    if (_dataBase != null) return _dataBase;

    _dataBase = await _initializeDatabase();

    return _dataBase;
  }

  _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) {
    print("creating database");

    db.execute(
        "CREATE TABLE $_tableName($columnid INTEGER PRIMARY KEY,$ClientNmae TEXT,$Mobileno TEXT,$DOB TEXT,$Lat TEXT,$Long TEXT ,$Type TEXT)");
  }

  Future<int> insert(
    Map<String, dynamic> row,
  ) async {
    print("inserting database");
    Database? db = await instance.database;
    return await db!.insert("$_tableName", row);
  }

  Future<List<Map<String, Object?>>> fetchdata() async {
    print("fetching database");
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT * FROM Clients');
  }
  Future<int> updateClientType(
      int id,String type
      ) async {
    print("updating database");
    Database? db = await instance.database;
    return await db!.rawUpdate('UPDATE Clients SET type = ? WHERE id = ?',
        [type, id]);
  }
}
