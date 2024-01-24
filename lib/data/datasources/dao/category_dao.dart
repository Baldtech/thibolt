import 'package:floor/floor.dart';

import '../../../domain/entities/category.dart';

@dao
abstract class WorkoutCategoryDao {
    
  @Query('SELECT * FROM categories')
  Future<List<WorkoutCategory>> getCategories();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<WorkoutCategory?> getCategoryById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(WorkoutCategory category);
}