import 'dart:io';

import 'package:nowapps_sqllite/data_model/index.dart';
import 'package:nowapps_sqllite/util/ui_screen_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseOps {

  static DatabaseOps _instance;
  Database _database;

  static DatabaseOps getInstance() {
    if(_instance == null) {
      _instance = new DatabaseOps();
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserData.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "phone_number TEXT PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "age INTEGER,"
          "gender TEXT,"
          "email_id TEXT"
          ")");
    });
  }

  insertUserData(UserDataModel userData) async {
    try {
      final db = await database;
      var res = await db.insert("User", userData.toJson());
      UiScreenUtils.showToast("Updated Successfully");
      return res;
    } catch (e) {
      UiScreenUtils.showToast("Already record found with this phone number");
    }
  }

  Future<UserDataModel> readUserData(String phNo) async {
    final db = await database;
    var res = await  db.query("User", where: "phone_number = ?", whereArgs: [phNo]);
    UiScreenUtils.showToast("Details read Successfully");
    return res.isNotEmpty ? UserDataModel.fromJson(res.first) : Null ;
  }

  getAllUsers() async {
    final db = await database;
    var res = await db.query("Client");
    List<UserDataModel> list =
    res.isNotEmpty ? res.map((c) => UserDataModel.fromJson(c)).toList() : [];
    return list;
  }

  updateUserData(UserDataModel userData) async {
    final db = await database;
    var res = await db.update("User", userData.toJson(),
        where: "phone_number = ?", whereArgs: [userData.phoneNumber]);
    return res;
  }

  deleteUserData(String phNo) async {
    final db = await database;
    db.delete("User", where: "phone_number = ?", whereArgs: [phNo]);
    UiScreenUtils.showToast("Details deleted Successfully");
  }

  deleteAllUserData() async {
    final db = await database;
    db.rawDelete("Delete * from User");
  }


}