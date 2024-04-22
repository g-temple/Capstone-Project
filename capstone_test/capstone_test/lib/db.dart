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
            'CREATE TABLE reminders(username TEXT, reminderName TEXT, dateSet TEXT, dateCompBy TEXT, isCompleted INTEGER, FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE)');
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
  print(user.userMap());
}

Future<void> insertReminder(Reminder reminder) async {
  final Database db = DatabaseProvider.database;

  await db.insert('reminders', reminder.reminderMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);

  print(reminder.toString());
}

Future<List<Map<String, dynamic>>> getRemindersForUser(String username) async {
  final Database db = await DatabaseProvider.database;

  return await db.query(
    'reminders',
    where: 'username = ? AND isCompleted = 0',
    whereArgs: [username],
  );
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

Future<void> updateCompletedReminder(String taskName) async {
  final Database db = DatabaseProvider.database;

  await db.execute(
      'UPDATE reminders SET isCompleted = 1 WHERE reminderName = ?',
      [taskName]);
}

Future<bool> checkPass(String username, String password) async {
  final Database db = DatabaseProvider.database;

  final List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT * FROM users WHERE username = ? AND password = ?',
    [username, password],
  );
  print(result);
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

Future<bool> checkIfTaskNameExists(String name) async {
  final Database db = DatabaseProvider.database;
  // Perform a query to check if the given username exists in the database
  final List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT COUNT(*) AS count FROM reminders WHERE reminderName = ?',
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
      'username': username,
      'age': age,
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
  final String username;
  final String reminderName;
  final String dateSet;
  final String dateCompletedBy;
  final int isCompleted;

  Reminder(
      {required this.username,
      required this.reminderName,
      required this.dateSet,
      required this.dateCompletedBy,
      required this.isCompleted});

  Map<String, Object?> reminderMap() {
    return {
      'username': username,
      'reminderName': reminderName,
      'dateSet': dateSet,
      'dateCompBy': dateCompletedBy,
      'isCompleted': 0
    };
  }

  @override
  String toString() {
    return 'Reminder{username: $username, taskDesc: $reminderName dateSet: $dateSet, dateCompletedBy: $dateCompletedBy}';
  }
}
