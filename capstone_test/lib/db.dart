import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class DatabaseProvider {
  static late Database database;

  static Future<void> initializeDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    database = await openDatabase(
      join(await getDatabasesPath(), 'users_database.db'),
      onCreate: (db, version) {
        db.execute('DROP TABLE IF EXISTS users');
        return db.execute(
          'CREATE TABLE users(userid INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, age INTEGER, password TEXT, level INTEGER, accuracy REAL, email TEXT)',
        );
      },
      version: 2,
    );
  }

  static Database getDatabase() {
    return database;
  }
}

Future<void> insertUser(User user) async {
  final Database db = DatabaseProvider.database;

  await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<User>> users() async {
  final Database db = DatabaseProvider.database;

  final List<Map<String, Object?>> userMaps = await db.query('users');

  return [
    for (final {
          'userid': userid,
          'username': username,
          'age': age,
          'password': password,
          'level': level,
          'accuracy': accuracy,
          'email': email,
        } in userMaps)
      User(
        userid: userid as int,
        age: age as int,
        username: username as String,
        password: password as String,
        email: email as String,
        level: level as int,
        accuracy: accuracy as double,
      ),
  ];
}

Future<void> updateUser(User user) async {
  final Database db = DatabaseProvider.database;

  await db.update(
    'users',
    user.toMap(),
    where: 'userid = ?',
    whereArgs: [user.userid],
  );
}

bool checkPass(String username, String password) {
  final Database db = DatabaseProvider.database;

  final Future<List<Map<String, Object?>>> result = db.rawQuery(
    'SELECT userid FROM users WHERE username = ? AND password = ?',
    [username, password],
  );

  print(result);

  return true;
}

Future<void> deleteUser(int userid) async {
  final Database db = DatabaseProvider.database;

  await db.delete(
    'users',
    where: 'userid = ?',
    whereArgs: [userid],
  );
}

class User {
  final int userid;
  final int age;
  final String username;
  final String password;
  final String email;
  final int level;
  final double accuracy;

  User({
    required this.userid,
    required this.age,
    required this.username,
    required this.password,
    required this.email,
    required this.level,
    required this.accuracy,
  });

  Map<String, Object?> toMap() {
    return {
      'userid': userid,
      'age': age,
      'username': username,
      'password': password,
      'email': email,
      'level': level,
      'accuracy': accuracy,
    };
  }

  @override
  String toString() {
    return 'Person{id: $userid, name: $username, age: $age}';
  }
}
