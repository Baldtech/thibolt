import 'package:get_it/get_it.dart';

import 'common/constants/strings.dart';
import 'data/datasources/app_database.dart';
import 'data/repository/workout_repository_impl.dart';
import 'domain/entities/category.dart';
import 'domain/repository/workout_repository.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  final db = await $FloorAppDatabase
      .databaseBuilder(databaseName)
      .build();

  await _seedInitialData(db);

  locator.registerSingleton<AppDatabase>(db);

  locator.registerSingleton<WorkoutRepository>(
    WorkoutRepositoryImpl(locator<AppDatabase>()),
  );
}

Future<void> _seedInitialData(AppDatabase db) async {
  var categories = await db.categoryDao.getCategories();
  if (categories.isEmpty) {
    db.categoryDao.insertCategory(
        WorkoutCategory(id: 1, name: 'swim', icon: 'swim.svg'));
    db.categoryDao.insertCategory(
        WorkoutCategory(id: 2, name: 'stretching', icon: 'stretching.svg'));
    db.categoryDao
        .insertCategory(WorkoutCategory(id: 3, name: 'core', icon: 'core.svg'));
  }
}
