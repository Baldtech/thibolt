// import 'package:sqflite/sqflite.dart';
// import '../../domain/entities/category.dart';

// abstract class ICategoryRepository {
//   Future<List<Category>> getCategories();
//   Future<Category> getCategory(int id);
// }

// class CategoryRepository extends ICategoryRepository {
//   final Database db;
//   static const String _tableName = 'Categories';

//   CategoryRepository({
//     required this.db,
//   });

//   @override
//   Future<List<Category>> getCategories() async {
//     final List<Map<String, Object?>> queryResult =
//         await db.query(_tableName, orderBy: 'name');
//     return queryResult.map((e) => Category.fromMap(e)).toList();
//   }

//   @override
//   Future<Category> getCategory(int id) async {
//     var categories =
//         await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
//     List<Category> categoriesList = categories.isNotEmpty
//         ? categories.map((c) => Category.fromMap(c)).toList()
//         : [];
//     return categoriesList.first;
//   }
// }
