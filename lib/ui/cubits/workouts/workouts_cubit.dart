import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/workout.dart';
import '../../../domain/repository/workout_repository.dart';

part 'workouts_state.dart';

class WorkoutsCubit extends Cubit<WorkoutsState> {
  final WorkoutRepository _databaseRepository;

  WorkoutsCubit(this._databaseRepository)
      : super(const WorkoutsLoading());

  Future<void> getAllWorkouts() async {
    emit(await _getAllWorkouts());
  }

  Future<void> removeWorkout({required Workout workout}) async {
    await _databaseRepository.removeWorkout(workout.id);
    emit(await _getAllWorkouts());
  }

  Future<void> saveWorkout({required Workout workout}) async {
    await _databaseRepository.addWorkout(workout);
    emit(await _getAllWorkouts());
  }

  Future<WorkoutsState> _getAllWorkouts() async {
    final workouts = await _databaseRepository.getWorkouts();
    return WorkoutsSuccess(workouts: workouts);
  }
}