import 'package:thibolt/models/step.dart';

class Workout {
  int id;
  String name;
  String category;
  int duration;

  Workout({required this.id, required this.name, required this.category, this.duration = 100});

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    workouts.add(Workout(
        id: 1,
        name: 'Core strength #1',
        category: 'core',
        duration: StepModel.getDurationByWorkoutId(1)));
    workouts.add(Workout(id: 2, category: 'core', name: 'Core strength #2'));
    workouts.add(Workout(id: 3, category: 'stretching', name: 'Stretching #1'));
    workouts.add(Workout(id: 4, category: 'swim', name: 'Zen8 Session #1'));

    return workouts;
  }
}
