import 'dart:convert';

import 'package:floor/floor.dart';

import '../../common/constants/strings.dart';
import '../../config/common_libs.dart';

@Entity(
  tableName: workoutsTableName,
)
class WorkoutModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int categoryId;
  final int duration;
  final String stepsJson;

  WorkoutModel({
    this.id,
    required this.name,
    required this.categoryId,
    required this.duration,
    required this.stepsJson,
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] as int,
      name: map['name'] as String,
      categoryId: map['categoryId'] as int,
      duration: map['duration'] as int,
      stepsJson: map['stepsJson'] as String,
    );
  }

  factory WorkoutModel.fromEntity(Workout entity) {
    return WorkoutModel(
      id: (entity.id == -1) ? null : entity.id,
      name: entity.name,
      categoryId: entity.category.id,
      duration: entity.duration,
      stepsJson: jsonEncode(entity.steps),
    );
  }

  static Workout toEntity(WorkoutModel w, WorkoutCategory category) {
    return Workout(
      id: w.id!,
      name: w.name,
      duration: w.duration,
      category: category,
      steps: jsonDecode(w.stepsJson)
          .map<WorkoutStep>((e) => WorkoutStep.fromJson(e))
          .toList()
    );
  }
}
