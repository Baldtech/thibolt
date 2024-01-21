import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatabase {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'thibolt_database.db'),
      onCreate: (database, version) async {
        _initiateTables(database);
        _initiateData(database);
      },
      version: 1,
    );
  }

  void _initiateTables(Database database) {
    database.execute(
        "CREATE TABLE Categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, icon TEXT NOT NULL)");
    database.execute(
        "CREATE TABLE Workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, categoryId INTEGER NOT NULL, duration INTEGER NOT NULL, stepJson TEXT NOT NULL, FOREIGN KEY(categoryId) REFERENCES Categories(id))");
  }

  void _initiateData(Database database) {
    database.execute(
        "INSERT INTO Categories(name, icon) VALUES ('swim', 'swim.svg')");
    database.execute(
        "INSERT INTO Categories(name, icon) VALUES ('stretching', 'stretching.svg')");
    database.execute(
        "INSERT INTO Categories(name, icon) VALUES ('core', 'core.svg')");
  }
}
