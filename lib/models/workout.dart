import 'package:thibolt/models/category.dart';
import 'package:thibolt/models/step.dart';

class Workout {
  int id;
  String name;
  Category category;
  int duration;

  Workout({required this.id, required this.name, required this.category, this.duration = 100});

  static List<Workout> workouts = [
    Workout(id: 2, category: Category.categories.first, name: 'Core strength #2')
  ];

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    workouts.add(Workout(
        id: 1,
        name: 'Core strength #1',
        category: Category.categories.first,
        duration: WorkoutStep.getDurationByWorkoutId(1)));
    workouts.add(Workout(id: 2, category: Category.categories.first, name: 'Core strength #2'));
    workouts.add(Workout(id: 3, category: Category.categories.first, name: 'Stretching #1'));
    workouts.add(Workout(id: 4, category: Category.categories.first, name: 'Zen8 Session #1'));

    return workouts;
  }
}
