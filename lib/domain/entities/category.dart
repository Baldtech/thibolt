import 'package:floor/floor.dart';

import '../../common/constants/strings.dart';

@Entity(
  tableName: categoriesTableName,
)
class WorkoutCategory {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String icon;

  WorkoutCategory({required this.id, required this.name, required this.icon});

  WorkoutCategory copyWith({
    int? id,
    String? name,
    String? icon,
  }) {
    return WorkoutCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}
