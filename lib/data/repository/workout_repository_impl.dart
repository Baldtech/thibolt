import '../../domain/entities/category.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repository/workout_repository.dart';
import '../datasources/app_database.dart';
import '../models/workout.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final AppDatabase _appDatabase;

  WorkoutRepositoryImpl(this._appDatabase);

  @override
  Future<void> addWorkout(Workout workout) {
    return _appDatabase.workoutDao
        .insertWorkout(WorkoutModel.fromEntity(workout));
  }

  @override
  Future<void> removeWorkout(int id) {
    return _appDatabase.workoutDao.getWorkoutById(id).then((value) =>
        {if (value != null) _appDatabase.workoutDao.deleteWorkout(value)});
  }

  @override
  Future<void> updateWorkout(Workout workout) {
    // TODO: implement updateWorkout
    throw UnimplementedError();
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    List<Workout> result = [];
    final workouts = await _appDatabase.workoutDao.getWorkouts();
    final categories = await _appDatabase.categoryDao.getCategories();
    for (var workout in workouts) {
      result.add(WorkoutModel.toEntity(
          workout,
          categories
              .firstWhere((element) => element.id == workout.categoryId)));
    }

    return result;
  }

  @override
  Future<List<WorkoutCategory>> getCategories() {
    return _appDatabase.categoryDao.getCategories();
  }
}
