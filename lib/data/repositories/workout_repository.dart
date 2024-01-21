import 'package:sqflite/sqflite.dart';
import 'package:thibolt/models/workout.dart';

abstract class IWorkoutRepository {
  Future<List<Workout>> getWorkouts();
  Future<void> addWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> removeWorkout(int id);
}

class WorkoutRepository extends IWorkoutRepository {
  final Database db;
  static const String tableName = 'Workouts';

  WorkoutRepository({
    required this.db,
  });

  @override
  Future<List<Workout>> getWorkouts() async {
    final List<Map<String, Object?>> queryResult =
        await db.query(tableName, orderBy: 'name');
    return queryResult.map((e) => Workout.fromMap(e)).toList();
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    await db.insert(
      tableName,
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> removeWorkout(int id) async {
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    await db.update(
      tableName,
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }
}
