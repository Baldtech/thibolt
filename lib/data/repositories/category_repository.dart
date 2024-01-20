import 'package:sqflite/sqflite.dart';
import 'package:thibolt/models/category.dart';

abstract class ICategoryRepository {
  Future<List<Category>> getCategories();
}

class CategoryRepository extends ICategoryRepository {
  final Database db;

  CategoryRepository({
    required this.db,
  });

  @override
  Future<List<Category>> getCategories() async {
    final List<Map<String, Object?>> queryResult = await db.query('Categories', orderBy: 'name');
    return queryResult.map((e) => Category.fromMap(e)).toList();
  }
}
