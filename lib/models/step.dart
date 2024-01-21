import 'package:json_annotation/json_annotation.dart';
part 'step.g.dart';

enum StepType { 
  @JsonValue("repeat")
  repeat, 
  @JsonValue("single")
  single }

@JsonSerializable()
class WorkoutStep {
  String name;
  int duration;
  int restDuration;
  int order;
  StepType type = StepType.single;
  List<WorkoutStep>? children;
  int occurence = 0;

  WorkoutStep(
      {required this.name,
      this.duration = 0,
      this.restDuration = 0,
      this.order = 0,
      this.type = StepType.single,
      this.occurence = 0,
      this.children = const []});

/// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory WorkoutStep.fromJson(Map<String, dynamic> json) => _$WorkoutStepFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$WorkoutStepToJson(this);
}
  // WorkoutStep.fromJson(Map<String, dynamic> json)
  //     : name = json["name"],
  //       duration = json["duration"],
  //       restDuration = json["restDuration"],
  //       order = json["order"],
  //       type = json["type"],
  //       children = json["children"],
  //       occurence = json["occurence"];

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'duration': duration,
  //     'restDuration': restDuration,
  //     'order': order,
  //     'type': type,
  //     'children': children,
  //     'occurence': occurence,
  //   };
  

  // static List<WorkoutStep> getSteps() {
  //   List<WorkoutStep> workoutSteps = [];

  //   workoutSteps.add(WorkoutStep(name: 'Run'));
  //   workoutSteps.add(WorkoutStep(name: 'Bike'));
  //   workoutSteps.add(WorkoutStep(name: 'Swim'));
  //   workoutSteps.add(WorkoutStep(name: 'Swim'));

  //   return workoutSteps;
  // }

  // static List<WorkoutStep> getStepsByWorkoutId(int workoutId) {
  //   List<WorkoutStep> workoutSteps = [];

  //   if (workoutId == 1) {
  //     for (var i = 0; i < 3; i++) {
  //       workoutSteps
  //           .add(WorkoutStep(name: 'Plank', duration: 60, restDuration: 15));
  //       workoutSteps.add(WorkoutStep(
  //           name: 'Lateral plank (R)', duration: 40, restDuration: 15));
  //       workoutSteps.add(WorkoutStep(
  //           name: 'Lateral plank (L)', duration: 40, restDuration: 15));
  //       workoutSteps
  //           .add(WorkoutStep(name: 'Bird dog', duration: 45, restDuration: 15));
  //       workoutSteps.add(WorkoutStep(
  //           name: 'Plank with extended arms/legs',
  //           duration: 45,
  //           restDuration: 15));
  //       workoutSteps
  //           .add(WorkoutStep(name: 'Superman', duration: 40, restDuration: 15));
  //       workoutSteps.add(
  //           WorkoutStep(name: 'Hollow hold', duration: 40, restDuration: 15));
  //     }
  //   } else {
  //     workoutSteps
  //         .add(WorkoutStep(name: 'Plank', duration: 4, restDuration: 10));
  //     workoutSteps
  //         .add(WorkoutStep(name: 'Plank 2', duration: 5, restDuration: 10));
  //     workoutSteps
  //         .add(WorkoutStep(name: 'Plank 3', duration: 6, restDuration: 10));
  //   }

  //   return workoutSteps;
  // }

  // static int getDurationByWorkoutId(int workoutId) {
  //   int duration = 0;

  //   var workoutSteps = getStepsByWorkoutId(workoutId);
  //   for (var workoutStep in workoutSteps) {
  //     duration += workoutStep.duration;
  //     duration += workoutStep.restDuration;
  //   }

  //   return duration;
  // }
