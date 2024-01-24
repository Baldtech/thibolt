import '../../config/common_libs.dart';

class Workout {
  final int id;
  final String name;
  final WorkoutCategory category;
  final int duration;
  final List<WorkoutStep> steps;

  const Workout(
      {required this.id,
      required this.name,
      required this.category,
      required this.duration,
      required this.steps});

  Workout copyWith({
    int? id,
    String? name,
    WorkoutCategory? category,
    int? duration,
    List<WorkoutStep>? steps,
  }) {
    return Workout(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        duration: duration ?? this.duration,
        steps: steps ?? this.steps);
  }
}
