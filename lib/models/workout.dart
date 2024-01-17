import 'package:thibolt/models/step.dart';

class Workout {
  int id;
  String name;
  int duration;

  Workout({required this.id, required this.name, this.duration = 100});

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    workouts.add(Workout(
        id: 1,
        name: 'Core strength #1',
        duration: StepModel.getDurationByWorkoutId(1)));
    workouts.add(Workout(id: 2, name: 'Core strength #2'));
    workouts.add(Workout(id: 3, name: 'Stretching #1'));
    workouts.add(Workout(id: 4, name: 'Zen8 Session #1'));

    return workouts;
  }
}
