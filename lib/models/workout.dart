class Workout {
  String name;
  int duration;

  Workout({required this.name, this.duration = 100});

  static List<Workout> getWorkouts() {
    List<Workout> workouts = [];

    workouts.add(Workout(name: 'Core strength #1'));
    workouts.add(Workout(name: 'Core strength #2'));
    workouts.add(Workout(name: 'Stretching #1'));
    workouts.add(Workout(name: 'Zen8 Session #1'));


    return workouts;
  }
}
