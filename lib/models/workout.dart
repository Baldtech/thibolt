import 'package:thibolt/models/category.dart';
import 'package:thibolt/models/step.dart';

class Workout {
  int id;
  String name;
  CategoryModel category;
  int duration;

  Workout({required this.id, required this.name, required this.category, this.duration = 100});

  static List<Workout> workouts = [
    Workout(id: 2, category: CategoryModel.categories.first, name: 'Core strength #2')
  ];

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    workouts.add(Workout(
        id: 1,
        name: 'Core strength #1',
        category: CategoryModel.categories.first,
        duration: StepModel.getDurationByWorkoutId(1)));
    workouts.add(Workout(id: 2, category: CategoryModel.categories.first, name: 'Core strength #2'));
    workouts.add(Workout(id: 3, category: CategoryModel.categories.first, name: 'Stretching #1'));
    workouts.add(Workout(id: 4, category: CategoryModel.categories.first, name: 'Zen8 Session #1'));

    return workouts;
  }
}
