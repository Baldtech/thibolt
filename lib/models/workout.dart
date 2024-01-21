
import 'dart:convert';

import 'package:thibolt/common_libs.dart';

class Workout {
  int id;
  String name;
  int categoryId;
  int duration;
  String stepJson;

  Workout(
      {this.id = -1,
      required this.name,
      required this.categoryId,
      this.duration = 100,
      this.stepJson = ''});

  Workout.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        categoryId = item["categoryId"],
        duration = item["duration"],
        stepJson = item["stepJson"];

  Map<String, Object> toMap() {
    var map = {'name': name, 'categoryId': categoryId, 'duration': duration, 'stepJson': stepJson};
    if (id != -1) map['id'] = id;

    return map;
  }

  List<WorkoutStep> getSteps() {
    List<WorkoutStep> steps = [];

    if (stepJson.isNotEmpty) {
      List<dynamic> json = jsonDecode(stepJson);
      for (var element in json) {
        steps.add(WorkoutStep.fromJson(element));
      }
    }

    return steps;
  }

  static List<Workout> workouts = [
    //Workout(id: 2, category: Category.categories.first, name: 'Core strength #2')
  ];

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    // workouts.add(Workout(
    //     id: 1,
    //     name: 'Core strength #1',
    //     category: Category.categories.first,
    //     duration: WorkoutStep.getDurationByWorkoutId(1)));
    // workouts.add(Workout(id: 2, category: Category.categories.first, name: 'Core strength #2'));
    // workouts.add(Workout(id: 3, category: Category.categories.first, name: 'Stretching #1'));
    // workouts.add(Workout(id: 4, category: Category.categories.first, name: 'Zen8 Session #1'));

    return workouts;
  }
}
