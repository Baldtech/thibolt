enum StepType { block, single }

class StepModel {
  String name;
  int duration;
  int restDuration;
  int order;
  StepType type = StepType.single;
  List<StepModel>? children;
  int occurence = 0;

  StepModel(
      {required this.name,
      this.duration = 0,
      this.restDuration = 0,
      this.order = 0,
      this.type = StepType.single,
      this.occurence = 0, this.children = const []});

  static List<StepModel> getSteps() {
    List<StepModel> steps = [];

    steps.add(StepModel(name: 'Run'));
    steps.add(StepModel(name: 'Bike'));
    steps.add(StepModel(name: 'Swim'));
    steps.add(StepModel(name: 'Swim'));

    return steps;
  }

  static List<StepModel> getStepsByWorkoutId(int workoutId) {
    List<StepModel> steps = [];

    if (workoutId == 1) {
      for (var i = 0; i < 3; i++) {
        steps.add(StepModel(name: 'Plank', duration: 60, restDuration: 15));
        steps.add(StepModel(
            name: 'Lateral plank (R)', duration: 40, restDuration: 15));
        steps.add(StepModel(
            name: 'Lateral plank (L)', duration: 40, restDuration: 15));
        steps.add(StepModel(name: 'Bird dog', duration: 45, restDuration: 15));
        steps.add(StepModel(
            name: 'Plank with extended arms/legs',
            duration: 45,
            restDuration: 15));
        steps.add(StepModel(name: 'Superman', duration: 40, restDuration: 15));
        steps.add(
            StepModel(name: 'Hollow hold', duration: 40, restDuration: 15));
      }
    } else {
      steps.add(StepModel(name: 'Plank', duration: 4, restDuration: 10));
      steps.add(StepModel(name: 'Plank 2', duration: 5, restDuration: 10));
      steps.add(StepModel(name: 'Plank 3', duration: 6, restDuration: 10));
    }

    return steps;
  }

  static int getDurationByWorkoutId(int workoutId) {
    int duration = 0;

    var steps = getStepsByWorkoutId(workoutId);
    for (var step in steps) {
      duration += step.duration;
      duration += step.restDuration;
    }

    return duration;
  }
}
