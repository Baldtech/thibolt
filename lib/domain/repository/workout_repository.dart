import '../entities/category.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<List<Workout>> getWorkouts();
  Future<void> addWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> removeWorkout(int id);

  Future<List<WorkoutCategory>> getCategories();
}