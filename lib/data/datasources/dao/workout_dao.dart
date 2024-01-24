import 'package:floor/floor.dart';

import '../../models/workout.dart';

@dao
abstract class WorkoutDao {
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkout(WorkoutModel workout);
  
  @delete
  Future<void> deleteWorkout(WorkoutModel workout);
  
  @Query('SELECT * FROM workouts')
  Future<List<WorkoutModel>> getWorkouts();

  @Query('SELECT * FROM workouts WHERE id = :id')
  Future<WorkoutModel?> getWorkoutById(int id);
}