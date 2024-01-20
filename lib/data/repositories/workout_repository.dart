import 'package:sqflite/sqflite.dart';
import 'package:thibolt/models/workout.dart';

abstract class IWorkoutRepository {
  Future<List<Workout>> getWorkouts();
  Future<void> addWorkout(Workout workout);
}

class WorkoutRepository extends IWorkoutRepository {
  final Database db;

  WorkoutRepository({
    required this.db,
  });

  @override
  Future<List<Workout>> getWorkouts() async {
    final List<Map<String, Object?>> queryResult = await db.query('Workouts', orderBy: 'name');
    return queryResult.map((e) => Workout.fromMap(e)).toList();
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    await db.insert(
      'Workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
