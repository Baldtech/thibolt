class StepModel {
  String name;

  StepModel({required this.name});

  static List<StepModel> getSteps() {
    List<StepModel> steps = [];

    steps.add(StepModel(name: 'Run'));
    steps.add(StepModel(name: 'Bike'));
    steps.add(StepModel(name: 'Swim'));
    steps.add(StepModel(name: 'Swim'));

    return steps;
  }
}
