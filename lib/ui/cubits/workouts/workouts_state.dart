part of 'workouts_cubit.dart';

abstract class WorkoutsState extends Equatable {
  final List<Workout> workouts;
  final String? error;

  const WorkoutsState({
    this.workouts = const [],
    this.error,
  });

  @override
  List<Object> get props => [workouts];
}

class WorkoutsLoading extends WorkoutsState {
  const WorkoutsLoading();
}

class WorkoutsSuccess extends WorkoutsState {
  const WorkoutsSuccess({super.workouts});
}

class WorkoutsFailed extends WorkoutsState {
  const WorkoutsFailed({super.error});
}