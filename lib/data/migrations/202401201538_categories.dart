import 'package:sqflite/sqflite.dart';
import 'package:sqlite_schema_upgrader/sqlite_schema_upgrader.dart';

class Categories202401201538 extends CommandScript {
  @override
  Future<void> execute(Batch batch) async {
    batch.execute(
        "CREATE TABLE Categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, icon TEXT NOT NULL)");
batch.execute(
        "CREATE TABLE Workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, categoryId INTEGER NOT NULL, duration INTEGER NOT NULL, FOREIGN KEY(categoryId) REFERENCES Categories(id))");
    batch.execute(
        "INSERT INTO Categories(name, icon) VALUES ('swim', 'swim.svg')");
    batch.execute(
        "INSERT INTO Categories(name, icon) VALUES ('stretching', 'stretching.svg')");
    batch.execute(
        "INSERT INTO Categories(name, icon) VALUES ('core', 'core.svg')");
  }
}
