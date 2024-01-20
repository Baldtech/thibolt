
class Workout {
  int id;
  String name;
  int categoryId;
  int duration;

  Workout(
      {this.id = -1,
      required this.name,
      required this.categoryId,
      this.duration = 100});

  Workout.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        name = item["name"],
        categoryId = item["categoryId"],
        duration = item["duration"];

  Map<String, Object> toMap() {
    var map = {'name': name, 'categoryId': categoryId, 'duration': duration};
    if (id != -1) map['id'] = id;

    return map;
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
