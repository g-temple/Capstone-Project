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
        db.execute('DROP TABLE IF EXISTS reminders');
        db.execute(
            'CREATE TABLE reminders(userid INTEGER FOREIGN KEY AUTOINCREMENT, reminderid INTEGER PRIMARY KEY, reminderTxt TEXT, dateSet TEXT, dateCompBy TEXT)');
        return db.execute(
          'CREATE TABLE users(username TEXT PRIMARY KEY, age INTEGER, password TEXT, level INTEGER, accuracy REAL, email TEXT)',
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
    user.userMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertReminder(Reminder reminder) async {
  final Database db = DatabaseProvider.database;

  await db.insert('reminders', reminder.reminderMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<User>> users() async {
  final Database db = DatabaseProvider.database;

  final List<Map<String, Object?>> userMaps = await db.query('users');

  return [
    for (final {
          'username': username,
          'age': age,
          'password': password,
          'level': level,
          'accuracy': accuracy,
          'email': email,
        } in userMaps)
      User(
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
    user.userMap(),
    where: 'username = ?',
    whereArgs: [user.username],
  );
}

Future<bool> checkPass(String username, String password) async {
  final Database db = DatabaseProvider.database;

  final List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT userid FROM users WHERE username = ? AND password = ?',
    [username, password],
  );

  return result.isNotEmpty;
}

Future<bool> checkIfUsernameExists(String name) async {
  final Database db = DatabaseProvider.database;
  // Perform a query to check if the given username exists in the database
  final List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT COUNT(*) AS count FROM users WHERE username = ?',
    [name],
  );

  // Check the result of the query
  if (result.isNotEmpty) {
    final count = result.first['count'] as int;
    return count <
        1; // Returns false if count is greater than or equal to 1, indicating the username exists
  } else {
    return true; // Return true if the query didn't return any result
  }
}

Future<void> deleteUser(int userid) async {
  final Database db = DatabaseProvider.database;

  await db.delete(
    'users',
    where: 'username = ?',
    whereArgs: [userid],
  );
}

class User {
  final int age;
  final String username;
  final String password;
  final String email;
  final int level;
  final double accuracy;

  User({
    required this.age,
    required this.username,
    required this.password,
    required this.email,
    required this.level,
    required this.accuracy,
  });

  Map<String, Object?> userMap() {
    return {
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
    return 'Person{ name: $username, age: $age}';
  }
}

class Reminder {
  final int userId;
  final int reminderId;
  final String reminderText;
  final String dateSet;
  final String dateCompletedBy;

  Reminder({
    required this.userId,
    required this.reminderId,
    required this.reminderText,
    required this.dateSet,
    required this.dateCompletedBy,
  });

  Map<String, Object?> reminderMap() {
    return {
      'userId': userId,
      'reminderId': reminderId,
      'reminderTxt': reminderText,
      'dateSet': dateSet,
      'dateCompBy': dateCompletedBy,
    };
  }

  @override
  String toString() {
    return 'Reminder{userId: $userId, reminderId: $reminderId, reminderText: $reminderText, dateSet: $dateSet, dateCompletedBy: $dateCompletedBy}';
  }
}
