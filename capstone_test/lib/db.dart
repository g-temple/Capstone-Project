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
        return db.execute(
          'CREATE TABLE users(userid INTEGER PRIMARY KEY, username TEXT, age INTEGER, password TEXT, level INTEGER, accuracy REAL)',
        );
      },
      version: 1,
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
          'age': age,
          'username': username,
          'password': password,
          'level': level,
          'accuracy': accuracy,
        } in userMaps)
      User(
        userid: userid as int,
        age: age as int,
        username: username as String,
        password: password as String,
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
  final int level;
  final double accuracy;

  User({
    required this.userid,
    required this.age,
    required this.username,
    required this.password,
    required this.level,
    required this.accuracy,
  });

  Map<String, Object?> toMap() {
    return {
      'userid': userid,
      'age': age,
      'username': username,
      'password': password,
      'level': level,
      'accuracy': accuracy,
    };
  }

  @override
  String toString() {
    return 'Person{id: $userid, name: $username, age: $age}';
  }
}
