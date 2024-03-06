import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> userMaps = await db.query('users');

    // Convert the list of each users's fields into a list of `Dog` objects.
    return [
      for (final {
            'userid': userid as int,
            'age': age as int,
            'username': username as String,
            'password': password as String,
            'level': level as int,
            'accuracy': accuracy as double,
          } in userMaps)
        User(
            userid: userid,
            age: age,
            username: username,
            password: password,
            level: level,
            accuracy: accuracy),
    ];
  }

  Future<void> updateDog(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'userid = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.userid],
    );
  }

  Future<void> deleteUser(int userid) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific dog.
      where: 'userid = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [userid],
    );
  }
/*
  // Create a Dog and add it to the dogs table
  var fido = User(
    userid: 0,
    username: 'Fido',
    age: 35,
    password: "pass",
    level: 0,
    accuracy: 100
  );

  await insertUser(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await users()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}
*/
}
// defintion of user

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

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
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

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Person{id: $userid, name: $username, age: $age}';
  }
}
